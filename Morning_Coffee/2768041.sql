--Name: stETH:ETH rate (Curve stETH pool)
--Description: 
--Parameters: []
/* 
This query returns the minutely stETH to ETH rate in Curve pool for the last 7 days
*/
-- This CTE combines data for stETH to ETH and ETH to stETH exchanges
with exchanges AS (
    -- subquery calculates the stETH to ETH exchange rate
    SELECT
      date_trunc('minute', evt_block_time) AS time,
      SUM(cast("tokens_sold" AS DOUBLE)) / SUM(cast("tokens_bought" AS DOUBLE)) AS rate
    FROM
      curvefi_ethereum.steth_swap_evt_TokenExchange
    WHERE
      sold_id = int256 '0'
      AND "tokens_bought" > uint256 '10'
    GROUP BY 1
    -- subquery calculates the ETH to stETH exchange rate
    UNION
    SELECT
      date_trunc('minute', evt_block_time) AS time,
      SUM(cast("tokens_bought" AS DOUBLE))/ SUM(cast("tokens_sold" AS DOUBLE)) AS rate
    FROM
      curvefi_ethereum.steth_swap_evt_TokenExchange
    WHERE
      sold_id = int256 '1'
      AND "tokens_sold" > uint256 '10'
    GROUP BY 1  
  )
-- Selects and filters the exchange rate data from the 'exchanges' CTE for the last 7 days
SELECT time, rate
FROM exchanges
WHERE time >= now() - interval '7' day
 AND rate <> 0
ORDER BY 1 DESC
