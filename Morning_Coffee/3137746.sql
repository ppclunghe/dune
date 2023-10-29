--Name: Not finalized withdrawals requests: time since request
--Description: 
--Parameters: []
/* 
This query calculates the waiting time from when withdrawal request is made until it is finalised
*/
-- This CTE retrieves the MIN and MAX IDs which contains finalized withdrawal request
with
  finalized_ids AS (
    SELECT
      MIN("from") AS MIN_id,
      MAX("to") AS MAX_id
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized
  )
  -- This CTE filters and gets withdrawal requests falling within the range of finalized IDs obtained from the previous CTE 
,
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
      AND requestId <= (
        SELECT
          MAX_id
        FROM
          finalized_ids
      )
  )
  
  -- This CTE calculates the hours latency for pending withdrawal requests, alongside request ID, 
  -- stETH amount, request time, requestor, transaction hash, and request status
,
  requested_time_to_finalize AS (
    /*
    SELECT  requested.requestId, requested.amountOfStETH/1e18 AS amount, requested.evt_block_time AS request_time,  finalized.evt_block_time AS finalized_time, 
    date_diff('hour', requested.evt_block_time, finalized.evt_block_time) AS latency_hours, requested.requestor, requested.evt_tx_hash, 'finalized' AS status
    FROM requested_ids requested
    left join lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized finalized 
    on requested.requestId >= finalized."from" and requested.requestId <= finalized."to"
    
    union all
     */
    SELECT
      requested.requestId,
      requested.amountOfStETH / 1e18 AS amount,
      requested.evt_block_time AS request_time,
      NULL AS finalized_time,
      date_diff('hour', requested.evt_block_time, now()) AS latency_hours,
      requested.requestor,
      requested.evt_tx_hash,
      'pending' AS status
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested requested
    WHERE
      requested.requestId > (
        SELECT
          MAX_id
        FROM
          finalized_ids
      )
  ),
  
  -- This CTE summarizes withdrawal request data, aggregates by status, requestor, and txn hash.
  -- It computes total withdrawal amounts, earliest request times, maximum waiting times in hours, 
  --and arranges the results by finalized time in descending order.
  requests_data AS (
    SELECT
      status,
      requestor,
      evt_tx_hash,
      SUM(amount) AS amount,
      MIN(request_time) AS request_time,
      MAX(finalized_time) AS finalized_time,
      MAX(latency_hours) AS waiting_hours
    FROM
      requested_time_to_finalize
    GROUP BY
      1,
      2,
      3
    ORDER BY
      5 DESC
  ),
  
  -- This CTE calculates the total amoutn withdrawn each day
  bc_withdrawals AS (
    SELECT
      date_trunc('day', time) AS time,
      MIN(time) AS MIN_time,
      SUM(withdrawn_principal) AS amount
    FROM
      dune.lido.result_withdrawals_transactions_assigned_to_projects --query_1038304
    WHERE
      withdrawn_principal > 0
      AND project = 'Lido'
    GROUP BY
      1
  )
  
-- final query retrieves data from the "requests_data" CTE  
SELECT
  requests_data.*
FROM
  requests_data
ORDER BY
  request_time ASC