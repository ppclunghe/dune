--Name: Lido staking APR 7days MA
--Description: 
--Parameters: []
/* This query calculates the daily value of Lido protocol APR, Lido instant staking APR, 
7-day and 30-day moving average for Lido staking APR
*/

WITH
  calendar AS (
  with day_seq as(SELECT( sequence(cast('2022-09-10' as date),cast(now() as date), interval '1' day)) day )
    select days.day
    from day_seq
    cross join unnest(day) as days(day)
),

shares as (
select  
preTotalEther*1e27/preTotalShares as pre_share_rate,
postTotalEther*1e27/postTotalShares as post_share_rate,
*
from lido_ethereum.steth_evt_TokenRebased
),

oracles_data as (
--legacy oracle
SELECT "evt_block_time" AS time,
 cast(("postTotalPooledEther" - "preTotalPooledEther")* 365 * 24 * 60 * 60 /("preTotalPooledEther") as double)/timeElapsed * 100 as protocol_apr,
 cast(("postTotalPooledEther" - "preTotalPooledEther")* 365 * 24 * 60 * 60 /("preTotalPooledEther") as double)/timeElapsed  * 0.9 * 100 as "Lido staking APR(instant)",
 "postTotalPooledEther",
 "preTotalPooledEther"
        

FROM
  lido_ethereum.LegacyOracle_evt_PostTotalShares
  where "evt_block_time" >= cast('2022-09-01 00:00' as timestamp)
    and "evt_block_time" <= cast('2023-05-16 00:00' as timestamp)

--new V2 oracle
union all 
select  evt_block_time, 
        (365*24*60*60*(post_share_rate - pre_share_rate) / pre_share_rate / timeElapsed * 100) /0.9 as protocol_apr, 
        365*24*60*60*(post_share_rate - pre_share_rate)/ pre_share_rate / timeElapsed * 100  as "Lido staking APR(instant)",
        preTotalEther,
        postTotalEther
        
from shares
 
 )
 
  
 select --o.*,
  o.time,
  o.protocol_apr,
  "Lido staking APR(instant)",
  avg(o."Lido staking APR(instant)") over (order by o.time rows between 6 preceding and current row) as "Lido staking APR(ma_7)",
  avg(o."Lido staking APR(instant)") over (order by o.time rows between 29 preceding and current row) as "Lido staking APR(ma_30)",
  avg(o.protocol_apr) over (order by o.time rows between 6 preceding and current row) as "protocol APR(ma_7)"
 from  oracles_data o 
 ORDER BY 1 DESC 
