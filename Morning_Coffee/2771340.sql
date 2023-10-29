--Name: Liquidations last 7 days
--Description: 
--Parameters: []
/*
This query calculates the number of liquidations and their amount by protocol
 with collateral asset for the last 7 days on Mainnet, Arbitrum, Optimism and Polygon
*/

-- This CTE generates a table containing reserve addresses and their corresponding symbols
with
  reserves (address, symbol) AS (
    SELECT
      *
    FROM
      (
        values
          (
            0xae7ab96520de3a18e5e111b5eaab095312d7fe84,
            'stETH'
          ),
          (
            0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0,
            'wstETH'
          ),
          (
            0x5979d7b546e38e414f7e9822514be443a4800529,
            'wstETH'
          ), --arbitrum
          (
            0x1f32b1c2345538c0c6f582fcb022739c4a194ebb,
            'wstETH'
          ), --opti
          (
            0x03b54A6e9a984069379fae1a4fC4dBAE93B3bCCD,
            'wstETH'
          ) --poly
      )
  ),
  
  -- This CTE gathers liquidation data for lending market 
  markets_data AS (
    SELECT
      'aave v2' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      aave_v2_ethereum.LendingPool_evt_LiquidationCall l
      JOIN reserves r on l."collateralAsset" = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Aave V3 on Ethereum
    SELECT
      'aave v3' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      aave_v3_ethereum.Pool_evt_LiquidationCall l
      JOIN reserves r on l.collateralAsset = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Aave V3 on Arbitrum
    SELECT
      'aave v3' AS protocol,
      'arbitrum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      aave_v3_arbitrum.L2Pool_evt_LiquidationCall l
      JOIN reserves r on l.collateralAsset = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Aave V3 on Optimism
    SELECT
      'aave v3' AS protocol,
      'optimism' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      aave_v3_optimism.Pool_evt_LiquidationCall l
      JOIN reserves r on l.collateralAsset = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Aave V3 on Polygon
    SELECT
      'aave v3' AS protocol,
      'polygon' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      aave_v3_polygon.Pool_evt_LiquidationCall l
      JOIN reserves r on l.collateralAsset = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Compound on Ethereum
    SELECT
      'compound' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM(collateralAbsorbed) / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      compound_v3_ethereum.cWETHv3_evt_AbsorbCollateral l
      JOIN reserves r on l.contract_address = r.address
    WHERE
      DATE_TRUNC('day', evt_block_time) >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Maker(wsteth-a) on Ethereum
    SELECT
      'maker(wsteth-a)' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      sum("ink") / 1e18 AS collateral_amount,
      'wstETH' AS token,
      COUNT(*) AS "# liq"
    FROM
      maker_ethereum.dog_evt_Bark dog
    WHERE
      dog."ilk" = 0x5753544554482d41000000000000000000000000000000000000000000000000
      and DATE_TRUNC('day', evt_block_time) >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Maker(wsteth-b) on Ethereum
    SELECT
      'maker(wsteth-b)' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      sum("ink") / 1e18 AS collateral_amount,
      'wstETH' AS token,
      COUNT(*) AS "# liq"
    FROM
      maker_ethereum.dog_evt_Bark dog
    WHERE
      dog."ilk" = 0x5753544554482d42000000000000000000000000000000000000000000000000
      and DATE_TRUNC('day', evt_block_time) >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Maker(stecrv) on Ethereum
    SELECT
      'maker(stecrv)' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      sum("ink") / 1e18 AS collateral_amount,
      'steCRV' AS token,
      COUNT(*) AS "# liq"
    FROM
      maker_ethereum.dog_evt_Bark dog
    WHERE
      dog."ilk" = 0x5753544554482d42000000000000000000000000000000000000000000000000
      and DATE_TRUNC('day', evt_block_time) >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Raft protocol on Ethereum
    SELECT
      'raft' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM(cast(collateralLiquidated AS double)) / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      raft_deposit_ethereum.PositionManager_evt_Liquidation l
      JOIN reserves r on l.collateralToken = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Spark protocol on Ethereum
    SELECT
      'spark' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      spark_protocol_ethereum.Pool_evt_LiquidationCall l
      JOIN reserves r on l.collateralAsset = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Radiant protocol on Arbitrum
    SELECT
      'radiant' AS protocol,
      'arbitrum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM("liquidatedCollateralAmount") / CAST(1e18 AS DOUBLE) AS collateral_amount,
      r.symbol AS token,
      COUNT(*) AS "# liq"
    FROM
      radiant_capital_arbitrum.LendingPool_evt_LiquidationCall l
      JOIN reserves r on l.collateralAsset = r.address
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
    UNION all
    -- this part gathers data for Curve(crvUSD) on Ethereum
    SELECT
      'curve(crvUSD)' AS protocol,
      'ethereum' AS blockchain,
      DATE_TRUNC('day', "evt_block_time") AS time,
      SUM(cast(collateral_received AS double)) / CAST(1e18 AS DOUBLE) AS collateral_amount,
      'wstETH' AS token,
      COUNT(*) AS "# liq"
    FROM
      curvefi_ethereum.crvusd_controller_wsteth_evt_Liquidate l
    WHERE
      DATE_TRUNC('day', "evt_block_time") >= DATE_TRUNC('day', now()) - interval '7' day
    GROUP BY
      1,
      2,
      3,
      5
  )
  
-- final query retrieves the consolidated data for all protocols and blockchains  
SELECT
  time,
  collateral_amount,
  token,
  "# liq",
  protocol,
  blockchain
FROM
  markets_data
WHERE
  collateral_amount > 0.01
order by
  time desc,
  collateral_amount