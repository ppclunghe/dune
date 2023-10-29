--Name: ETH net deposits 7d period, inflow leaders
--Description: Top-10 projects by net deposits inflow
--Parameters: []
/* 
This query calculates deposits, withdrawals, and growth by projects
and returns the Top 10 projects by net deposits for the last 7d
 */
 
-- This CTE fetches a list of addresses with names from a 'query_2005642' (ETH deposits labels)
with
  addresses_list AS (
    SELECT
      address,
      name
    FROM
      query_2005642 --ETH depositors labels
  ),
  
  -- This CTE gets all successful ETH deposit transactions address over the past 7 days 
  alldeposits AS (
    SELECT
      "from" AS project,
      cast(value AS DOUBLE) AS amount
    FROM
      ethereum.traces t
    WHERE
      to = 0x00000000219ab540356cbb839cbe05303d7705fa
      AND date_trunc('day', block_time) >= now() - interval '7' day
      AND call_type = 'call'
      AND success = True
  ),
  
  -- This CTE categorizes the deposit amounts to BC by protocol, mapping the project names
  deposits_projects AS (
    SELECT
      coalesce(name, 'Unidentified') AS name,
      sum(amount) / 1e18 AS amount
    FROM
      alldeposits
      LEFT JOIN addresses_list q ON q.address = alldeposits.project
    GROUP BY
      1
  ),
  
  -- This CTE fetches all withdrawals from various projects within the last 7 days
  allwithdrawals AS (
    SELECT
      project,
      withdrawn_principal AS amount
    FROM
      dune.lido.result_withdrawals_transactions_assigned_to_projects -- query_1038304
    WHERE
      date_trunc('day', time) >= now() - interval '7' day
      AND withdrawn_principal > 0
  ),
  
  -- This CTE groups withdrawal amounts by protocol 
  withdrawals_projects AS (
    SELECT
      project AS name,
      sum(amount) AS amount
    FROM
      allwithdrawals
    GROUP BY
      1
  ),
  
  -- This CTE calculate the net growth of each project by subtracting withdrawals from deposits
  net_growth AS (
    SELECT
      COALESCE(d.name, w.name) AS name,
      ROW_NUMBER() OVER (
        ORDER BY
          COALESCE(d.amount, 0) - COALESCE(w.amount, 0) DESC
      ) AS row,
      COALESCE(d.amount, 0) AS eth_deposited,
      COALESCE(w.amount, 0) AS eth_withdrawn,
      COALESCE(d.amount, 0) - COALESCE(w.amount, 0) AS eth_deposits_growth
    FROM
      deposits_projects d
      FULL OUTER JOIN withdrawals_projects w ON d.name = w.name
  )
  
-- final query selects the Top 10 projects with positive deposit inflow 
SELECT
  *,
  name AS name_2
FROM
  net_growth
WHERE
  (
    row <= 10
    AND eth_deposits_growth > 0
  ) 
ORDER BY
  row ASC