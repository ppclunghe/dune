--Name: Reserves of tokens paired to (w)stETH in liquidity pools
--Description: 
--Parameters: []
/* This query retrieves data related to the current reserves of tokens paired with (w)stETH in USD and 
calculates the changes in reserves over 1 day and 7 days, 
expressed AS both absolute values and percentages */
with
  -- This CTE calculates the SUM of the paired token's USD reserve for the moment 7d ago
  d7ago_liquiidity AS (
    SELECT
      SUM(paired_token_usd_reserve) AS paired_token_usd_reserve
    FROM
      lido.liquidity l
    WHERE
      l.time = (
        SELECT
          MAX(time) - interval '7' day
        FROM
          lido.liquidity
      )
  )
  -- This CTE calculates the SUM of the paired token's USD reserve for the moment 1d ago
,
  d1ago_liquiidity AS (
    SELECT
      SUM(paired_token_usd_reserve) AS paired_token_usd_reserve
    FROM
      lido.liquidity l
    WHERE
      l.time = (
        SELECT
          MAX(time) - interval '1' day
        FROM
          lido.liquidity
      )
  )
  -- This CTE calculates the SUM of the paired token's USD reserve for the current date
,
  current_liquiidity AS (
    SELECT
      SUM(paired_token_usd_reserve) AS paired_token_usd_reserve
    FROM
      lido.liquidity l
    WHERE
      l.time = current_date
  )
  -- This CTE combines the results FROM previous CTEs 
,
  all_metrics AS (
    SELECT
      (
        SELECT
          paired_token_usd_reserve
        FROM
          d7ago_liquiidity
      ) AS reserves_7d_ago,
      (
        SELECT
          paired_token_usd_reserve
        FROM
          d1ago_liquiidity
      ) AS reserves_1d_ago,
      (
        SELECT
          paired_token_usd_reserve
        FROM
          current_liquiidity
      ) AS reserves_current
  )
  -- SELECT and FORMAT the final results
SELECT
  reserves_current,
  reserves_current - reserves_7d_ago AS change_reserves_7d,
  100 * (reserves_current - reserves_7d_ago) / reserves_7d_ago AS prc_change_reserves_7d,
  reserves_current - reserves_1d_ago AS change_reserves_1d,
  100 * (reserves_current - reserves_1d_ago) / reserves_1d_ago AS prc_change_reserves_1d,
  '$' || FORMAT('%,.0f', ROUND(COALESCE(reserves_current, 0), 0)) || ' / ' || FORMAT(
    '%,.2f',
    ROUND(
      COALESCE(
        100 * (reserves_current - reserves_1d_ago) / (reserves_1d_ago),
        0
      ),
      2
    )
  ) || '% / ' || FORMAT(
    '%,.2f',
    ROUND(
      COALESCE(
        100 * (reserves_current - reserves_7d_ago) / (reserves_7d_ago),
        0
      ),
      2
    )
  ) || '%' AS widget
FROM
  all_metrics