--Name: Lido net deposits change
--Description: 
--Parameters: []
with eth_current_amount as (
select *
from query_2111543
order by day desc
limit 1
)

, all_eth_metrics as (
select lido_amount as current_amount,
  (select lido_amount from query_2768378) as amount_7d_ago,
  (select lido_amount from query_2768351) as amount_24h_ago
from eth_current_amount
)

select  'ETH' as token, 
        current_amount, 
        (current_amount-amount_24h_ago)/amount_24h_ago as change_24h,
        (current_amount-amount_7d_ago)/amount_7d_ago as change_7d
from all_eth_metrics
--union all 
--select * from query_2768425
