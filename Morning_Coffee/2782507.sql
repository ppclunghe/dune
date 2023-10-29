--Name: Locked in DeFi
--Description: 
--Parameters: []
/* 
This query calculates various metrics related to stETH locked in DeFi, including:
- the total amount of stETH locked in DeFi;
- changes of stETH amount locked in DeFi over 1-day AND 7-day periods
- current stETH locked in LENDing market AND Liquidity pool
- changes in reserves in the LENDing market AND Liquidity pool over 1-day AND 7-day periods
 */
-- This CTE generates a sequence of dates for the last 7 days
with
  dates AS (
    -- This inner CTE generates a sequence of days within the last 7 days with 1-day intervals
    with
      day_seq AS (
        SELECT
          (
            sequence(
              current_date - interval '7' day,
              current_date,
              interval '1' day
            )
          ) AS day
      )
      -- SELECTs the individual dates from the day_seq CTE
    SELECT
      days.day
    FROM
      day_seq
      CROSS JOIN unnest (day) AS days (day)
  )
  -- This CTE retrieves data related to wrapped/unwrapped stETH transactions
,
  volumes AS (
    SELECT
      u.call_block_time AS time,
      "output_0" AS steth,
      "_wstETHAmount" AS wsteth
    FROM
      lido_ethereum.WstETH_call_unwrap u
    WHERE
      "call_success" = TRUE
    UNION all
    SELECT
      u."call_block_time",
      "_stETHAmount" AS steth,
      "output_0" AS wsteth
    FROM
      lido_ethereum.WstETH_call_wrap u
    WHERE
      "call_success" = TRUE
  )
  -- This CTE calculates the rate of stETH to wstETH over time with 1-day intervals
,
  wsteth_rate AS (
    SELECT
      day,
      rate AS rate0,
      value_partition,
      first_value(rate) over (
        partition by
          value_partition
        ORDER BY
          day
      ) AS rate,
      lead(
        day,
        1,
        date_trunc('day', now() + interval '1' day)
      ) over (
        ORDER BY
          day
      ) AS next_day
    FROM
      (
        SELECT
          day,
          rate,
          SUM(
            CASE
              WHEN rate is NULL THEN 0
              ELSE 1
            END
          ) over (
            ORDER BY
              day
          ) AS value_partition
        FROM
          (
            SELECT
              date_trunc('day', d.day) AS day,
              SUM(cast(steth AS DOUBLE)) / SUM(cast(wsteth AS DOUBLE)) AS rate
            FROM
              dates d
              LEFT JOIN volumes v ON date_trunc('day', v.time) = date_trunc('day', d.day)
            GROUP BY
              1
          )
      )
  ),
  
  -- This CTE calculate the amount of stETH reserves in the Lending market and Liquidity pool
  historical_liquidity AS (
    SELECT
      *,
      lead(time, 1, current_date + interval '1' day) over (
        partition by
          pool
        ORDER BY
          time
      ) AS next_time
    FROM
      lido.liquidity 
  ),
  
  -- This CTE calculates the stETH reserves 7 days ago in the Lending market and Liquidity pool
  d7ago_liquiidity AS (
    SELECT
      SUM(
        CASE
          WHEN lower(main_token_symbol) = 'steth' then main_token_reserve
          ELSE wsteth_rate.rate * main_token_reserve
        END
      ) AS steth_reserves
    FROM
      dates d
      LEFT JOIN historical_liquidity l ON date_trunc('day', d.day) >= date_trunc('day', l.time)
      AND date_trunc('day', d.day) < date_trunc('day', l.next_time)
      LEFT JOIN wsteth_rate ON d.day = wsteth_rate.day
    WHERE
      d.day = current_date - interval '7' day
  ),
  
  -- This CTE calculates the stETH reserves 1 day ago in the Lending market and Liquidity pool
  d1ago_liquiidity AS (
    SELECT
      SUM(
        CASE
          WHEN lower(main_token_symbol) = 'steth' then main_token_reserve
          ELSE wsteth_rate.rate * main_token_reserve
        END
      ) AS steth_reserves
    FROM
      dates d
      LEFT JOIN historical_liquidity l ON date_trunc('day', d.day) >= date_trunc('day', l.time)
      AND date_trunc('day', d.day) < date_trunc('day', l.next_time)
      LEFT JOIN wsteth_rate ON d.day = wsteth_rate.day
    WHERE
      d.day = current_date - interval '1' day
  ),
  
  -- This CTE calculates the current stETH reserves in the Lending market and Liquidity pool
  current_liquiidity AS (
    SELECT
      SUM(
        CASE
          WHEN lower(main_token_symbol) = 'steth' then main_token_reserve
          ELSE wsteth_rate.rate * main_token_reserve
        END
      ) AS steth_reserves
    FROM
      dates d
      LEFT JOIN historical_liquidity l ON date_trunc('day', d.day) >= date_trunc('day', l.time)
      AND date_trunc('day', d.day) < date_trunc('day', l.next_time)
      LEFT JOIN wsteth_rate ON d.day = wsteth_rate.day
    WHERE
      d.day = current_date
  ),
  
  -- This CTE calculates the stETH collateral 7 days ago in the Lending market
  d7ago_lending AS (
    SELECT
      SUM(amount) AS steth_collateral
    FROM
      dates d
      LEFT JOIN dune.lido.result_wsteth_in_lENDing_pools l
      ON date_trunc('day', d.day) = date_trunc('day', l.time)
    WHERE
      d.day = current_date - interval '7' day
  ),
  
 -- This CTE calculates the stETH collateral 1 day ago in the Lending market 
  d1ago_lending AS (
    SELECT
      SUM(amount) AS steth_collateral
    FROM
      dates d
      LEFT JOIN dune.lido.result_wsteth_in_lENDing_pools l
      ON date_trunc('day', d.day) = date_trunc('day', l.time)
    WHERE
      d.day = current_date - interval '1' day
  ),
  
  -- This CTE calculates the current stETH collateral in the Lending market.
  current_lending AS (
    SELECT
      SUM(amount) AS steth_collateral
    FROM
      dates d
      LEFT JOIN dune.lido.result_wsteth_in_lENDing_pools l
      ON date_trunc('day', d.day) = date_trunc('day', l.time)
    WHERE
      d.day = current_date
  ),
  
 -- This CTE gathers all the calculated metrics into one table. 
  all_metrics AS (
    SELECT
      (
        SELECT
          steth_reserves
        FROM
          d7ago_liquiidity
      ) AS reserves_7d_ago,
      (
        SELECT
          steth_reserves
        FROM
          d1ago_liquiidity
      ) AS reserves_1d_ago,
      (
        SELECT
          steth_reserves
        FROM
          current_liquiidity
      ) AS reserves_current,
      (
        SELECT
          steth_collateral
        FROM
          d7ago_lending
      ) AS collateral_7d_ago,
      (
        SELECT
          steth_collateral
        FROM
          d1ago_lending
      ) AS collateral_1d_ago,
      (
        SELECT
          steth_collateral
        FROM
          current_lending
      ) AS collateral_current
  )
  
-- final SELECT statement computes daily and weekly changes in reserves and collateral, 
-- the total stETH locked in DeFi, and their daily and weekly changes  
SELECT
  reserves_current,
  reserves_7d_ago,
  reserves_current - reserves_7d_ago AS change_reserves_7d,
  100 * (reserves_current - reserves_7d_ago) / reserves_7d_ago AS prc_change_reserves_7d,
  reserves_1d_ago,
  reserves_current - reserves_1d_ago AS change_reserves_1d,
  100 * (reserves_current - reserves_1d_ago) / reserves_1d_ago AS prc_change_reserves_1d,
  collateral_current,
  collateral_current - collateral_7d_ago AS change_collateral_7d,
  100 * (collateral_current - collateral_7d_ago) / collateral_7d_ago AS prc_change_collateral_7d,
  collateral_current - collateral_1d_ago AS change_collateral_1d,
  100 * (collateral_current - collateral_1d_ago) / collateral_1d_ago AS prc_change_collateral_1d,
  collateral_current + reserves_current AS locked_in_defi_current,
  (
    collateral_current + reserves_current - reserves_7d_ago - collateral_7d_ago
  ) AS locked_in_defi_change_7d,
  (
    collateral_current + reserves_current - reserves_1d_ago - collateral_1d_ago
  ) AS locked_in_defi_change_1d,
  format(
    '%,.0f',
    round(
      coalesce(collateral_current + reserves_current, 0),
      0
    )
  ) || ' stETH / ' || format(
    '%,.2f',
    round(
      coalesce(
        100 * (
          collateral_current + reserves_current - reserves_1d_ago - collateral_1d_ago
        ) / (reserves_1d_ago + collateral_1d_ago),
        0
      ),
      2
    )
  ) || '% / ' || format(
    '%,.2f',
    round(
      coalesce(
        100 * (
          collateral_current + reserves_current - reserves_7d_ago - collateral_7d_ago
        ) / (reserves_7d_ago + collateral_7d_ago),
        0
      ),
      2
    )
  ) || '%' AS widget
FROM
  all_metrics