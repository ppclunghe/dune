--Name: Top addresses
--Description: 
--Parameters: []
--Need to convert wstETH to stETH, update amount 5k -> 10k
with events as (
select t."from" as address, sum(amount)/1e18 as staked, 0 as withdrawn, 0 as bought, 0 as sold
from lido_ethereum.steth_evt_Submitted s
 join ethereum.transactions t on t.hash = s.evt_tx_hash
where evt_block_time >= now() - interval '24' hour
group by 1
having sum(amount)/1e18 >= 10000

union all

select owner, 0, sum(cast(amountOfStETH as double))/1e18, 0, 0
from lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
where evt_block_time >= now() - interval '24' hour
group by 1
having sum(cast(amountOfStETH as double))/1e18 >= 10000

union all

select tx_to, 0, 0, sum(token_bought_amount), 0 
from dex.trades
where block_time  >= now() - interval '24' hour
  and lower(token_bought_symbol) in ('steth', 'wsteth')
  and blockchain = 'ethereum'
group by 1
having sum(token_bought_amount)  >= 10000

union all

select tx_to, 0, 0, 0 ,sum(token_sold_amount)
from dex.trades
where block_time  >= now() - interval '24' hour
  and lower(token_sold_symbol) in ('steth', 'wsteth')
  and blockchain = 'ethereum'
group by 1
having sum(token_sold_amount)  >= 10000
)

select address, sum(staked) as staked, sum(withdrawn) as withdrawn, sum(bought) as bought, sum(sold) as sold,
        sum(staked) - sum(withdrawn) + sum(bought) - sum(sold) as change
from events
group by 1
--having abs(sum(staked) - sum(withdrawn) + sum(bought) - sum(sold)) >= 10000
order by 6 desc

