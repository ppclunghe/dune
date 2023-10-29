--Name: Lido post Merge APR
--Description: Dune SQL
--Parameters: []
/* 
This query calculates post Merge protocol APR, Execution & Consensus Layers APRs,
displays the Compounding effect (Compounding EL rewards share in Protocol APR),
protocol APR moving average for 7-day, 14-day and 30-day.
*/

-- This CTE calculates the pre and post share rates (before and after token rebased event) 
WITH
  shares AS (
    SELECT
      (preTotalEther * 1e27) / CAST(preTotalShares AS DOUBLE) AS pre_share_rate,
      (postTotalEther * 1e27) / CAST(postTotalShares AS DOUBLE) AS post_share_rate,
      *
    FROM
      lido_ethereum.steth_evt_TokenRebased
  ),
  
  -- This CTE calculates the staking APR and Lido rewards 
  oracle_time AS (
    SELECT
      LAG(
        evt_block_time,
        1,
        evt_block_time - INTERVAL '24' hour
      ) OVER (
        ORDER BY
          evt_block_time NULLS FIRST
      ) AS time,
      evt_block_time AS next_time,
      (
        (postTotalPooledEther - preTotalPooledEther) * 365 * 24 * 60 * 60
      ) / CAST((preTotalPooledEther * timeElapsed) AS DOUBLE) AS staking_APR,
      (postTotalPooledEther - preTotalPooledEther) AS lido_rewards,
      preTotalPooledEther,
      postTotalPooledEther,
      timeElapsed
    FROM
      lido_ethereum.LegacyOracle_evt_PostTotalShares
    WHERE
      evt_block_time >= CAST(
        CAST(
          CAST('2022-09-01 12:00' AS TIMESTAMP) AS TIMESTAMP
        ) AS DATE
      )
      AND evt_block_time <= CAST(
        CAST(
          CAST('2023-05-16 00:00' AS TIMESTAMP) AS TIMESTAMP
        ) AS DATE
      )
    UNION ALL
    SELECT
      LAG(
        d.evt_block_time,
        1,
        d.evt_block_time - INTERVAL '24' hour
      ) OVER (
        ORDER BY
          d.evt_block_time NULLS FIRST
      ) AS time,
      d.evt_block_time AS next_time,
      (
        365 * 24 * 60 * 60 * (s.post_share_rate - s.pre_share_rate)
      ) / CAST(
        (s.pre_share_rate * s.timeElapsed * 0.9) AS DOUBLE
      ),
      withdrawalsWithdrawn + postCLBalance - preCLBalance + executionLayerRewardsWithdrawn AS lido_rewards,
      r.preTotalEther,
      r.postTotalEther,
      r.timeElapsed
    FROM
      lido_ethereum.steth_evt_ETHDistributed AS d
      LEFT JOIN lido_ethereum.steth_evt_TokenRebased AS r ON d.evt_tx_hash = r.evt_tx_hash
      LEFT JOIN shares AS s ON d.evt_tx_hash = s.evt_tx_hash
  ),
  
  -- This CTE calculates rewards withdrawn
  rewards_by_call AS (
    SELECT
      oracle.next_time AS time,
      COALESCE(SUM(TRY_CAST(output_amount AS double)), 0) AS withdrawn_rewards,
      SUM(COALESCE(SUM(TRY_CAST(output_amount AS double)), 0)) OVER (
        ORDER BY
          oracle.next_time NULLS FIRST
      ) AS cumul_rewards
    FROM
      oracle_time AS oracle
      LEFT JOIN lido_ethereum.LidoExecutionLayerRewardsVault_call_withdrawRewards AS el ON el.call_block_time > oracle.time
      AND el.call_block_time <= oracle.next_time
    WHERE
      NOT oracle.time IS NULL
      AND el.call_success = TRUE
    GROUP BY
      1
  ),
  
  -- This CTE computes the sum of submitted (deposited) amounts
  submitted AS (
    SELECT
      oracle.next_time AS time,
      SUM(TRY_CAST(amount AS double)) AS submitted
    FROM
      oracle_time AS oracle
      LEFT JOIN lido_ethereum.steth_evt_Submitted AS dep ON dep.evt_block_time < oracle.next_time
    WHERE
      NOT oracle.time IS NULL
    GROUP BY
      1
  ),
  
  -- This CTE computes the sum of finalized withdrawals
  withdrawals_finalized AS (
    SELECT
      oracle.next_time AS time,
      SUM(TRY_CAST(amountOfETHLocked AS double)) AS withdraw_finalized
    FROM
      oracle_time AS oracle
      LEFT JOIN lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized AS wth ON wth.evt_block_time <= oracle.next_time
    WHERE
      NOT oracle.time IS NULL
    GROUP BY
      1
  ),
  
  -- This CTE calculates net deposits from previous CTEs 
  net_deposits AS (
    SELECT
      time,
      SUM(submitted) AS amount
    FROM
      (
        SELECT
          time,
          submitted
        FROM
          submitted
        UNION ALL
        SELECT
          time,
          (-1) * withdraw_finalized
        FROM
          withdrawals_finalized
      )
    GROUP BY
      1
  )
  
-- final SELECT statement combines previous CTEs and calculates the total pooled ether, user deposits, restaked rewards,
-- stETH rebasing, total rewards, protocol APR, CL rewards, CL APR, EL rewards, EL APR, rewards on deposits, 
-- rewards on restaked rewards, moving averages of the protocol APR for 7-day, 14-day, and 30-day periods  
SELECT
  DATE_TRUNC('day', oracle_time.next_time) AS time,
  (
    cast(preTotalPooledEther as double) - COALESCE(cast(wth.amountOfETHLocked as double), 0)
  ) / CAST(1e18 AS DOUBLE) AS TotalPooledEther,
  cast(net_deposits.amount as double) / CAST(1e18 AS DOUBLE) AS UsersDeposits,
  cast(cumul_rewards as double)/ CAST(1e18 AS DOUBLE) AS RestakedRewards,
  (
    cast(preTotalPooledEther as double)- cast(cumul_rewards as double) - cast(net_deposits.amount as double)
  ) / CAST(1e18 AS DOUBLE) AS stETHrebasing,
  cast(lido_rewards as double) / CAST(1e18 AS DOUBLE) AS total_rewards,
  cast(lido_rewards as double) / CAST(
    (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) * timeElapsed
    ) AS DOUBLE
  ) * 365 * 24 * 60 * 60 AS protocolAPR,
  (lido_rewards - withdrawn_rewards) / CAST(1e18 AS DOUBLE) AS CL_rewards,
  (lido_rewards - withdrawn_rewards) / CAST(
    (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) * timeElapsed
    ) AS DOUBLE
  ) * 365 * 24 * 60 * 60 AS CL_APR,
  withdrawn_rewards / CAST(1e18 AS DOUBLE) AS EL_rewards,
  withdrawn_rewards / CAST(
    (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) * timeElapsed
    ) AS DOUBLE
  ) * 365 * 24 * 60 * 60 AS EL_APR,
  lido_rewards * (
    net_deposits.amount + (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) - cumul_rewards - net_deposits.amount
    ) * net_deposits.amount / (cumul_rewards + net_deposits.amount)
  ) / (
    preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
  ) / CAST(1e18 AS DOUBLE) AS RewardsOnDeposits,
  lido_rewards * (
    cumul_rewards + (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) - cumul_rewards - net_deposits.amount
    ) * cumul_rewards / (cumul_rewards + net_deposits.amount)
  ) / (
    preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
  ) / CAST(1e18 AS DOUBLE) AS RewardsOnRestakedRewards,
  lido_rewards * (
    net_deposits.amount + (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) - cumul_rewards - net_deposits.amount
    ) * net_deposits.amount / (cumul_rewards + net_deposits.amount)
  ) / (
    preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
  ) / CAST(
    (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) * timeElapsed
    ) AS DOUBLE
  ) * 365 * 24 * 60 * 60 AS protocolAPR_withoutRestakedRewards,
  lido_rewards * (
    cumul_rewards + (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) - cumul_rewards - net_deposits.amount
    ) * cumul_rewards / (cumul_rewards + net_deposits.amount)
  ) / (
    preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
  ) / CAST(
    (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) * timeElapsed
    ) AS DOUBLE
  ) * 365 * 24 * 60 * 60 AS RestakedRewardsEffect,
  (
    cumul_rewards + (
      (
        preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
      ) - cumul_rewards - net_deposits.amount
    ) * cumul_rewards / (cumul_rewards + net_deposits.amount)
  ) / CAST(
    (
      preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
    ) AS DOUBLE
  ) AS RestakedRewardsEffect_percent,
  CONCAT(
    format('%,.3f%%',
      ROUND(
        lido_rewards / CAST(
          (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) * timeElapsed
          ) AS DOUBLE
        ) * 365 * 24 * 60 * 60 * TRY_CAST(100 AS DECIMAL),
        3
      ) 
    ),
    ' / ',
    format('%,.3f%%',
      ROUND(
        (lido_rewards - withdrawn_rewards) / CAST(
          (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) * timeElapsed
          ) AS DOUBLE
        ) * 365 * 24 * 60 * 60 * TRY_CAST(100 AS DECIMAL),
        3
      ) 
    ),
    ' / ' ,
    format('%,.3f%%',
      ROUND(
        withdrawn_rewards / CAST(
          (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) * timeElapsed
          ) AS DOUBLE
        ) * 365 * 24 * 60 * 60 * TRY_CAST(100 AS DECIMAL),
        3
      ) 
    ),
    '%'
  ) AS APRbyLayers,
  CONCAT(
    format('%,.3f%%',
      ROUND(
        lido_rewards / CAST(
          (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) * timeElapsed
          ) AS DOUBLE
        ) * 365 * 24 * 60 * 60 * TRY_CAST(100 AS DECIMAL),
        3
      ) 
    ),
    ' / ' ,
    format('%,.3f%%',
      ROUND(
        lido_rewards * (
          net_deposits.amount + (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) - cumul_rewards - net_deposits.amount
          ) * net_deposits.amount / (cumul_rewards + net_deposits.amount)
        ) / (
          preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
        ) / CAST(
          (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) * timeElapsed
          ) AS DOUBLE
        ) * 365 * 24 * 60 * 60 * TRY_CAST(100 AS DECIMAL),
        3
      ) 
    ),
    ' / ' ,
    format('%,.3f%%',
      ROUND(
        lido_rewards * (
          cumul_rewards + (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) - cumul_rewards - net_deposits.amount
          ) * cumul_rewards / (cumul_rewards + net_deposits.amount)
        ) / (
          preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
        ) / CAST(
          (
            (
              preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
            ) * timeElapsed
          ) AS DOUBLE
        ) * 365 * 24 * 60 * 60 * TRY_CAST(100 AS DOUBLE),
        3
      ) 
    )
    
  ) AS APRbyBase,
  
    CAST(
    ROUND((cumul_rewards + ((preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)) - cumul_rewards - net_deposits.amount) * 
    cumul_rewards / (cumul_rewards + net_deposits.amount)) / 
    CAST((preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)) AS DOUBLE) * TRY_CAST(100 AS Double),3) AS VARCHAR) AS RestakedRewardsEffect_percent_counter,
  AVG(lido_rewards / CAST(((preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)) * timeElapsed) AS DOUBLE) * 365 * 24 * 60 * 60) OVER (ORDER BY oracle_time.next_time NULLS FIRST rows BETWEEN 6 preceding  AND CURRENT ROW  ) AS protocolAPR_ma_7,
  AVG(
    lido_rewards / CAST(
      (
        (
          preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
        ) * timeElapsed
      ) AS DOUBLE
    ) * 365 * 24 * 60 * 60
  ) OVER (
    ORDER BY
      oracle_time.next_time NULLS FIRST rows BETWEEN 9 preceding
      AND CURRENT ROW
  ) AS protocolAPR_ma_10,
  AVG(
    lido_rewards / CAST(
      (
        (
          preTotalPooledEther - COALESCE(cast(wth.amountOfETHLocked as double), 0)
        ) * timeElapsed
      ) AS DOUBLE
    ) * 365 * 24 * 60 * 60
  ) OVER (
    ORDER BY
      oracle_time.next_time NULLS FIRST rows BETWEEN 13 preceding
      AND CURRENT ROW
  ) AS protocolAPR_ma_14,
  submitted / CAST(1e18 AS DOUBLE) - LAG(submitted / CAST(1e18 AS DOUBLE)) OVER (
    ORDER BY
      oracle_time.next_time NULLS FIRST
  ) AS Lido_gross_deposits,
  timeElapsed
FROM
  oracle_time
  LEFT JOIN rewards_by_call ON rewards_by_call.time = oracle_time.next_time
  LEFT JOIN submitted ON submitted.time = oracle_time.next_time
  LEFT JOIN net_deposits ON net_deposits.time = oracle_time.next_time
  LEFT JOIN lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized AS wth ON wth.evt_block_time = oracle_time.next_time
ORDER BY  1 

