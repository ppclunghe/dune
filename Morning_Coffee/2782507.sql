--Name: Locked in DeFi
--Description: 
--Parameters: []
/* This query calculates:
- the total amount of stETH locked in DeFi;
- changes of stETH amount locked in DeFi with frequences 1d/7d
- current amount of stETH locked in Lending market/ Liquidity pool
- changes of reserves in Lending market/ Liquidity pool with frequences 1d/7d
*/

with dates as (
    with day_seq as (select (sequence(current_date - interval '7' day, current_date, interval '1' day)) as day)
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
       sum(cast(steth as double))/sum(cast(wsteth as double))  AS rate
from dates  d
left join volumes v on date_trunc('day', v.time)  = date_trunc('day', d.day) 
group by 1
))

)

, historical_liquidity as (
select *, lead(time, 1, current_date + interval '1' day) over(partition by pool order by time) as next_time 
from lido.liquidity --query_2780390
--where time >= current_date - interval '10' day  
)

, d7ago_liquiidity as (
select sum(case when lower(main_token_symbol) = 'steth' then main_token_reserve
    else wsteth_rate.rate*main_token_reserve
  end) as steth_reserves
  --l.main_token_reserve 
from dates d
left join historical_liquidity l on date_trunc('day', d.day) >= date_trunc('day', l.time) and date_trunc('day', d.day) < date_trunc('day', l.next_time)
left join wsteth_rate on d.day =  wsteth_rate.day
where d.day = current_date - interval '7' day  
)

, d1ago_liquiidity as (
select  sum(case when lower(main_token_symbol) = 'steth' then main_token_reserve
    else wsteth_rate.rate*main_token_reserve
  end) as steth_reserves
  --l.main_token_reserve 
from dates d
left join historical_liquidity l on date_trunc('day', d.day) >= date_trunc('day', l.time) and date_trunc('day', d.day) < date_trunc('day', l.next_time)
left join wsteth_rate on d.day =  wsteth_rate.day
where d.day = current_date - interval '1' day  
)

, current_liquiidity as (
select  sum(case when lower(main_token_symbol) = 'steth' then main_token_reserve
    else wsteth_rate.rate*main_token_reserve
  end) as steth_reserves
  --l.main_token_reserve 
from dates d
left join historical_liquidity l on date_trunc('day', d.day) >= date_trunc('day', l.time) and date_trunc('day', d.day) < date_trunc('day', l.next_time)
left join wsteth_rate on d.day =  wsteth_rate.day
where d.day = current_date 
)
, d7ago_lending as (
select sum(amount) as steth_collateral 
from dates d
left join  dune.lido.result_wsteth_in_lending_pools l
--dune.lido.result_2688773 l 
    on date_trunc('day', d.day) = date_trunc('day', l.time)
where d.day = current_date - interval '7' day  
)

, d1ago_lending as (
select sum(amount) as steth_collateral 
from dates d
left join  dune.lido.result_wsteth_in_lending_pools l
--dune.lido.result_2688773 l 
    on date_trunc('day', d.day) = date_trunc('day', l.time)
where d.day = current_date - interval '1' day  
)

, current_lending as (
select sum(amount) as steth_collateral 
from dates d
left join dune.lido.result_wsteth_in_lending_pools l
--dune.lido.result_2688773 l 
    on date_trunc('day', d.day) = date_trunc('day', l.time)
where d.day = current_date
)

, all_metrics as (
select 
    (select steth_reserves from d7ago_liquiidity) as reserves_7d_ago,
    (select steth_reserves from d1ago_liquiidity) as reserves_1d_ago,
    (select steth_reserves from current_liquiidity) as reserves_current,
    (select steth_collateral from d7ago_lending) as collateral_7d_ago,
    (select steth_collateral from d1ago_lending) as collateral_1d_ago,
    (select steth_collateral from current_lending) as collateral_current
)

select 
    reserves_current,
    reserves_7d_ago,
    reserves_current - reserves_7d_ago as change_reserves_7d,
    100*(reserves_current - reserves_7d_ago)/reserves_7d_ago as prc_change_reserves_7d,
    reserves_1d_ago,
    reserves_current - reserves_1d_ago as change_reserves_1d,
    100*(reserves_current - reserves_1d_ago)/reserves_1d_ago as prc_change_reserves_1d,
    collateral_current,
    collateral_current - collateral_7d_ago as change_collateral_7d,
    100*(collateral_current - collateral_7d_ago)/collateral_7d_ago as prc_change_collateral_7d,
    collateral_current - collateral_1d_ago as change_collateral_1d,
    100*(collateral_current - collateral_1d_ago)/collateral_1d_ago as prc_change_collateral_1d,
    collateral_current + reserves_current as locked_in_defi_current,
    (collateral_current + reserves_current - reserves_7d_ago - collateral_7d_ago) as locked_in_defi_change_7d,
    (collateral_current + reserves_current - reserves_1d_ago - collateral_1d_ago) as locked_in_defi_change_1d,
    format('%,.0f',round(coalesce(collateral_current + reserves_current,0),0))||' stETH / '||
    format('%,.2f',round(coalesce( 100*(collateral_current + reserves_current - reserves_1d_ago - collateral_1d_ago) / (reserves_1d_ago + collateral_1d_ago),0),2))||'% / '||
    format('%,.2f',round(coalesce( 100*(collateral_current + reserves_current - reserves_7d_ago - collateral_7d_ago) / (reserves_7d_ago + collateral_7d_ago),0),2))||'%'  as widget
from all_metrics

