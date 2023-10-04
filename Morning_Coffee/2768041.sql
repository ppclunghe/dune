--Name: stETH:ETH rate (Curve stETH pool)
--Description: 
--Parameters: []
with exchanges AS (
    SELECT
      date_trunc('minute', evt_block_time) AS time,
      sum(cast("tokens_sold" as double)) / sum(cast("tokens_bought" as double)) AS rate
    FROM
      curvefi_ethereum.steth_swap_evt_TokenExchange
    WHERE
      sold_id = int256 '0'
      AND "tokens_bought" > uint256 '10'
    GROUP BY 1
    UNION
    SELECT
      date_trunc('minute', evt_block_time) AS time,
      sum(cast("tokens_bought" as double))/ sum(cast("tokens_sold" as double)) AS rate
    FROM
      curvefi_ethereum.steth_swap_evt_TokenExchange
    WHERE
      sold_id = int256 '1'
      AND "tokens_sold" > uint256 '10'
    GROUP BY 1  
  )

select time, rate
from exchanges
where time >= now() - interval '7' day
 and rate <> 0
order by 1 desc
