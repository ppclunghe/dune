--Name: wstETH holders, wstETH
--Description: Dune SQL
--Parameters: []
/*
This query retrieves the amount of wstETH locked by protocol
*/

-- This CTE defines a list of addresses to be excluded
WITH
  not_address_list AS (
    SELECT
      0x0000000000000000000000000000000000000000 AS address
  ),
  
   -- This CTE specifies the contract address for wstETH
  contract_address AS (
    SELECT
      0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0 AS address
  ),
  
  --This CTE retrives and combines transfer data for wstETH
  transfers AS (
    SELECT
      DATE_TRUNC('day', evt_block_time) AS time,
      evt_tx_hash AS tx_hash,
      tr."from" AS address,
      0 AS amount_in,
      - cast(tr.value AS DOUBLE) AS amount_out
    FROM
      erc20_ethereum.evt_Transfer tr
    WHERE
      contract_address IN (
        SELECT
          address
        FROM
          contract_address
      )
      AND "from" NOT IN (
        SELECT
          address
        FROM
          not_address_list
      )
    UNION ALL
    SELECT
      DATE_TRUNC('day', evt_block_time) AS time,
      evt_tx_hash AS tx_hash,
      tr."to" AS address,
      cast(tr.value AS DOUBLE) AS amount_in,
      0 AS amount_out
    FROM
      erc20_ethereum.evt_Transfer tr
    WHERE
      contract_address IN (
        SELECT
          address
        FROM
          contract_address
      )
      AND "to" NOT IN (
        SELECT
          address
        FROM
          not_address_list
      )
  ),
  
  -- This CTE assigns a namespace from 'query_2415558'(LSTs holders list) to each address 
  namespace AS (
    SELECT DISTINCT
      a.address,
      COALESCE(b.namespace, c.namespace) AS namespace,
      COALESCE(NULLIF(b.namespace, ''), 'depositor')
    FROM
      (
        SELECT DISTINCT
          (address) AS address
        FROM
          transfers
      ) a
      LEFT JOIN (
        SELECT
          *
        FROM
          query_2415558
      ) b ON a.address = b.address
      LEFT JOIN ethereum.contracts c ON a.address = c.address
  )

-- This CTE aggregates the transfer data by address and namespace,
 -- calculating the total amount in, amount out, and balance for each and filtering by balance 
SELECT distinct
  tr.address,
  namespace,
  sum(amount_in) / 1e18 AS amount_in,
  sum(amount_out) / 1e18 AS amount_out,
  sum(amount_in) / 1e18 + sum(amount_out) / 1e18 AS balance
FROM
  transfers tr
  LEFT JOIN namespace n ON n.address = tr.address
WHERE
  namespace NOT in (
    'depositor',
    'gnosis_multisig',
    'gnosis_safe',
    'proxy_multisig',
    'proxy',
    'argent'
  )
GROUP BY
  1,
  2
HAVING
  (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 100
ORDER BY
  balance DESC
 