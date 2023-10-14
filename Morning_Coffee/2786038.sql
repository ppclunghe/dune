--Name: Lido BC deposits/withdrawals 7d dynamics
--Description: 
--Parameters: []
/* This query calculates the amount of ETH deposited/withdrawn by Lido with 7d frequency */
with dates as (
    with day_seq as (
        select (sequence(current_date - interval '7' day, current_date, interval '1' day)) as day)
    select days.day
    from day_seq
    cross join unnest(day) as days(day)
)
 
, addresses_list(address) as (
    values 
    (0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f), -- Lido Withrdrawal Vault 
    (0xae7ab96520de3a18e5e111b5eaab095312d7fe84), -- stETH 
    (0xfddf38947afb03c621c71b06c9c70bce73f12999) -- Lido Staking Router
    )
    
, deposits as (
    select 
        date_trunc('day', block_time) as time
        , sum(cast(value as double))/1e18 as amount
    from  ethereum.traces t
    where to = 0x00000000219ab540356cbb839cbe05303d7705fa --BC
    and "from" in (select address from addresses_list)
    AND date_trunc('day', block_time) >= now() - interval '7' day
    and call_type = 'call'
    and success = True 
    group by 1
)


, allwithdrawals as (
    select 
        date_trunc('day', time) as time
        , project
        , withdrawn_principal as amount
    from  dune.lido.result_withdrawals_transactions_assigned_to_projects 
    where date_trunc('day', time) >= now() - interval '7' day
    and withdrawn_principal > 0
)

, withdrawals as (
    select 
        time
        , sum(amount) as amount
    from allwithdrawals
    where project = 'Lido'
    group by 1
)

select
    cast(a.day as timestamp) as day
    , COALESCE(d.amount,0) as "daily deposited"
    , -COALESCE(w.amount,0) as "daily withdrawn"
    , COALESCE(d.amount,0) - COALESCE(w.amount,0) as "daily net deposits"
from dates a
left join deposits d on a.day = d.time
left join withdrawals w on  a.day = date_trunc('day', w.time)
order by 3 desc