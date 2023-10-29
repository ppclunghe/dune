--Name: Tokens prices
--Description: 
--Parameters: []
/* 
This query returns latest price in USD for ETH, stETH, wstETH and LDO
from the 'prices.usd_latest' table 
*/
SELECT
  *
FROM
  (-- select the price of ETH (Ethereum)
    SELECT
      1 AS numb,
      price 
    FROM
      prices.usd_latest
    WHERE
      contract_address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
    UNION all
    -- select the price of stETH (staked Ether)
    SELECT
      2 AS numb,
      price 
    FROM
      prices.usd_latest
    WHERE
      contract_address = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84
    UNION all
    --select the price of wstETH (wrapped staked Ether)
    SELECT
      3 AS numb,
      price 
    FROM
      prices.usd_latest
    WHERE
      contract_address = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0
    UNION all
    --select the price of LDO (Lido native token)
    SELECT
      4 AS numb,
      price 
    FROM
      prices.usd_latest
    WHERE
      contract_address = 0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32
  )
ORDER BY
  1