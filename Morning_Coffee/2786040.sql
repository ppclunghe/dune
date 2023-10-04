--Name: Lido BC net deposits 7d
--Description: 
--Parameters: []
with 
    addresses_list as (
        select 
            address, name 
        from query_2005642
    )
    
, alldeposits as (
    select 
        "from" as project,
        cast(value as double) as amount
    from  ethereum.traces t
    
    where to = 0x00000000219ab540356cbb839cbe05303d7705fa
    AND date_trunc('day', block_time) >= now() - interval '7' day
    and call_type = 'call'
    and success = True 
)

, deposits_projects as (
select 
    coalesce(name, 'Unidentified') as name
    , sum(amount)/1e18 as amount
from  alldeposits
left join addresses_list q on q.address = alldeposits.project
group by 1
)

, allwithdrawals as (
    select 
        project,
        withdrawn_principal as amount
    from  dune.lido.result_withdrawals_transactions_assigned_to_projects 
    where date_trunc('day', time) >= now() - interval '7' day
    and withdrawn_principal > 0
)

, withdrawals_projects as (
    select 
        project as name ,
        sum(amount) as amount
    from allwithdrawals
    group by 1
)

select
COALESCE(d.name,w.name) as name,
COALESCE(d.amount,0) as eth_deposited,
COALESCE(w.amount,0) as eth_withdrawn,
COALESCE(d.amount,0) - COALESCE(w.amount,0) as eth_deposits_net
from deposits_projects d
full outer join withdrawals_projects w
on d.name = w.name
where d.name = 'Lido'
order by 4 desc