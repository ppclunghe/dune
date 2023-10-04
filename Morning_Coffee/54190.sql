--Name: Reserves of tokens paired to (w)stETH in liquidity pools
--Description: 
--Parameters: []
with 

 d7ago_liquiidity as (
select sum(paired_token_usd_reserve) as paired_token_usd_reserve
from lido.liquidity  l  --query_2780390
where l.time = (select max(time) - interval '7' day  from lido.liquidity)
)

, d1ago_liquiidity as (
select sum(paired_token_usd_reserve) as paired_token_usd_reserve
from lido.liquidity  l  --query_2780390
where l.time = (select max(time) - interval '1' day  from lido.liquidity)
)

, current_liquiidity as (
select sum(paired_token_usd_reserve) as paired_token_usd_reserve
from  lido.liquidity  l  --query_2780390
where l.time = current_date 
)


, all_metrics as (
select 
    (select paired_token_usd_reserve from d7ago_liquiidity) as reserves_7d_ago,
    (select paired_token_usd_reserve from d1ago_liquiidity) as reserves_1d_ago,
    (select paired_token_usd_reserve from current_liquiidity) as reserves_current
)

select 
    reserves_current,
    reserves_current - reserves_7d_ago as change_reserves_7d,
    100*(reserves_current - reserves_7d_ago)/reserves_7d_ago as prc_change_reserves_7d,
    reserves_current - reserves_1d_ago as change_reserves_1d,
    100*(reserves_current - reserves_1d_ago)/reserves_1d_ago as prc_change_reserves_1d,
    '$'||format('%,.0f',round(coalesce( reserves_current,0),0))||' / '||
    format('%,.2f',round(coalesce( 100*(reserves_current - reserves_1d_ago ) / (reserves_1d_ago),0),2))||'% / '||
    format('%,.2f',round(coalesce( 100*(reserves_current - reserves_7d_ago) / (reserves_7d_ago),0),2))||'%'  as widget
from all_metrics

