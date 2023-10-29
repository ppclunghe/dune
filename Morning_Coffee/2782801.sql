--Name: Current liquidity reserves by pair
--Description: *paired tokens $ reserves in liquidity pools
--Parameters: []
/* This query returns the current reserves of paired tokens in USD in liquidity pools */
-- This CTE generates a sequence of dates for the last 7 days
with
  dates AS (
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
  ),
  
  -- This CTE retrieves data related to wrapped/unwrapped stETH transactions
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
  ),
  
  -- This CTE calculates the rate of stETH to wstETH over time with 1-day intervals
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
          sum(
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
              sum(cast(steth AS DOUBLE)) / sum(cast(wsteth AS DOUBLE)) AS rate
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
  )
 
 --This final query calculates the current liquidity reserves for each pair of tokens
SELECT
  COALESCE(
    CASE
      WHEN lower(l.paired_token_symbol) in ('weth', 'eth', 'bb-a-weth') THEN '(W)ETH'
      WHEN lower(l.paired_token_symbol) = '' THEN 'unknown'
      ELSE l.paired_token_symbol
    END || '/' || 'stETH',
    'one-sided stETH'
  ) AS pair,
  sum(paired_token_usd_reserve) AS reserves
FROM
  dates d
  LEFT JOIN historical_liquidity l ON date_trunc('day', d.day) >= date_trunc('day', l.time)
  AND date_trunc('day', d.day) < date_trunc('day', l.next_time)
  LEFT JOIN wsteth_rate ON d.day = wsteth_rate.day
WHERE
  d.day = current_date
GROUP BY
  1
  --)