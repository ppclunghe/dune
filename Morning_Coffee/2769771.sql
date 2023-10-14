--Name: Lido APR breakdown
--Description: 
--Parameters: []
/* This query returns current value of Lido staking APR, 7-day moving average for Lido staking APR, 
values of Consensus Layer APR and Execution Layer APR
*/

with breakdown_apr as (
select time, CL_APR, EL_APR
from query_1288160 --Lido post Merge APR
where time >= date_trunc('day', now()) - interval '7' day
)

, staking_apr as (
select *
from query_570874 -- Lido staking APR 7d MA
where time >= now() - interval '7' day

)

select cast(date_trunc('day', s.time) as timestamp) as time, s."Lido staking APR(instant)", s."Lido staking APR(ma_7)", 100*b.CL_APR as "CL APR", 100*b.EL_APR as "EL APR"
from staking_apr s
left join breakdown_apr b on date_trunc('day', s.time) = date_trunc('day', b.time) 
order by 1