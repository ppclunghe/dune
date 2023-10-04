--Name: Aave V2 lending pool
--Description: 
--Parameters: []
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
where 
    "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84 and 
    ("to" = 0x1982b2F5814301d4e9a8b0201555376e62F82428)
    
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
    ("from" = 0x1982b2F5814301d4e9a8b0201555376e62F82428)
    
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

/*
with recursive staking_rewards_txns as (
--Staking rewards txns since 2021-04-30
select  date_trunc('day',t."evt_block_time") as time, sum(t."value"/1e18)*100/5 as amount,
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
select  time,
        lead(time, 1, date_trunc('day',now())) over (order by time) AS next_time,
        (amount*0.9) as rewards,
        total_supply
from staking_rewards_txns
)

, reserve as (
select '\xae7ab96520de3a18e5e111b5eaab095312d7fe84'::bytea --stETH
)

, deposit_evt as (
select "evt_block_time","reserve", "user", "amount" as amount, "evt_tx_hash"
from aave_v2."LendingPool_evt_Deposit"
where reserve in (select * from reserve)
order by "evt_block_time" desc 
)

, withdraw_evt as (
select "evt_block_time","reserve", "user", "amount", "evt_tx_hash"
from aave_v2."LendingPool_evt_Withdraw"
where reserve in (select * from reserve)
order by "evt_block_time" desc 
)

, all_evt as (
select  date_trunc('hour', d."evt_block_time") as time, sum(amount)/1e18 as deposit, 0 as withdraw
from deposit_evt d
group by 1
union all
select  date_trunc('hour', w."evt_block_time") as time, 0, (-1)*sum(w.amount)/1e18
from withdraw_evt w 
group by 1
)

, daily_balances as (
select date_trunc('day',time) as day, sum("deposited") as deposited, sum("withdrawn") as withdrawn-- p.price, 
--sum(deposited + withdrawn) over (order by time) as amount_cumu
      -- sum(p.price*deposited + p.price*withdrawn) over (order by time) as tvl    
from (
select  time, 
        sum(deposit) as "deposited",
        sum(withdraw) as "withdrawn"
from all_evt
group by  1
) balances
--left join prices_dex p on balances.time = p.day
group by 1
)



, aave_pool as (
select  b.day, sum(b.deposited + b.withdrawn) over (order by day) as amount, b.deposited, b.withdrawn, 
coalesce(r.time,b.day) as time, r.next_time, coalesce(r.rewards,0) as rewards, coalesce(total_supply,1) as total_supply
from daily_balances b
left join rewards_without_commission r on b.day = date_trunc('day',r.time)
)

, pool_with_rebase as (
--Base of recursion
select  time,
        deposited, withdrawn, 
        amount as steth_pool_from_opers, rewards, total_supply, --rebase, prev_rebase1,
        amount as prev_rebase,
        amount*rewards/total_supply as rebase_steth, 
        amount+amount*rewards/total_supply as steth_pool
        
from aave_pool where time = '2022-02-27 00:00'

union all

--Step of recursion
select  b.time,
        b.deposited, b.withdrawn, 
        b.amount as steth_pool_from_opers, b.rewards, b.total_supply, --b.rebase, b.prev_rebase1,
        r.steth_pool as prev_rebase,
        r.prev_rebase*b.rewards/b.total_supply, 
        b.amount + b.amount*b.rewards/b.total_supply as steth_pool
        
from aave_pool b
inner join  pool_with_rebase r on b.time = r.time + interval '1 day'
)

, prices as (
select distinct date_trunc('day', minute) as day, 
last_value(price) over (partition by date_trunc('day', minute) order by minute range between unbounded preceding and unbounded following) as price
from prices."usd" p
where date_trunc('day', minute) >= '2022-02-27'
  and "contract_address" = '\xae7ab96520de3a18e5e111b5eaab095312d7fe84'::bytea 
order by 1 desc
 )

select  time, deposited+withdrawn as "daily balance, stETH", steth_pool_from_opers, rebase_steth, sum(rebase_steth) over (order by time) as rebase_cumu, 
steth_pool_from_opers + sum(rebase_steth) over (order by time) as "cumulative balance, stETH", p.price,
p.price*(steth_pool_from_opers + sum(rebase_steth) over (order by time)) as tvl 
from pool_with_rebase l
left join prices p on l.time = p.day  
order by 1 
*/
