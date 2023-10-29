--Name: Lido APR breakdown
--Description: 
--Parameters: []
/* 
This query returns current value of Lido staking APR, 7-day moving average for Lido staking APR, 
values of Consensus Layer (CL) APR and Execution Layer (EL) APR
 */
-- This CTE gets the Consensus Layer (CL) and Execution Layer (EL) APR values
-- from the 'query_1288160' (Lido post Merge APR) for the past 7d
with
  breakdown_apr as (
    SELECT
      time,
      CL_APR,
      EL_APR
    FROM
      query_1288160
    WHERE
      time >= date_trunc('day', now()) - interval '7' day
  )
  -- This CTE retrives Lido staking APR values over the past 7d from 'query_570874' (Lido staking APR 7d MA)
,
  staking_apr AS (
    SELECT
      *
    FROM
      query_570874
    WHERE
      time >= now() - interval '7' day
  )
  -- SELECT APR values both Lido staking and CL/EL 
SELECT
  cast(date_trunc('day', s.time) AS TIMESTAMP) AS time,
  s."Lido staking APR(instant)",
  s."Lido staking APR(ma_7)",
  100 * b.CL_APR AS "CL APR",
  100 * b.EL_APR AS "EL APR"
FROM
  staking_apr s
  LEFT JOIN breakdown_apr b ON date_trunc('day', s.time) = date_trunc('day', b.time)
ORDER BY
  1