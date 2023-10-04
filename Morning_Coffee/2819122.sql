--Name: (w)stETH locked 1d change by protocols
--Description: shows only protocols where delta >= 5% total (w)stETH locked in this protocol and delta >= 5k stETH
--Parameters: []
with balances as (
select address, namespace, balance as current_balance, 0 as d1_ago_balance from query_54574 
union all
select address, namespace, 0 , balance from query_54908
)

select address, namespace, sum(current_balance) as current_balance, sum(d1_ago_balance) as d1_ago_balance,
sum(current_balance) -  sum(d1_ago_balance) as change,
100*(sum(current_balance) -  sum(d1_ago_balance))/sum(d1_ago_balance) as change_prc
from balances
where namespace not in ('gnosis_safe', 'proxy_multisig', 'argent', 'lido:withdrawal_queue')
group by 1,2
having (abs(sum(current_balance) -  sum(d1_ago_balance)) >= 5000
  and  abs((sum(current_balance) -  sum(d1_ago_balance))/sum(d1_ago_balance)) >= 0.05
  )
 