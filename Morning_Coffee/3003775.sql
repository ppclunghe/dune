--Name: wstETH:stETH rate
--Description: 
--Parameters: []
/* 
This query returns the current wstETH:stETH exchange rate
 */
-- Combines data from unwrapping and wrapping wstETH transactions, 
-- groups the data by day and calculates the rate
SELECT
  time,
  sum(steth) / sum(wsteth) AS rate
FROM
  (
    -- unwrapping wstETH transactions
    SELECT
      date_trunc('day', call_block_time) AS time,
      COALESCE(CAST("output_0" AS DOUBLE), 0) AS steth,
      COALESCE(CAST("_wstETHAmount" AS DOUBLE), 0) AS wsteth
    FROM
      lido_ethereum.WstETH_call_unwrap
    WHERE
      call_success = TRUE
    UNION all
    -- wrapping wstETH transactions 
    SELECT
      date_trunc('day', call_block_time) AS time,
      COALESCE(CAST("_stETHAmount" AS DOUBLE), 0) AS steth,
      COALESCE(CAST("output_0" AS DOUBLE), 0) AS wsteth
    FROM
      lido_ethereum.WstETH_call_wrap
    WHERE
      "call_success" = TRUE
  )
GROUP BY
  1
ORDER BY
  1 DESC
LIMIT
  1