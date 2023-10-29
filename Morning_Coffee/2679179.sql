--Name: Lido net deposits change
--Description: 
--Parameters: []
/*
This query calculates the percentage changes in the amoutn of ETH staked with Lido over the past 24h 
and past 7d
 */
-- This CTE retrieves the most recent data from the 'query_2111543'(ETH staked with Lido (deposits + protocol buffer)) 
-- and orders it by 'day' column in descending order
with
  eth_current_amount AS (
    SELECT
      *
    FROM
      query_2111543
    ORDER BY
      day DESC
    LIMIT
      1
  )
  -- This CTE gets the amount of ETH staked with Lido 7d ago from the 'query_2768378',
  -- and the amount of ETH staked with Lido 24h ago from the 'query_2768351',
  -- then organize and label the data for clarity
,
  all_eth_metrics AS (
    SELECT
      lido_amount AS current_amount,
      (
        SELECT
          lido_amount
        FROM
          query_2768378
      ) AS amount_7d_ago, 
      (
        SELECT
          lido_amount
        FROM
          query_2768351
      ) AS amount_24h_ago 
    FROM
      eth_current_amount
  )
  
  -- SELECT and FORMAT the final results
SELECT
  'ETH' AS token,
  current_amount,
  (current_amount - amount_24h_ago) / amount_24h_ago AS change_24h,
  (current_amount - amount_7d_ago) / amount_7d_ago AS change_7d
FROM
  all_eth_metrics
  --union all 
  --SELECT * FROM query_2768425