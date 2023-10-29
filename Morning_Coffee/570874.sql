--Name: Lido staking APR 7days MA
--Description: 
--Parameters: []
/* 
This query calculates the daily value of Lido protocol APR, Lido instant staking APR, 
7-day AND 30-day moving average for Lido staking APR
 */
 
-- This CTE enerates a sequence of DATEs starting from '2022-09-10' up to the current DATE 
WITH
  calendar AS (
    with
      day_seq AS (
        SELECT
          (
            sequence(
              cast('2022-09-10' AS DATE),
              cast(now() AS DATE),
              interval '1' day
            )
          ) day
      )
  
    SELECT
      days.day
    FROM
      day_seq
      CROSS JOIN unnest (day) AS days (day)
  ),
  
  -- This CTE calculates pre AND post share rates for the stETH 
  shares AS (
    SELECT
      preTotalEther * 1e27 / preTotalShares AS pre_share_rate,
      postTotalEther * 1e27 / postTotalShares AS post_share_rate,
      *
    FROM
      lido_ethereum.steth_evt_TokenRebased
  ),
  
  -- This CTE combines data from the legacy oracle end the new V2 oracle, calculating APR values
  oracles_data AS (
    --legacy oracle
    SELECT
      "evt_block_time" AS time,
      cast(
        ("postTotalPooledEther" - "preTotalPooledEther") * 365 * 24 * 60 * 60 / ("preTotalPooledEther") AS double
      ) / timeElapsed * 100 AS protocol_apr,
      cast(
        ("postTotalPooledEther" - "preTotalPooledEther") * 365 * 24 * 60 * 60 / ("preTotalPooledEther") AS double
      ) / timeElapsed * 0.9 * 100 AS "Lido staking APR(instant)",
      "postTotalPooledEther",
      "preTotalPooledEther"
    FROM
      lido_ethereum.LegacyOracle_evt_PostTotalShares
    WHERE
      "evt_block_time" >= cast('2022-09-01 00:00' AS TIMESTAMP)
      AND "evt_block_time" <= cast('2023-05-16 00:00' AS TIMESTAMP)
      --new V2 oracle
    UNION all
    SELECT
      evt_block_time,
      (
        365 * 24 * 60 * 60 * (post_share_rate - pre_share_rate) / pre_share_rate / timeElapsed * 100
      ) / 0.9 AS protocol_apr,
      365 * 24 * 60 * 60 * (post_share_rate - pre_share_rate) / pre_share_rate / timeElapsed * 100 AS "Lido staking APR(instant)",
      preTotalEther,
      postTotalEther
    FROM
      shares
  )
  
-- final query selects and calculates various APR values using the data from oracles_data CTE,
-- including moving averages for Lido staking APR and protocol APR 
SELECT --o.*,
  o.time,
  o.protocol_apr,
  "Lido staking APR(instant)",
  AVG(o."Lido staking APR(instant)") over (
    ORDER BY
      o.time rows between 6 preceding
      AND current row
  ) AS "Lido staking APR(ma_7)",
  avg(o."Lido staking APR(instant)") over (
    ORDER BY
      o.time rows between 29 preceding
      AND current row
  ) AS "Lido staking APR(ma_30)",
  avg(o.protocol_apr) over (
    ORDER BY
      o.time rows between 6 preceding
      AND current row
  ) AS "protocol APR(ma_7)"
FROM
  oracles_data o
ORDER BY
  1 DESC