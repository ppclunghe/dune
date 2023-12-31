--Name: Lido buffer
--Description: 
--Parameters: []
/*This query calculates amount of ETH in the Lido buffer since the launch of v2*/

--Lido's blocks
-- This CTE selects the blocks data and calculates the daily amount of gas burned by Lido
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
      miner = 0x388c818ca8b9251b393131c08a736a67ccb19297 --EL vault
  )
  
  --Txs of Lido's blocks
  -- This CTE calculates the daily fee cost for each block number from the previous CTE
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
  )
  
  --Txs aggregated by blocks
  -- This CTE aggregates the txns by block number, calculating max block time, total gas used, and fees per block
,
  eth_tx_agg AS (
    SELECT
      block_number,
      max(block_time) AS block_time,
      sum(gas_used) AS block_gas_used,
      sum(fee) AS fee
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
      LEFT JOIN blocks b on t.block_number = b.number
    ORDER BY
      block_number DESC
  ),
  
  -- This CTE retrieves withdrawal data FROM Lido Withdrawal Vault
  withdrawals AS (
    SELECT
      block_time AS time,
      sum(amount) / 1e9 AS amount
    FROM
      ethereum.withdrawals
    WHERE
      address = 0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f --withdrawal vault
    GROUP BY
      1
  )
  
  --Transfers
  -- This CTE gathers data on transfers to and from Lido addresses, including gas costs
,
  transfers AS (
    SELECT
      block_time AS time,
      (-1) * sum(cast(value AS DOUBLE)) / 1e18 AS amount
    FROM
      ethereum.traces
    WHERE
      "from" in (
        0xae7ab96520de3a18e5e111b5eaab095312d7fe84, --stETH
        0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, -- withdrawal vault
        0x388c818ca8b9251b393131c08a736a67ccb19297
      ) -- EL vault
      AND (
        LOWER(call_type) NOT in ('delegatecall', 'callcode', 'staticcall')
        OR   call_type is NULL
      )
      AND tx_success
      AND success
    GROUP BY
      1
    UNION all
    SELECT
      block_time AS time,
      sum(cast(value AS DOUBLE)) / 1e18
    FROM
      ethereum.traces
    WHERE
      to in (
        0xae7ab96520de3a18e5e111b5eaab095312d7fe84, -- stETH
        0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, -- withdrawal vault
        0x388c818ca8b9251b393131c08a736a67ccb19297
      ) -- EL vault
      AND (
        LOWER(call_type) NOT in ('delegatecall', 'callcode', 'staticcall')
        OR call_type is NULL
      )
      AND tx_success
      AND success
    GROUP BY
      1
    UNION all --gas costs
    SELECT
      block_time AS time,
      (-1) * sum(cast(gas_price * gas_used AS DOUBLE)) / 1e18
    FROM
      ethereum.transactions
    WHERE
      "from" in (
        0xae7ab96520de3a18e5e111b5eaab095312d7fe84, -- stETH
        0xb9d7934878b5fb9610b3fe8a5e441e8fad7e293f, -- withdrawal vault
        0x388c818ca8b9251b393131c08a736a67ccb19297
      ) -- EL vault
    GROUP BY
      1
  ),
  
   -- This CTE aggregates data from 'transfers', 'withdrawals', and 'block rewards' CTEs by day
  aggr_data AS (
    SELECT
      date_trunc('day', time) AS time,
      sum(amount) AS amount
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
  ),
  
  -- This CTE calculates cumulative Ethereum balance over time
  result AS (
    SELECT
      time,
      amount,
      sum(amount) over (
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
  time >= cast('2023-05-01' AS TIMESTAMP)