--Name: stETH locked by protocol 1d ago
--Description: 
--Parameters: []
/* 
This query returns the amount of (w)stETH locked by protocol 1 day ago
 */
 
-- This CTE defines a list of addresses to be excluded 
with
  not_address_list AS ( 
    SELECT
      0x0000000000000000000000000000000000000000 AS address
    UNION
    SELECT
      0xD15a672319Cf0352560eE76d9e89eAB0889046D3 -- Burner  
  ),
  
  -- This CTE specifies the contract address for stETH
  contract_address AS (
    SELECT
      0xae7ab96520de3a18e5e111b5eaab095312d7fe84 AS address --stETH 
  ),
  
 --This CTE retrives stETH transfers data
  transfers AS (
    SELECT
      DATE_TRUNC('day', evt_block_time) AS time,
      evt_tx_hash AS tx_hash,
      tr."from" AS address,
      0 AS amount_in,
      - cast(tr.value AS DOUBLE) AS amount_out
    FROM
      lido_ethereum.steth_evt_Transfer tr
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
      AND date_trunc('day', evt_block_time) <= now() - interval '1' day
    UNION ALL
    SELECT
      DATE_TRUNC('day', evt_block_time) AS time,
      evt_tx_hash AS tx_hash,
      tr.to AS address,
      cast(tr.value AS DOUBLE) AS amount_in,
      0 AS amount_out
    FROM
      lido_ethereum.steth_evt_Transfer tr
    WHERE
      contract_address IN (
        SELECT
          address
        FROM
          contract_address
      )
      AND to NOT IN (
        SELECT
          address
        FROM
          not_address_list
      )
      AND date_trunc('day', evt_block_time) <= now() - interval '1' day
  ),
  
  -- This CTE assigns a namespace from 'query_2415558'(LSTs holders list) to each address 
  namespace AS (
    SELECT DISTINCT
      a.address,
      COALESCE(b.namespace, c.namespace) as namespace,
      COALESCE(NULLIF(c.namespace, ''), 'depositor')
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
  ),
  
  -- This CTE aggregates the transfer data by address AND namespace,
  -- calculating the total amount in, amount out, AND balance for each
  steth_table AS (
    SELECT distinct
      tr.address,
      namespace,
      sum(amount_in) / 1e18 as amount_in,
      sum(amount_out) / 1e18 as amount_out,
      sum(amount_in) / 1e18 + sum(amount_out) / 1e18 as balance
    FROM
      transfers tr
      LEFT JOIN namespace n ON n.address = tr.address
    where
      namespace != 'depositor' --and namespace != 'gnosis_multisig' and namespace != 'gnosis_safe' and namespace != 'proxy_multisig'
    GROUP BY
      1,
      2
    HAVING
      (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 10
    ORDER BY
      balance DESC
  ),
  
   --This CTE retrieves the amount of wstETH locked by protocol
  wsteth_table as (
    -- This inner CTE defines a list of addresses to be excluded
    with
      not_address_list AS (
        SELECT
          0x0000000000000000000000000000000000000000 as address
      ),
      
      -- This CTE specifies the contract address for wstETH
      contract_address AS (
        SELECT
          0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0 as address
      ),
      
      --This CTE retrives wstETH transfers data
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
          AND date_trunc('day', evt_block_time) <= now() - interval '1' day
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
          AND date_trunc('day', evt_block_time) <= now() - interval '1' day
      ),
      
      -- This CTE assigns a namespace from 'query_2415558'(LSTs holders list) to each address 
      namespace AS (
        SELECT DISTINCT
          a.address,
          COALESCE(b.namespace, c.namespace) as namespace,
          COALESCE(NULLIF(c.namespace, ''), 'depositor')
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
    SELECT distinct
      tr.address,
      namespace,
      sum(amount_in) / 1e18 as amount_in,
      sum(amount_out) / 1e18 as amount_out,
      sum(amount_in) / 1e18 + sum(amount_out) / 1e18 as balance
    FROM
      transfers tr
      LEFT JOIN namespace n ON n.address = tr.address
    where
      namespace != 'depositor'
    GROUP BY
      1,
      2
    HAVING
      (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 10
    ORDER BY
      balance DESC
  ),
  
   -- This CTE calculates the conversion rate between stETH and wstETH over a 24-hour period within the past 48 hours
  wsteth_rate as (
    SELECT
      SUM(steth) / CAST(SUM(wsteth) AS DOUBLE) AS price
    FROM
      (
        SELECT
          DATE_TRUNC('day', call_block_time) AS time,
          output_0 AS steth,
          _wstETHAmount AS wsteth
        FROM
          lido_ethereum.WstETH_call_unwrap
        WHERE
          call_success = TRUE
          AND call_block_time <= CAST(now() as timestamp) - interval '24' hour
          AND call_block_time >= CAST(now() as timestamp) - interval '48' hour
        UNION ALL
        SELECT
          DATE_TRUNC('day', call_block_time) AS time,
          _stETHAmount AS steth,
          output_0 AS wsteth
        FROM
          lido_ethereum.WstETH_call_wrap
        WHERE
          call_success = TRUE
          AND call_block_time <= CAST(now() as timestamp) - interval '24' hour
          AND call_block_time >= CAST(now() as timestamp) - interval '48' hour
      )
  ),
  
  -- This CTE merges stETH data with wstETH data from previous CTEs
  combined AS (
    SELECT
      *
    FROM
      steth_table
    WHERE
      address <> 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0
    UNION ALL
    SELECT
      address,
      namespace,
      amount_in * (
        SELECT
          price
        FROM
          wsteth_rate
      ) as amount_in,
      amount_out * (
        SELECT
          price
        FROM
          wsteth_rate
      ) as amount_out,
      balance * (
        SELECT
          price
        FROM
          wsteth_rate
      ) as balance
    FROM
      wsteth_table 
  )
  
-- final SELECT statement combines and summarizes the data, including data for 'aave_v2' from 'query_459431' (Aave V2 lending pool) 
 -- and 'curve' from 'query_374112'(Curve ETH/stETH), filtering from the previous day    
SELECT
  address,
  namespace,
  SUM(amount_in) + SUM(amount_out) AS balance
FROM
  combined
where
  address not in (
    0x1982b2f5814301d4e9a8b0201555376e62f82428,
    0xdc24316b9ae028f1497c275eb9192a3ea0f67022
  )
GROUP BY
  1,
  2
UNION all
SELECT
  0x1982b2f5814301d4e9a8b0201555376e62f82428 AS address,
  'aave_v2' AS namespace,
  "cumulative balance, stETH" AS balance
FROM
  query_459431
where
  day = (
    SELECT
      max(day) - interval '1' day
    FROM
      query_459431
  )
UNION all
SELECT
  0xdc24316b9ae028f1497c275eb9192a3ea0f67022 AS address,
  'curve' AS namespace,
  steth_pool AS balance
FROM
  query_374112
where
  time = (
    SELECT
      max(time) - interval '1' day
    FROM
      query_374112
  )
ORDER BY
  balance DESC