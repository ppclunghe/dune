--Name: ETH net deposits 7d period, inflow leaders
--Description: Top-10 projects by net deposits inflow
--Parameters: []
/* This query calculates deposits/withdrawals and growth by projects,
and returns Top 10 projects by net deposits for the last 7d
*/
with 
    addresses_list as (
    
        select address, name from query_2005642 --ETH depositors labels
       
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

,deposits_projects as
(
select 
    coalesce(name, 'Unidentified') as name
    , sum(amount)/1e18 as amount
from  alldeposits
left join addresses_list q on q.address = alldeposits.project
group by 1

)

,allwithdrawals as (
    select 
    project,
    withdrawn_principal as amount
    from  dune.lido.result_withdrawals_transactions_assigned_to_projects -- query_1038304
    where date_trunc('day', time) >= now() - interval '7' day
    and withdrawn_principal > 0
)

,withdrawals_projects as
(
select 
project as name ,
sum(amount) as amount
from allwithdrawals
group by 1
)



,net_growth as
(
select
COALESCE(d.name,w.name) as name,
ROW_NUMBER() OVER (ORDER BY COALESCE(d.amount,0) - COALESCE(w.amount,0) DESC) as row,
COALESCE(d.amount,0) as eth_deposited,
COALESCE(w.amount,0) as eth_withdrawn,
COALESCE(d.amount,0) - COALESCE(w.amount,0) as eth_deposits_growth

from deposits_projects d
full outer join withdrawals_projects w
on d.name = w.name

)


select *,
name as name_2 from net_growth
where (row <= 10 and eth_deposits_growth > 0) --top-10 projects with positive deposits inflow
--or (name = 'Lido' and eth_deposits_growth > 0)
--or (row > (select max(row) from net_growth) - 5 
order by row asc