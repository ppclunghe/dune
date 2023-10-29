--Name: Top addresses
--Description: Staking transactions, withdrawals, and DEX trade activities > 10k stETH
--Parameters: []
/* 
This query returns addresses with (w)stETH transactions (staked, withdrawn, transferred) with amounts greater than 10,000 for the last 24H
 */
--Need to convert wstETH to stETH, update amount 5k -> 10k
-- This CTE combaines stETH staking, withdrawal, buying and selling transactions
with
  events AS (
    -- this part retrives stETH staking transactions
    SELECT
      t."from" AS address,
      SUM(amount) / 1e18 AS staked,
      0 AS withdrawn,
      0 AS bought,
      0 AS sold
    FROM
      lido_ethereum.steth_evt_Submitted s
      JOIN ethereum.transactions t ON t.hash = s.evt_tx_hash
    WHERE
      evt_block_time >= now() - interval '24' hour
    GROUP BY
      1
    HAVING
      SUM(amount) / 1e18 >= 10000
    UNION all
    -- this part retrieves stETH withdrawal transaction
    SELECT
      owner,
      0,
      SUM(cast(amountOfStETH AS DOUBLE)) / 1e18,
      0,
      0
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
    WHERE
      evt_block_time >= now() - interval '24' hour
    GROUP BY
      1
    HAVING
      SUM(cast(amountOfStETH AS DOUBLE)) / 1e18 >= 10000
    UNION all
    -- this part retrieves stETH buying transactions
    SELECT
      tx_to,
      0,
      0,
      SUM(token_bought_amount),
      0
    FROM
      dex.trades
    WHERE
      block_time >= now() - interval '24' hour
      AND lower(token_bought_symbol) in ('steth', 'wsteth')
      AND blockchain = 'ethereum'
    GROUP BY
      1
    HAVING
      SUM(token_bought_amount) >= 10000
    UNION all
    -- this part retrieves stETH selling transactions
    SELECT
      tx_to,
      0,
      0,
      0,
      SUM(token_sold_amount)
    FROM
      dex.trades
    WHERE
      block_time >= now() - interval '24' hour
      AND lower(token_sold_symbol) in ('steth', 'wsteth')
      AND blockchain = 'ethereum'
    GROUP BY
      1
    HAVING
      SUM(token_sold_amount) >= 10000
  )
  -- final query calculate the net change in staked, withdrawn, bought, and sold stETH transactions for each address  
SELECT
  address,
  SUM(staked) AS staked,
  SUM(withdrawn) AS withdrawn,
  SUM(bought) AS bought,
  SUM(sold) AS sold,
  SUM(staked) - SUM(withdrawn) + SUM(bought) - SUM(sold) AS change
FROM
  events
GROUP BY
  1
ORDER BY
  6 DESC