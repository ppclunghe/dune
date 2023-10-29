--Name: (w)stETH 7d trading volume dynamics
--Description: 
--Parameters: []
/* 
This query calculates the trading volume in USD for 'wsteth' and 'steth' tokens over the last 7 days 
   and also computes the 7-day moving average in USD
 */
-- THIS CTE generates a sequence of hours in the past 15 days 
with
  hours AS (
  -- This inner CTE generates a sequence of hours between now - 360 hours and now, with 1-hour intervals
    with
      hour_seq AS (
        SELECT
          (
            sequence(
              cast(
                date_trunc('hour', now() - interval '360' hour) AS TIMESTAMP
              ),
              cast(date_trunc('hour', now()) AS TIMESTAMP),
              interval '1' hour
            )
          ) hour
      )
    -- selects the individual hours from the hour_seq CTE  
    SELECT
      hours.hour
    FROM
      hour_seq
      CROSS JOIN unnest (hour) AS hours (hour)
  ),
  
  -- This CTE calculates trading volumes for 'wsteth' and 'steth' tokens, grouped by the hour and day
  volumes AS (
    SELECT
      date_trunc('hour', block_time) AS time,
      block_date AS day,
      sum(amount_usd) AS volume
    FROM
      dex.trades
    WHERE
      (
        lower(token_sold_symbol) in ('wsteth', 'steth')
        OR lower(token_bought_symbol) in ('wsteth', 'steth')
      )
      AND date_trunc('day', block_date) >= date_trunc('day', now()) - interval '15' day
    GROUP BY
      1,
      2
  ),
  
  -- This CTE joins the 'hours' CTE with 'volumes' CTE  and computes a 7-day moving average (168 hours)
  volumes_with_ma AS (
    SELECT
      hours.hour,
      time,
      volume,
      avg(volume) over (
        ORDER BY  
          time rows between 167 preceding
          AND current row
      ) AS ma168h
    FROM
      hours
      LEFT JOIN volumes ON date_trunc('hour', hours.hour) = date_trunc('hour', volumes.time)
    ORDER BY  
      time
  )
  
-- final query selects the calculated trading volumes, and the 7-day moving average for the last 7 days  
SELECT
  time,
  volume,
  ma168h AS ma_7d
FROM
  volumes_with_ma
WHERE
  time >= cast(
    date_trunc('hour', now()) - interval '168' hour AS DATE
  )