--Name: Deposits_assigned_to_projects
--Description: 
--Parameters: []
/*
This query (materialized view "dune.lido.result_deposits_assigned_to_projects") retrieves
transactiONs related to staking deposits, revealing project associations, categories, liquidity, and deposits amounts
 */
-- This CTE retrieves depositor information from mat view ('query_2005642' ETH depositors labels)
with
  addresses_list AS (
    SELECT
      *
    FROM
      dune.lido.result_eth_depositors_labels --query_2005642
  )
  -- This CTE categorizes projects and retrieves their daily deposit amounts, excluding data for batch deposit contracts 
,
  data AS (
    SELECT
      time,
      amount,
      CASE
        WHEN project in (
          SELECT
            address
          FROM
            dune.lido.dataset_solo_test
        ) THEN 'Solo Staker'
        ELSE coalesce(q.name, 'Unidentified')
      END AS name,
      CASE
        WHEN project in (
          SELECT
            address
          FROM
            dune.lido.dataset_solo_test
        ) THEN 'Solo Staker'
        ELSE coalesce(q.category, 'Unidentified')
      END AS category,
      CASE
        WHEN project in (
          SELECT
            address
          FROM
            dune.lido.dataset_solo_test
        ) THEN 'Individual'
        ELSE coalesce(q.liquidity, 'Unidentified')
      END AS liquidity,
      CASE
        WHEN project in (
          SELECT
            address
          FROM
            dune.lido.dataset_solo_test
        ) THEN 0x0000000000000000000000000000000000000000
        ELSE project
      END AS address
    FROM
      ( 
        SELECT
          t.block_time AS time,
          t."from" AS project,
          cast(t.value AS DOUBLE) / 1e18 AS amount
        FROM
          ethereum.traces t
        WHERE
          to = 0x00000000219ab540356cbb839cbe05303d7705fa
          AND success = True
          AND DATE_trunc('day', block_time) >= cast('2020-11-03' AS DATE)
          AND call_type = 'call'
          AND "from" NOT in (
            SELECT distinct
              contract
            FROM
              query_3146090
          )
      ) t
      LEFT JOIN addresses_list q ON q.address = t.project
    UNION all
    SELECT
      time,
      sum(amount) AS amount,
      entity,
      category,
      liquidity,
      cONtract
    FROM
      query_3146090
    GROUP BY
      1,
      3,
      4,
      5,
      6
  )
  
-- Final SELECT statement aggregates data from previous CTE
SELECT
  time,
  sum(amount) AS amount,
  name,
  category,
  liquidity,
  address
FROM
  data
GROUP BY
  1,
  3,
  4,
  5,
  6
  /* 2023-10-27
  with 
  addresses_list AS (
  select * 
  from dune.lido.result_eth_depositors_labels
  --from query_2005642
  
  )
  
  
  
  select
  time,
  amount,
  CASE WHEN project in (select address from dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE coalesce(q.name, 'Unidentified') END AS name,
  CASE WHEN project in (select address from dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE coalesce(q.category,'Unidentified') END AS category,
  CASE WHEN project in (select address from dune.lido.dataset_solo_test) THEN 'Individual' ELSE coalesce(q.liquidity,'Unidentified') END AS liquidity,
  CASE WHEN project in (select address from dune.lido.dataset_solo_test) THEN 0x0000000000000000000000000000000000000000  ELSE project END AS address
  
  from
  (
  select 
  block_time AS time,
  "from" AS project,
  cast(value AS DOUBLE)/1e18 AS amount
  from  ethereum.traces t
  WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa
  AND success = True
  AND DATE_trunc('day', block_time) >= cast('2020-11-03' AS DATE)
  AND call_type = 'call'
  ) t
  LEFT JOIN addresses_list q ON q.address = t.project
   */