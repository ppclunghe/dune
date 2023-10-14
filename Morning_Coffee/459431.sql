--Name: Aave V2 lending pool
--Description: 
--Parameters: []
/* This query calculates Aave v2 lending pool daily and cumulative balances in stETH, TVL in USD */

with dates as (
    with day_seq as (select (sequence(cast('2022-02-27' as timestamp), cast(now() as timestamp), interval '1' day)) as day)
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
        sum(cast(steth as double))/sum(cast(wsteth as double)) AS rate
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
where  "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84 and "to" = 0x1982b2F5814301d4e9a8b0201555376e62F82428
    
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
where "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84 and "from" = 0x1982b2F5814301d4e9a8b0201555376e62F82428
    
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
select time, sum(steth_balance) over (order by time) as steth_cumu,
sum(coalesce(wsteth_balance,steth_balance)) over (order by time) as wsteth_cumu, r.rate,
(sum(coalesce(wsteth_balance,steth_balance)) over (order by time))*coalesce(r.rate, 1) as steth_from_wsteth,
wsteth_balance*coalesce(r.rate, 1) as steth_from_wsteth_daily
from daily_balances b
left join wsteth_rate r on b.time >= r.day and b.time < r.next_day 
order by 1
)

, steth_prices_daily AS (
    SELECT distinct
        DATE_TRUNC('day', minute) AS time,
        avg(price) AS price
    FROM prices.usd
    WHERE date_trunc('day', minute) >= cast('2022-02-27' as timestamp) and date_trunc('day', minute) < date_trunc('day', now())
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

select   d.day, steth_from_wsteth as "cumulative balance, stETH",
         steth_from_wsteth_daily as "daily balance, stETH",
         steth_from_wsteth*stethp.price as tvl
from dates d
left join steth_balances b on d.day = b.time
left join steth_prices_daily stethp on d.day = stethp.time 
order by 1 
