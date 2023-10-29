--Name: unstETH NFT finalizing time
--Description: 
--Parameters: []
/* 
This query calculates the median and average time to complete withdrawal process
for THE last 7 days 
*/

-- This CTE retrieves the minimum and maximum withdrawal IDs for the last 7 days
with
  finalized_ids AS (
    SELECT
      MIN("from") AS MIN_id,
      MAX("to") AS MAX_id
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized
    WHERE
      date_trunc('day', evt_block_time) >= date_trunc('day', now() - interval '7' day)
  ),
  
  -- This CTE gets withdrawal records within the range defined by the minimum and maximum IDs.
  requested_ids AS (
    SELECT
      *
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
    WHERE
      requestId >= (
        SELECT
          MIN_id
        FROM
          finalized_ids
      )
      and requestId <= (
        SELECT
          MAX_id
        FROM
          finalized_ids
      )
  ),
  
  -- This CTE calculates the latency (time difference) between withdrawal request and finalization
  latency AS (
    SELECT
      requested.requestId,
      requested.amountOfStETH / 1e18 AS amount,
      requested.evt_block_time AS request_time,
      finalized.evt_block_time AS finalized_time,
      date_diff(
        'hour',
        requested.evt_block_time,
        finalized.evt_block_time
      ) AS latency_hours
    FROM
      requested_ids requested
      LEFT JOIN lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized finalized ON requested.requestId >= finalized."from"
      AND requested.requestId <= finalized."to"
  )
  
  -- final select calculates the median and average latency in hours
SELECT
  approx_percentile(latency_hours, 0.5) AS median_hours,
  AVG(latency_hours) AS average_hours
FROM
  latency