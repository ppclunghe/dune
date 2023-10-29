--Name: (w)stETH 7d trading volume dynamics (breakdown)
--Description: 
--Parameters: []
/* 
This query calculates cumulative trading volume in USD for 'wsteth' and 'steth' tokens over the last 7 days, 
broken down by project
 */
-- This CTE generates a sequence of hours for the last 7 days 
with
  dates AS (
    -- This inner CTE generates a sequence of hours within the last 7 days with 1-hour intervals
    with
      hour_seq AS (
        SELECT
          (
            SEQUENCE(
              CAST(
                date_trunc('day', now()) - interval '7' day AS TIMESTAMP
              ),
              CAST(now() AS TIMESTAMP),
              INTERVAL '1' hour
            )
          ) AS hour
      )
      -- selects the individual hours from the hour_seq CTE   
    SELECT
      hours.hour
    FROM
      hour_seq
      CROSS JOIN unnest (hour) AS hours (hour)
  ),
  -- This CTE calculates the trading volume for 'wsteth' and 'steth' tokens, grouped by hour, day, and project.
  trades AS (
    SELECT
      date_trunc('hour', block_time) AS time,
      block_date,
      project,
      SUM(amount_usd) AS volume
    FROM
      dex.trades
    WHERE
      (
        lower(token_sold_symbol) in ('wsteth', 'steth')
        OR lower(token_bought_symbol) in ('wsteth', 'steth')
      )
      AND date_trunc('day', block_date) >= date_trunc('day', now()) - interval '7' day
      AND project NOT in ('Bancor Network', '0x API')
    GROUP BY
      1,
      2,
      3
  ),
  -- This CTE associates each hour with distinct projects.
  dates_per_venue AS (
    SELECT
      hour,
      project
    FROM
      dates
      LEFT JOIN (
        SELECT distinct
          project
        FROM
          trades
      ) ON 1 = 1
  )
  -- final query selects the time, project, and cumulative volume for each project and hour, filling in missing values with 0.
SELECT
  d.hour AS time,
  d.project,
  COALESCE(volume, 0) AS volume,
  SUM(COALESCE(volume, 0)) over (
    partition by
      d.project
    ORDER BY
      d.hour
  ) AS "cumulative volume"
FROM
  dates_per_venue d
  LEFT JOIN trades t on d.hour = date_trunc('hour', t.time)
  AND d.project = t.project
ORDER BY
  1