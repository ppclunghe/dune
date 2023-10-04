--Name: Curve ETH/stETH
--Description: Dune SQL
--Parameters: []
with dates as (
    with day_seq as (select (sequence(cast('2021-01-05' as timestamp), cast(now() as timestamp), interval '1' day)) as day)
select days.day
from day_seq
cross join unnest(day) as days(day)
  )


, volumes as (
select u.call_block_time as time,  "output_0" as steth, "_wstETHAmount" as wsteth 
from  lido_ethereum.WstETH_call_unwrap u 
where "call_success" = TRUE 
union all
select u."call_block_time", "_stETHAmount" as steth, "output_0" as wsteth 
from  lido_ethereum.WstETH_call_wrap u
where "call_success" = TRUE 
)


, wsteth_rate as (
SELECT
  day, rate as rate0, value_partition, first_value(rate) over (partition by value_partition order by day) as rate,
  lead(day,1,date_trunc('day', now() + interval '1' day)) over(order by day) as next_day
  
FROM (
select day, rate,
sum(case when rate is null then 0 else 1 end) over (order by day) as value_partition
from (
select  date_trunc('day', d.day) as day, 
        case when  date_trunc('day', d.day) = cast('2021-01-07' as timestamp) then 1 else sum(cast(steth as double))/sum(cast(wsteth as double)) end AS rate
from dates  d
left join volumes v on date_trunc('day', v.time)  = date_trunc('day', d.day) 
group by 1
))

)

, steth_in as (
select
    DATE_TRUNC('day', evt_block_time) as time,
    sum(cast("value" as double))/1e18 as steth_in,
    sum(cast("value" as double)/coalesce(r.rate, 1))/1e18 as wsteth_in,
    r.rate
from erc20_ethereum.evt_Transfer t
 left join wsteth_rate r on DATE_TRUNC('day', evt_block_time) >= r.day and DATE_TRUNC('day', evt_block_time) < r.next_day
where 
    "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84 and 
    ("to" = 0xdc24316b9ae028f1497c275eb9192a3ea0f67022)
    
group by 1,4
)

, steth_out as (
select
    DATE_TRUNC('day', evt_block_time) as time,
    -sum(cast("value" as double))/1e18 as steth_in,
    -sum(cast("value" as double)/coalesce(r.rate, 1))/1e18 as wsteth_in,
    rate
from erc20_ethereum.evt_Transfer t
 left join wsteth_rate r on DATE_TRUNC('day', evt_block_time) >= r.day and DATE_TRUNC('day', evt_block_time) < r.next_day
where 
    "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84 and 
    ("from" = 0xdc24316b9ae028f1497c275eb9192a3ea0f67022)
    
group by 1, 4
)

, daily_balances as (
select time, sum(steth_in) steth_balance, sum(wsteth_in) as wsteth_balance from (
select * from steth_in
union all
select * from steth_out
) group by 1
)

, steth_balances as (
select time, steth_balance, sum(steth_balance) over (order by time) as steth_cumu,
sum(coalesce(wsteth_balance,steth_balance)) over (order by time) as wsteth_cumu, r.rate,
(sum(coalesce(wsteth_balance,steth_balance)) over (order by time))*coalesce(r.rate, 1) as steth_from_wsteth 
from daily_balances b
left join wsteth_rate r on b.time >= r.day and b.time < r.next_day 
order by 1
)

, eth_balances as (
select time, lead(time, 1, date_trunc('day', now() + interval '1' day)) over (order by time) as next_time, sum(eth_amount) over (order by time) as eth_pool
from (
SELECT date_trunc('day', block_time) as time, SUM(amount) as eth_amount
FROM (
    -- outbound transfers
    SELECT block_time, "from" AS address, -cast(tr.value as double)/1e18 AS amount
    FROM ethereum.traces tr
    WHERE "from" = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
    AND success
    AND (call_type NOT IN ('delegatecall', 'callcode', 'staticcall') OR call_type IS null)

    UNION ALL

    -- inbound transfers
    SELECT block_time, "to" AS address, cast(value as double)/1e18 AS amount
    FROM ethereum.traces
    WHERE "to" = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
    AND success
    AND (call_type NOT IN ('delegatecall', 'callcode', 'staticcall') OR call_type IS null)

    UNION ALL
    
    -- gas costs
    SELECT block_time, "from" AS address, -cast(gas_price as double)*cast(gas_used as double)/1e18 
    FROM ethereum.transactions et
    WHERE "from" = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
    and success
) t
group by 1
) eth order by 1 desc

) 

, weth_prices_daily AS (
    SELECT distinct
        DATE_TRUNC('day', minute) AS time,
        avg(price) AS price
    FROM prices.usd
    WHERE date_trunc('day', minute) >= cast('2021-01-05' as timestamp) and date_trunc('day', minute) < date_trunc('day', now())
    and blockchain = 'ethereum'
    and symbol = 'WETH'
    group by 1
    union all
    SELECT distinct
        DATE_TRUNC('day', minute), 
        last_value(price) over (partition by DATE_TRUNC('day', minute), contract_address ORDER BY  minute range between unbounded preceding AND unbounded following) AS price
    FROM prices.usd
    WHERE date_trunc('day', minute) = date_trunc('day', now())
    and blockchain = 'ethereum'
    and symbol = 'WETH'
    
    
)    

, weth_prices_hourly AS (
    select time
    , lead(time,1, DATE_TRUNC('hour', now() + interval '1' hour)) over (order by time) as next_time
    , price
    from (
    SELECT distinct
        DATE_TRUNC('hour', minute) time
        , last_value(price) over (partition by DATE_TRUNC('hour', minute), contract_address ORDER BY  minute range between unbounded preceding AND unbounded following) AS price
    FROM prices.usd
    WHERE date_trunc('hour', minute) >= cast('2021-01-05' as timestamp)
    and blockchain = 'ethereum'
    and symbol = 'WETH'
    
))   

, steth_prices_daily AS (
    SELECT distinct
        DATE_TRUNC('day', minute) AS time,
        avg(price) AS price
    FROM prices.usd
    WHERE date_trunc('day', minute) >= cast('2021-01-05' as timestamp) and date_trunc('day', minute) < date_trunc('day', now())
    and blockchain = 'ethereum'
    and contract_address = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84
    group by 1
    union all
    SELECT distinct
        DATE_TRUNC('day', minute), 
        last_value(price) over (partition by DATE_TRUNC('day', minute), contract_address ORDER BY  minute range between unbounded preceding AND unbounded following) AS price
    FROM prices.usd
    WHERE date_trunc('day', minute) = date_trunc('day', now())
    and blockchain = 'ethereum'
    and contract_address = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84

)

, token_exchange_hourly as( 
    select date_trunc('hour', evt_block_time) as time
        , sum(case when cast(sold_id as int) = 0 then cast(tokens_sold as double) else cast(tokens_bought as double) end) as eth_amount_raw
    from curvefi_ethereum.steth_swap_evt_TokenExchange c
    group by 1
    
)

, trading_volume_hourly as (
    select t.time
        , t.eth_amount_raw * wp.price as volume_raw 
    from token_exchange_hourly t
    left join weth_prices_hourly wp on t.time = wp.time
    order by 1
)

, trading_volume as ( 
    select distinct date_trunc('day', time) as time
        , sum(volume_raw)/1e18 as volume
    from trading_volume_hourly 
    GROUP by 1
)

, steth_eth_rate as (
select time, avg(price) as avg_price, min(price) as min_price, max(price) as max_price, sum(price*amount)/sum(amount) as weight_avg_price
from (
select DATE_TRUNC('day', evt_block_time) as time, cast(tokens_sold as double)/cast(tokens_bought as double) as price, cast(tokens_bought as double) as amount
from curvefi_ethereum.steth_swap_evt_TokenExchange
where cast(sold_id as double) = 0 and cast(tokens_bought as double) <> 0
union all
(select DATE_TRUNC('day', evt_block_time) as time, cast(tokens_bought as double)/cast(tokens_sold as double) as price, cast(tokens_sold as double) as amount
from curvefi_ethereum.steth_swap_evt_TokenExchange
where cast(sold_id as double) = 1 and cast(tokens_sold as double) <> 0)) price_both
group by 1
) 

select   d.day as time, steth_balance as "daily balance, stETH",
         steth_from_wsteth as steth_pool,
         coalesce(eth.eth_pool, 0) as eth_pool,
         steth_from_wsteth*coalesce(stethp.price, wethp.price) + coalesce(eth.eth_pool, 0)*wethp.price as tvl,
         (r.weight_avg_price-1)*100 as price_to_eth
         
from dates d
left join steth_balances b on d.day = b.time
left join eth_balances eth on d.day = eth.time 
left join steth_prices_daily stethp on d.day = stethp.time 
left join weth_prices_daily wethp on d.day = wethp.time 
left join trading_volume v on d.day = v.time
left join steth_eth_rate r on d.day = r.time
order by 1


/*
with recursive staking_rewards_txns as (

--Staking rewards txns before 2021-04-30
select  date_trunc('day',t."evt_block_time") as "evt_block_time", sum(t."value"/1e18)*100/5 as amount,
        max(sbm.amount_cumu ) as total_supply, 
        sum(t."value"/1e18) as amount_treasury
from erc20."ERC20_evt_Transfer" t
left join (select  evt_block_time as time, 
                   lead("evt_block_time", 1, now()) over (order by "evt_block_time") AS next_time,
                    sum(amount/1e18) over (order by evt_block_time) amount_cumu
from lido."steth_evt_Submitted"
where evt_block_time < '2021-04-30'
order by "evt_block_time" ) sbm on t."evt_block_time" >= sbm.time and t."evt_block_time" < sbm.next_time
where t."to" = '\x3e40d73eb977dc6a537af587d48316fee66e9c8c' --Lido Treasury, 5%
    and t."from" = '\x0000000000000000000000000000000000000000'
    and t."contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84'
    and t."evt_block_time" < '2021-04-30'
    and not exists (select 1 from lido."steth_call_totalSupply" s where s."call_tx_hash" = t."evt_tx_hash") 
group by 1

union all

--Staking rewards txns since 2021-04-30
select  date_trunc('day',t."evt_block_time") , sum(t."value"/1e18)*100/5 as amount,
        max(s.output_0/1e18) as total_supply, sum(t."value"/1e18) as amount_treasury 
from erc20."ERC20_evt_Transfer" t
left join lido."steth_call_totalSupply" s on t."evt_tx_hash" = s."call_tx_hash"
where t."to" = '\x3e40d73eb977dc6a537af587d48316fee66e9c8c' --Lido Treasury, 5%
    and t."from" = '\x0000000000000000000000000000000000000000'
    and t."contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84'
    and s.call_trace_address[1] = '1'
    and s.call_trace_address[2] = '0'
group by 1
order by 1 desc    

) 

, rewards_without_commission as (  
select  "evt_block_time" as time,
        lead("evt_block_time", 1, date_trunc('day',now())) over (order by "evt_block_time") AS next_time,
        (amount*0.9) as rewards,
        total_supply
from staking_rewards_txns
)

, pool_operations as (
select 
    total.time,
    steth_in, 
    steth_out,
    sum(steth_in) over (order by total.time asc rows between unbounded preceding and current row) + sum(steth_out) over (order by total.time asc rows between unbounded preceding and current row) as steth_pool,
    sum(eth_in_calc) over (order by total.time asc rows between unbounded preceding and current row) + sum(eth_out_calc) over (order by total.time asc rows between unbounded preceding and current row) as eth_pool,
    (price_steth_by_eth-1)*100 as price_to_eth,
    coalesce(r.rewards,0) as rewards,
    coalesce(r.total_supply,1) as total_supply
from(

select
    COALESCE(t_price.time,exchange_eth_steth.time, steth_turnover.time, RemoveLiquidity.time, RemoveLiquidityImbalance.time, RemoveLiquidityOne_eth.time, RemoveLiquidityOne_steth.time, AddLiquidity.time) as time,
    t_price.weight_avg_price as price_steth_by_eth,
    COALESCE(steth_turnover.steth_in, 0) as steth_in,
    COALESCE(AddLiquidity.steth_added, 0) + COALESCE(exchange_eth_steth.steth_added_ex, 0) as steth_in_calc,
    COALESCE(AddLiquidity.steth_added, 0) as steth_added,
    COALESCE(exchange_eth_steth.steth_added_ex, 0) as steth_added_ex,
    (-1)*COALESCE(steth_turnover.steth_out, 0) as steth_out,
    (-1)* (COALESCE(RemoveLiquidity.steth_removed, 0) + COALESCE(RemoveLiquidityImbalance.steth_removed, 0)+COALESCE(RemoveLiquidityOne_steth.steth_removed, 0) +  COALESCE(exchange_eth_steth.steth_removed_ex, 0)) as steth_out_calc,
    (-1)* COALESCE(RemoveLiquidity.steth_removed, 0) as steth_removed_0,
    (-1)* COALESCE(RemoveLiquidityImbalance.steth_removed, 0) as steth_removed_imbalance,
    (-1)* COALESCE(RemoveLiquidityOne_steth.steth_removed, 0) as steth_removed_one,
    (-1)* COALESCE(exchange_eth_steth.steth_removed_ex, 0) as steth_removed_ex,
    COALESCE(AddLiquidity.eth_added, 0) + COALESCE(exchange_eth_steth.eth_added_ex, 0) as eth_in_calc,
    COALESCE(AddLiquidity.eth_added, 0) as eth_added,
    COALESCE(exchange_eth_steth.eth_added_ex, 0) as eth_added_ex,
    (-1)* (COALESCE(RemoveLiquidity.eth_removed, 0)+COALESCE(RemoveLiquidityImbalance.eth_removed, 0)+COALESCE(RemoveLiquidityOne_eth.eth_removed, 0)+COALESCE(exchange_eth_steth.eth_removed_ex, 0))  as eth_out_calc,
    (-1)* COALESCE(RemoveLiquidity.eth_removed, 0) as eth_removed_0,
    (-1)* COALESCE(RemoveLiquidityImbalance.eth_removed, 0) as eth_removed_imbalance,
    (-1)* COALESCE(RemoveLiquidityOne_eth.eth_removed, 0) as eth_removed_one,
    (-1)* COALESCE(exchange_eth_steth.eth_removed_ex, 0) as eth_removed_ex
    
from
(
-- remove both eth and steth
select 
    DATE_TRUNC('day', evt_block_time) as time,
    sum("token_amounts"[1]/1e18) as eth_removed,
    sum("token_amounts"[2]/1e18) as steth_removed
from curvefi."steth_swap_evt_RemoveLiquidity"
group by 1) RemoveLiquidity

full join
(
-- remove imbalanced eth and steth
select 
    DATE_TRUNC('day', evt_block_time) as time,
    sum("token_amounts"[1]/1e18) as eth_removed,
    sum("token_amounts"[2]/1e18) as steth_removed
from curvefi."steth_swap_evt_RemoveLiquidityImbalance"
group by 1) RemoveLiquidityImbalance on RemoveLiquidity.time = RemoveLiquidityImbalance.time
 
full join
(
-- add both eth and steth
select 
    DATE_TRUNC('day', evt_block_time) as time,
    sum("token_amounts"[1]/1e18) as eth_added,
    sum("token_amounts"[2]/1e18) as steth_added
from curvefi."steth_swap_evt_AddLiquidity"
group by 1) AddLiquidity on AddLiquidity.time = COALESCE(RemoveLiquidity.time, RemoveLiquidityImbalance.time)

full join
(
-- remove only steth
select
    DATE_TRUNC('day', evt_block_time) as time,
    sum("value"/1e18) as steth_removed
from erc20."ERC20_evt_Transfer"
where 
    "contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84' and 
    ("from"='\xdc24316b9ae028f1497c275eb9192a3ea0f67022')
    and "evt_tx_hash" in (select "evt_tx_hash" from curvefi."steth_swap_evt_RemoveLiquidityOne")
group by 1) RemoveLiquidityOne_steth on RemoveLiquidityOne_steth.time = COALESCE(AddLiquidity.time, RemoveLiquidity.time, RemoveLiquidityImbalance.time)

full join
(
-- remove only eth
select 
    DATE_TRUNC('day', evt_block_time) as time,
    sum("coin_amount"/1e18) as eth_removed
from curvefi."steth_swap_evt_RemoveLiquidityOne"
where "evt_tx_hash" not in 
(select
    "evt_tx_hash"
from erc20."ERC20_evt_Transfer"
where 
    "contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84' and 
    ("from"='\xdc24316b9ae028f1497c275eb9192a3ea0f67022'))
group by 1
union all
-- remove eth as RemoveLiquidityOne and in txn there is steth exchange
select DATE_TRUNC('day', evt_block_time) as time,
    sum("coin_amount")/1e18 as eth_removed
    --"contract_address"
from curvefi."steth_swap_evt_RemoveLiquidityOne"
where "evt_tx_hash"  =  '\x3eb86d3728967967fa5fd19ec109fe62ddf925c7e34efcae82b888949ff21c58'
group by 1
) RemoveLiquidityOne_eth on RemoveLiquidityOne_eth.time = COALESCE(RemoveLiquidityOne_steth.time, AddLiquidity.time, RemoveLiquidity.time, RemoveLiquidityImbalance.time)

full join
(
-- eth/steth exchange
select COALESCE(t.time, tt.time) as time, 
       COALESCE(steth_added_ex, 0) as steth_added_ex,
       COALESCE(steth_removed_ex, 0) as steth_removed_ex,
       COALESCE(eth_added_ex, 0) as eth_added_ex,
       COALESCE(eth_removed_ex, 0) as eth_removed_ex,
       
       COALESCE(steth_added_ex, 0) - COALESCE(steth_removed_ex, 0) as net_steth_sold,
       COALESCE(eth_added_ex, 0) - COALESCE(eth_removed_ex, 0) as net_steth_sold
from
(select 
    DATE_TRUNC('day', evt_block_time) as time, 
    sum("tokens_sold"/1e18) as steth_added_ex,
    sum("tokens_bought"/1e18) as eth_removed_ex
from curvefi."steth_swap_evt_TokenExchange"
where sold_id = 1
group by 1) t

full join

(select 
    DATE_TRUNC('day', evt_block_time) as time, 
    sum("tokens_bought"/1e18) as steth_removed_ex,
    sum("tokens_sold"/1e18) as eth_added_ex
from curvefi."steth_swap_evt_TokenExchange"
where sold_id = 0
group by 1) tt on t.time = tt.time

) exchange_eth_steth on exchange_eth_steth.time = COALESCE(RemoveLiquidityOne_eth.time, RemoveLiquidityOne_steth.time, AddLiquidity.time, RemoveLiquidity.time, RemoveLiquidityImbalance.time)


full join


(
--steth turnover
select
    COALESCE(steth_turnover_in.time, steth_turnover_out.time) as time, 
    COALESCE(steth_in, 0) as steth_in,
    COALESCE(steth_out, 0) as steth_out,
    COALESCE(steth_in, 0) - COALESCE(steth_out, 0) as steth_balance
from (
-- steth in
select
    DATE_TRUNC('day', evt_block_time) as time,
    sum("value"/1e18) as steth_in
from erc20."ERC20_evt_Transfer"
where 
    "contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84' and 
    ("to" = '\xdc24316b9ae028f1497c275eb9192a3ea0f67022')
    
group by 1
) steth_turnover_in

full join
(
-- steth out
select
    DATE_TRUNC('day', evt_block_time) as time,
    sum("value"/1e18) as steth_out
from erc20."ERC20_evt_Transfer"
where 
    "contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84' and 
    ("from"='\xdc24316b9ae028f1497c275eb9192a3ea0f67022')
    
group by 1
) steth_turnover_out on steth_turnover_in.time = steth_turnover_out.time

) steth_turnover on steth_turnover.time = COALESCE(exchange_eth_steth.time, RemoveLiquidityOne_eth.time, RemoveLiquidityOne_steth.time, AddLiquidity.time, RemoveLiquidity.time, RemoveLiquidityImbalance.time)

full join

(select time, avg(price) as avg_price, min(price) as min_price, max(price) as max_price, sum(price*amount)/sum(amount) as weight_avg_price
from (
select DATE_TRUNC('day', evt_block_time) as time, "tokens_sold"/"tokens_bought" as price, "tokens_bought" as amount
from curvefi."steth_swap_evt_TokenExchange"
where sold_id = 0 and "tokens_bought" <> 0
union all
(select DATE_TRUNC('day', evt_block_time) as time, "tokens_bought"/"tokens_sold" as price, "tokens_sold" as amount
from curvefi."steth_swap_evt_TokenExchange"
where sold_id = 1 and "tokens_sold" <> 0)) price_both
group by 1) t_price on t_price.time = COALESCE(steth_turnover.time, exchange_eth_steth.time, RemoveLiquidityOne_eth.time, RemoveLiquidityOne_steth.time, AddLiquidity.time, RemoveLiquidity.time, RemoveLiquidityImbalance.time)
order by 1) as total
left join rewards_without_commission r on date_trunc('day',total.time) = date_trunc('day',r.time)
)


, pool_with_rebase as (
--Base of recursion
select  time,
        steth_in, steth_out, 
        steth_pool as steth_pool_from_opers, rewards, total_supply, --rebase, prev_rebase1,
        steth_pool*rewards/total_supply as rebase_steth, 
        steth_pool+steth_pool*rewards/total_supply as steth_pool,
        eth_pool, 
        price_to_eth
from pool_operations where time = '2021-01-05 00:00'

union all

--Step of recursion
select  b.time,
        b.steth_in, b.steth_out, 
        b.steth_pool as steth_pool_from_opers, b.rewards, b.total_supply, --b.rebase, b.prev_rebase1,
        (r.steth_pool + b.steth_in + b.steth_out)*b.rewards/b.total_supply, 
        (r.steth_pool + b.steth_in + b.steth_out)+(r.steth_pool + b.steth_in + b.steth_out)*b.rewards/b.total_supply as steth_pool,
        b.eth_pool, 
        b.price_to_eth
from pool_operations b
inner join  pool_with_rebase r on b.time = r.time + interval '1 day'
)

, steth_prices as (
select distinct date_trunc('day', minute) as day, 
last_value(price) over (partition by date_trunc('day', minute) order by minute range between unbounded preceding and unbounded following) as price
from prices."usd" p
where date_trunc('day', minute) >= '2021-01-05'
  and "contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84'::bytea 
order by 1 desc
 )
 
 
, weth_prices as (
select distinct date_trunc('day', minute) as day, 
last_value(price) over (partition by date_trunc('day', minute) order by minute range between unbounded preceding and unbounded following) as price
from prices."usd" p
where date_trunc('day', minute) >= '2021-01-05'
  and "contract_address" = '\xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'::bytea 
order by 1 desc
 )


select  time, (steth_in + steth_out) as "daily balance, stETH", steth_pool as "cumulative balance, stETH", eth_pool as "cumulative balance, ETH",  
price_to_eth as "stETH to ETH price", p.*,
steth_pool * steth.price + eth_pool * weth.price as "TVL"
from pool_with_rebase p
left join weth_prices weth on p.time = weth.day
left join steth_prices steth on p.time = steth.day
*/