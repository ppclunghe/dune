--Name: Lido buffer
--Description: 
--Parameters: []
 --Lido's blocks
with blocks as (
select number, blocks.time, blocks.base_fee_per_gas, blocks.gas_used,
blocks.base_fee_per_gas*blocks.gas_used/1e18 AS total_burn
from ethereum.blocks
where miner = 0x388c818ca8b9251b393131c08a736a67ccb19297

)

--Txs of Lido's blocks
, eth_tx as (
select block_time, block_number, gas_used, gas_used*gas_price/1e18 as fee
from ethereum.transactions 
where block_number in (select distinct  number from blocks)
)

--Txs aggregated by blocks
, eth_tx_agg as (
select block_number,
max(block_time) AS block_time,
sum(gas_used) as block_gas_used,
sum(fee) as fee
from eth_tx
group by block_number
)

--Blocks rewards
, blocks_rewards as (
select block_number, block_time, block_gas_used, 
fee - b.total_burn  block_reward
from eth_tx_agg t
left join blocks b on t.block_number = b.number
order by block_number desc
)
  

, withdrawals as (
select block_time as time, sum(amount)/1e9 as amount
from ethereum.withdrawals
where address = 0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f
group by 1
) 
--Transfers 
, transfers as (
select block_time as time, (-1)*sum(cast(value as double))/1e18 as amount
from ethereum.traces
where "from" in  (0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
                  0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, --withdrawal vault
                  --0x889edC2eDab5f40e902b864aD4d7AdE8E412F9B1, --withdrawal queue
                  0x388c818ca8b9251b393131c08a736a67ccb19297) --EL vault
 and (LOWER(call_type) not in ('delegatecall', 'callcode', 'staticcall') or call_type is null)
 and tx_success 
 and success 
group by 1
                    
union all
                    
select  block_time as time, sum(cast(value as double))/1e18 
from ethereum.traces
where to in  (0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
              0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, --withdrawal vault
              0x388c818ca8b9251b393131c08a736a67ccb19297)
 and (LOWER(call_type) not in ('delegatecall', 'callcode', 'staticcall') or call_type is null)
 and tx_success 
 and success 
group by 1
                    
union all --gas costs
                    
select block_time as time, (-1)*sum(cast(gas_price*gas_used as double))/1e18 
from ethereum.transactions
where "from" in  (0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
                  0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, --withdrawal vault
                  0x388c818ca8b9251b393131c08a736a67ccb19297)
group by 1
)

, aggr_data as (
select date_trunc('day', time) as time, sum(amount) as amount
from (

select * from  transfers
union all
select * from  withdrawals
union all
select block_time, block_reward
from blocks_rewards

)
group by 1
)

, result as (
select  time, amount, sum(amount) over (order by time) as eth_balance
from aggr_data
order by time desc
)

select * from result where time >= cast('2023-05-01' as timestamp)