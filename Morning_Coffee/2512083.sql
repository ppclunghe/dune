--Name: unstETH NFT finalizing time 
--Description: 
--Parameters: []
with finalized_ids as (
select min("from") as min_id, max("to") as max_id
from lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized
where date_trunc('day', evt_block_time) >= date_trunc('day', now() - interval '7' day)
)


, requested_ids as (
select *
from lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
where requestId >= (select min_id from finalized_ids) and requestId <= (select max_id from finalized_ids)
)

, latency as (
select  requested.requestId, requested.amountOfStETH/1e18 as amount, requested.evt_block_time as request_time,  finalized.evt_block_time as finalized_time, 
 date_diff('hour', requested.evt_block_time, finalized.evt_block_time) as latency_hours
from requested_ids requested
left join lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized finalized 
    on requested.requestId >= finalized."from" and requested.requestId <= finalized."to"
)

select  approx_percentile(latency_hours, 0.5)  as median_hours, 
        avg(latency_hours) as average_hours
from latency
