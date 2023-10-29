--Name: Lido buffer 7d ago
--Description: 
--Parameters: []
/* 
This query returns the amount of ETH in Lido buffer for the last 7 days
 */
 
--Lido's blocks
-- This CTE selects the blocks data and calculates the daily amount of gas burned by Lido in the last 7 days
with
  blocks AS (
    SELECT
      number,
      blocks.time,
      blocks.base_fee_per_gas,
      blocks.gas_used,
      blocks.base_fee_per_gas * blocks.gas_used / 1e18 AS total_burn
    FROM
      ethereum.blocks
    WHERE
      miner = 0x388c818ca8b9251b393131c08a736a67ccb19297
      AND blocks.time <= now() - interval '168' hour
  )
  
  --Txs of Lido's blocks
  -- This CTE calculates the daily fee cost for each block number from the previous CTE within the last 7 days
,
  eth_tx AS (
    SELECT
      block_time,
      block_number,
      gas_used,
      gas_used * gas_price / 1e18 AS fee
    FROM
      ethereum.transactions
    WHERE
      block_number in (
        SELECT distinct
          number
        FROM
          blocks
      )
      AND block_time <= now() - interval '168' hour
  )
  
  --Txs aggregated by blocks
  -- This CTE aggregates the txns by block number, calculating max block time, total gas used, and fees per block
,
  eth_tx_agg AS (
    SELECT
      block_number,
      MAX(block_time) AS block_time,
      SUM(gas_used) AS block_gas_used,
      SUM(fee) AS fee
    FROM
      eth_tx
    GROUP BY
      block_number
  )
  
  --Blocks rewards
  -- This CTE calculates block rewards by subtracting total burn from fees
,
  blocks_rewards AS (
    SELECT
      block_number,
      block_time,
      block_gas_used,
      fee - b.total_burn block_reward
    FROM
      eth_tx_agg t
      LEFT JOIN blocks b ON t.block_number = b.number
    ORDER BY
      block_number DESC
  )
  
  -- This CTE retrieves withdrawal data FROM Lido Withdrawal Vault in the last 7 days
,
  withdrawals AS (
    SELECT
      block_time AS time,
      SUM(amount) / 1e9 AS amount
    FROM
      ethereum.withdrawals
    WHERE
      address = 0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f
      AND block_time <= now() - interval '168' hour
    GROUP BY
      1
  )
  
  --Transfers 
  -- This CTE gathers data on transfers to and from Lido addresses, including gas costs
,
  transfers AS (
    SELECT
      block_time AS time,
      (-1) * SUM(cast(value AS DOUBLE)) / 1e18 AS amount
    FROM
      ethereum.traces
    WHERE
      "from" in (
        0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
        0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, --withdrawal vault
        --0x889edC2eDab5f40e902b864aD4d7AdE8E412F9B1, --withdrawal queue
        0x388c818ca8b9251b393131c08a736a67ccb19297
      ) --EL vault
      AND block_time <= now() - interval '168' hour
      AND (
        LOWER(call_type) NOT in ('delegatecall', 'callcode', 'staticcall')
        OR call_type is NULL
      )
      AND tx_success
      AND success
    GROUP BY
      1
    UNION all
    SELECT
      block_time AS time,
      SUM(cast(value AS DOUBLE)) / 1e18
    FROM
      ethereum.traces
    WHERE
      to in (
        0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
        0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, --withdrawal vault
        0x388c818ca8b9251b393131c08a736a67ccb19297
      )
      AND (
        LOWER(call_type) NOT in ('delegatecall', 'callcode', 'staticcall')
        OR call_type is NULL
      )
      AND block_time <= now() - interval '168' hour
      AND tx_success
      AND success
    GROUP BY
      1
    UNION all --gas costs
    SELECT
      block_time AS time,
      (-1) * SUM(cast(gas_price * gas_used AS DOUBLE)) / 1e18
    FROM
      ethereum.transactions
    WHERE
      "from" in (
        0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
        0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, --withdrawal vault
        0x388c818ca8b9251b393131c08a736a67ccb19297
      )
      AND block_time <= now() - interval '168' hour
    GROUP BY
      1
  )
  
  -- This CTE aggregates data from 'transfers', 'withdrawals', and 'block rewards' CTEs by day
,
  aggr_data AS (
    SELECT
      date_trunc('day', time) AS time,
      SUM(amount) AS amount
    FROM
      (
        SELECT
          *
        FROM
          transfers
        UNION all
        SELECT
          *
        FROM
          withdrawals
        UNION all
        SELECT
          block_time,
          block_reward
        FROM
          blocks_rewards
      )
    GROUP BY
      1
  )
  
  -- This CTE calculates cumulative Ethereum balance over time
,
  result AS (
    SELECT
      time,
      amount,
      SUM(amount) over (
        ORDER BY
          time
      ) AS eth_balance
    FROM
      aggr_data
    ORDER BY
      time DESC
  )
  
  -- final select data from 'result' CTE after May 1, 2023
SELECT
  *
FROM
  result
WHERE
  time >= cast('2023-05-01' AS timestamp)