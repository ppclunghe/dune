--Name: ETH staked with Lido (deposits + protocol buffer)
--Description: Dune SQL
--Parameters: []
with calendar AS (
  with day_seq as(SELECT( sequence(cast('2020-11-01' as date),cast(now() as date), interval '1' day)) day )
    select days.day
    from day_seq
    cross join unnest(day) as days(day)
)


, lido_deposits_daily as (
    
    SELECT date_trunc('day',block_time) as time, sum(cast(value as DOUBLE))/1e18 as lido_deposited
    FROM  ethereum.traces
    WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
      AND call_type = 'call'
      AND success = True 
      AND "from" in (0xae7ab96520de3a18e5e111b5eaab095312d7fe84, 0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f, 0xFdDf38947aFB03C621C71b06C9C70bce73f12999)
    GROUP BY 1
    
)


, lido_all_withdrawals_daily as (
    select block_time as time, sum(amount)/1e9 as amount,
    sum(CASE WHEN amount/1e9 BETWEEN 20 AND 32 THEN CAST(amount as double)/1e9 
    WHEN amount/1e9 > 32 THEN 32 ELSE 0 END) AS withdrawn_principal
    from ethereum.withdrawals
    where address = 0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f
    group by 1
)

, lido_principal_withdrawals_daily as (
    select 
    date_trunc('day',time) as time,
    (-1) * sum(withdrawn_principal) as amount
    from lido_all_withdrawals_daily
    where withdrawn_principal > 0
    group by 1
 )


, lido_buffer_amounts_daily as (
select * from query_2481449 --Lido protocol buffer
) 

SELECT 
    calendar.day
    , COALESCE(lido_deposited,0) as lido_deposited_daily
    , sum(COALESCE(lido_deposited,0)) over (order by calendar.day) as lido_deposited_cumu
    , COALESCE(eth_balance,0) as lido_buffer
    , COALESCE(withdrawals.amount,0) as lido_witdrawals_daily
    , sum(COALESCE(withdrawals.amount,0)) over (order by calendar.day) as lido_withdrawals_cumu
    , sum(COALESCE(lido_deposited,0)) over (order by calendar.day) + COALESCE(eth_balance,0) + sum(COALESCE(withdrawals.amount,0)) over (order by calendar.day) as lido_amount
from calendar
left join lido_deposits_daily as lido_amounts on lido_amounts.time = calendar.day
left join lido_buffer_amounts_daily as buffer_amounts on buffer_amounts.time = calendar.day
left join lido_principal_withdrawals_daily as withdrawals on withdrawals.time = calendar.day
order by 1


/*
SELECT "evt_block_time" AS time,
  "postTotalPooledEther" / 1e18 AS pooled_eth
FROM
  lido_ethereum.LegacyOracle_evt_PostTotalShares 
WHERE date_trunc('day',evt_block_time) <= CAST('2023-05-16 00:00' as timestamp)

union all

SELECT evt_block_time,
       cast(postTotalEther as double)/1e18 
FROM 
    lido_ethereum.steth_evt_TokenRebased

ORDER BY
  1 DESC 
*/

/*
select "evt_block_time" as time 
    ,("postTotalPooledEther"-"preTotalPooledEther")*365*24*60*60/("preTotalPooledEther"*"timeElapsed")*100 as protocol_apr
    ,("postTotalPooledEther"-"preTotalPooledEther")*365*24*60*60/("preTotalPooledEther"*"timeElapsed")*0.9*100 as  "Lido staking APR"
    ,"postTotalPooledEther"/1e18 as pooled_eth
from lido."LidoOracle_evt_PostTotalShares"
order by 1 desc
*/