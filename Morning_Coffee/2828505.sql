--Name: Tokens prices
--Description: 
--Parameters: []
/* This query returns latest price in USD for ETH, stETH, wstETH and LDO */
select * from (
select 1 as numb, price --ETH
from prices.usd_latest
where contract_address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
union all
select 2 as numb, price --stETH
from prices.usd_latest
where contract_address = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84
union all
select 3 as numb, price --wstETH
from prices.usd_latest
where contract_address = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0
union all
select 4 as numb, price --LDO
from prices.usd_latest
where contract_address = 0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32
)
order by 1
