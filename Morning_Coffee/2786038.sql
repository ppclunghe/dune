--Name: Lido BC deposits/withdrawals 7d dynamics
--Description: 
--Parameters: []
/* 
This query calculates the amount of ETH deposited/withdrawn by Lido with 7d frequency
 */
-- This CTE generates a sequence of dates for the past 7 days.
with
  dates AS (
    with
      day_seq AS (
        SELECT
          (
            sequence(
              current_date - interval '7' day,
              current_date,
              interval '1' day
            )
          ) AS day
      )
    SELECT
      days.day
    FROM
      day_seq
      CROSS JOIN unnest (day) AS days (day)
  )
  -- This CTE lists the addresses associated with Lido's withdrawal vault, stETH, and staking router 
,
  addresses_list (address) AS (
    values
      (0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f), -- Lido Withrdrawal Vault 
      (0xae7ab96520de3a18e5e111b5eaab095312d7fe84), -- stETH 
      (0xfddf38947afb03c621c71b06c9c70bce73f12999) -- Lido Staking Router
  )
  -- This CTE calculate daily deposits of ETH by Lido addresses in the last 7 days    
,
  deposits AS (
    SELECT
      date_trunc('day', block_time) AS time,
      sum(cast(value AS DOUBLE)) / 1e18 AS amount
    FROM
      ethereum.traces t
    WHERE
      to = 0x00000000219ab540356cbb839cbe05303d7705fa --BC
      AND "from" in (
        SELECT
          address
        FROM
          addresses_list
      )
      AND date_trunc('day', block_time) >= now() - interval '7' day
      AND call_type = 'call'
      AND success = True
    GROUP BY
      1
  )
  -- This CTE gets data for all Lido withdrawals in the last 7 days
,
  allwithdrawals AS (
    SELECT
      date_trunc('day', time) AS time,
      project,
      withdrawn_principal AS amount
    FROM
      dune.lido.result_withdrawals_transactions_assigned_to_projects --query_1038304
    WHERE
      date_trunc('day', time) >= now() - interval '7' day
      AND withdrawn_principal > 0
  )
  -- This CTE calculate daily withdrawals of ETH by the Lido project in the last 7 days
,
  withdrawals AS (
    SELECT
      time,
      sum(amount) AS amount
    FROM
      allwithdrawals
    WHERE
      project = 'Lido'
    GROUP BY
      1
  )
  -- final SELECT statement combines the results from the CTEs to calculate the daily amounts of deposits, withdrawals, AND net deposits
SELECT
  cast(a.day AS TIMESTAMP) AS day,
  COALESCE(d.amount, 0) AS "daily deposited",
  - COALESCE(w.amount, 0) AS "daily withdrawn",
  COALESCE(d.amount, 0) - COALESCE(w.amount, 0) AS "daily net deposits"
FROM
  dates a
  LEFT JOIN deposits d ON a.day = d.time
  LEFT JOIN withdrawals w ON a.day = date_trunc('day', w.time)
ORDER BY
  3 DESC