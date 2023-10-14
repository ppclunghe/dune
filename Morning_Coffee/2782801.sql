--Name: Current liquidity reserves by pair
--Description: *paired tokens $ reserves in liquidity pools
--Parameters: []
/* This query returns the current reserves of paired tokens in USD in liquidity pools */

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
from lido.liquidity--query_2780390
--where time >= current_date - interval '10' day  
)


--, current_liquiidity as (
select  
        coalesce(case when lower(l.paired_token_symbol) in ('weth', 'eth', 'bb-a-weth') then '(W)ETH'
             when lower(l.paired_token_symbol) = '' then 'unknown'
        else l.paired_token_symbol end 
        ||'/'||'stETH', 'one-sided stETH') as pair,
        sum(paired_token_usd_reserve) as reserves
from dates d
left join historical_liquidity l on date_trunc('day', d.day) >= date_trunc('day', l.time) and date_trunc('day', d.day) < date_trunc('day', l.next_time)
left join wsteth_rate on d.day =  wsteth_rate.day
where d.day = current_date 
group by 1
--)



