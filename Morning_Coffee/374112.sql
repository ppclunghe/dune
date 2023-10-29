--Name: Curve ETH/stETH
--Description: Dune SQL
--Parameters: []
/* 
This query calculates daily balance and TVL of Curve ETH/stETH pool, reserves of tokens and price rate
*/
-- THIS CTE generates a sequence of days since 2021-01-05
with
  dates AS (
    with
      day_seq AS (
        SELECT
          (
            sequence(
              cast('2021-01-05' AS TIMESTAMP),
              cast(now() AS TIMESTAMP),
              interval '1' day
            )
          ) AS day
      )
    -- selects the individual day from the hour_seq CTE  
    SELECT
      days.day
    FROM
      day_seq
      CROSS JOIN  unnest (day) AS days (day)
  ),
  
  -- This CTE retrieves data related to wrapped/unwrapped stETH transactions
  volumes AS (
    SELECT
      u.call_block_time AS time,
      "output_0" AS steth,
      "_wstETHAmount" AS wsteth
    FROM
      lido_ethereum.WstETH_call_unwrap u
    WHERE
      "call_success" = TRUE
    UNION all
    SELECT
      u."call_block_time",
      "_stETHAmount" AS steth,
      "output_0" AS wsteth
    FROM
      lido_ethereum.WstETH_call_wrap u
    WHERE
      "call_success" = TRUE
  ),
  
  -- This CTE calculates the rate of stETH to wstETH over time with 1-day intervals
  wsteth_rate AS (
    SELECT
      day,
      rate AS rate0,
      value_partition,
      first_value(rate) over (
        partition by
          value_partition
        ORDER BY
          day
      ) AS rate,
      lead(
        day,
        1,
        date_trunc('day', now() + interval '1' day)
      ) over (
        ORDER BY
          day
      ) AS next_day
    FROM
      (
        SELECT
          day,
          rate,
          SUM(
            CASE
              WHEN rate is NULL THEN 0
              ELSE 1
            END
          ) over (
            ORDER BY
              day
          ) AS value_partition
        FROM
          (
            SELECT
              date_trunc('day', d.day) AS day,
              CASE
                WHEN date_trunc('day', d.day) = cast('2021-01-07' AS TIMESTAMP) THEN 1
                ELSE SUM(cast(steth AS DOUBLE)) / SUM(cast(wsteth AS DOUBLE))
              END AS rate
            FROM
              dates d
              LEFT JOIN volumes v on date_trunc('day', v.time) = date_trunc('day', d.day)
            GROUP BY
              1
          )
      )
  ),
  
    -- This CTE calculate the daily amount of stETH transferred into the Curve ETH/stETH pool
  steth_in AS (
    SELECT
      DATE_TRUNC('day', evt_block_time) AS time,
      SUM(cast("value" AS DOUBLE)) / 1e18 AS steth_in,
      SUM(cast("value" AS DOUBLE) / COALESCE(r.rate, 1)) / 1e18 AS wsteth_in,
      r.rate
    FROM
      erc20_ethereum.evt_Transfer t
      LEFT JOIN wsteth_rate r on DATE_TRUNC('day', evt_block_time) >= r.day
      AND DATE_TRUNC('day', evt_block_time) < r.next_day
    WHERE
      "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84
      AND ("to" = 0xdc24316b9ae028f1497c275eb9192a3ea0f67022)
    GROUP BY
      1,
      4
  ),
  
  -- This CTE calculate the daily amount of stETH transferred out of the Curve ETH/stETH pool
  steth_out AS (
    SELECT
      DATE_TRUNC('day', evt_block_time) AS time,
      - SUM(cast("value" AS DOUBLE)) / 1e18 AS steth_in,
      - SUM(cast("value" AS DOUBLE) / COALESCE(r.rate, 1)) / 1e18 AS wsteth_in,
      rate
    FROM
      erc20_ethereum.evt_Transfer t
      LEFT JOIN wsteth_rate r on DATE_TRUNC('day', evt_block_time) >= r.day
      AND DATE_TRUNC('day', evt_block_time) < r.next_day
    WHERE
      "contract_address" = 0xae7ab96520de3a18e5e111b5eaab095312d7fe84
      AND (
        "from" = 0xdc24316b9ae028f1497c275eb9192a3ea0f67022
      )
    GROUP BY
      1,
      4
  ),
  
  -- This CTE calculates the daily balance of stETH and wstETH 
  daily_balances AS (
    SELECT
      time,
      SUM(steth_in) steth_balance,
      SUM(wsteth_in) AS wsteth_balance
    FROM
      (
        SELECT
          *
        FROM
          steth_in
        UNION all
        SELECT
          *
        FROM
          steth_out
      )
    GROUP BY
      1
  ),
  
  -- This CTE calculates the cumulative balance of (w)stETH and daily conversion from wstETH to stETH
  steth_balances AS (
    SELECT
      time,
      steth_balance,
      SUM(steth_balance) over (
        ORDER BY
          time
      ) AS steth_cumu,
      SUM(COALESCE(wsteth_balance, steth_balance)) over (
        ORDER BY
          time
      ) AS wsteth_cumu,
      r.rate,
      (
        SUM(COALESCE(wsteth_balance, steth_balance)) over (
          ORDER BY
            time
        )
      ) * COALESCE(r.rate, 1) AS steth_from_wsteth
    FROM
      daily_balances b
      LEFT JOIN wsteth_rate r on b.time >= r.day
      AND b.time < r.next_day
    ORDER BY
      1
  ),
  
  -- This CTE calculates the balance of ETH in the pool
  eth_balances AS (
    SELECT
      time,
      lead(
        time,
        1,
        date_trunc('day', now() + interval '1' day)
      ) over (
        ORDER BY
          time
      ) AS next_time,
      SUM(eth_amount) over (
        ORDER BY
          time
      ) AS eth_pool
    FROM
      (
        SELECT
          date_trunc('day', block_time) AS time,
          SUM(amount) AS eth_amount
        FROM
          (
            -- outbound transfers
            SELECT
              block_time,
              "from" AS address,
              - cast(tr.value AS DOUBLE) / 1e18 AS amount
            FROM
              ethereum.traces tr
            WHERE
              "from" = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
              AND success
              AND (
                call_type NOT IN ('delegatecall', 'callcode', 'staticcall')
                OR call_type IS NULL
              )
            UNION ALL
            -- inbound transfers
            SELECT
              block_time,
              "to" AS address,
              cast(value AS DOUBLE) / 1e18 AS amount
            FROM
              ethereum.traces
            WHERE
              "to" = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
              AND success
              AND (
                call_type NOT IN ('delegatecall', 'callcode', 'staticcall')
                OR call_type IS NULL
              )
            UNION ALL
            -- gas costs
            SELECT
              block_time,
              "from" AS address,
              - cast(gas_price AS DOUBLE) * cast(gas_used AS DOUBLE) / 1e18
            FROM
              ethereum.transactions et
            WHERE
              "from" = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022
              AND success
          ) t
        GROUP BY
          1
      ) eth
    ORDER BY
      1 DESC
  ),
  
  -- This CTE retrieves the daily average price of ETH 
  weth_prices_daily AS (
    SELECT distinct
      DATE_TRUNC('day', minute) AS time,
      AVG(price) AS price
    FROM
      prices.usd
    WHERE
      date_trunc('day', minute) >= cast('2021-01-05' AS TIMESTAMP)
      AND date_trunc('day', minute) < date_trunc('day', now())
      AND blockchain = 'ethereum'
      AND symbol = 'WETH'
    GROUP BY
      1
    UNION all
    SELECT distinct
      DATE_TRUNC('day', minute),
      last_value(price) over (
        partition by
          DATE_TRUNC('day', minute),
          contract_address
        ORDER BY
          minute range between unbounded preceding
          AND unbounded following
      ) AS price
    FROM
      prices.usd
    WHERE
      date_trunc('day', minute) = date_trunc('day', now())
      AND blockchain = 'ethereum'
      AND symbol = 'WETH'
  ),
  
  -- This CTE retrieves the hourly price of ETH 
  weth_prices_hourly AS (
    SELECT
      time,
      lead(
        time,
        1,
        DATE_TRUNC('hour', now() + interval '1' hour)
      ) over (
        ORDER BY
          time
      ) AS next_time,
      price
    FROM
      (
        SELECT distinct
          DATE_TRUNC('hour', minute) time,
          last_value(price) over (
            partition by
              DATE_TRUNC('hour', minute),
              contract_address
            ORDER BY
              minute range between unbounded preceding
              AND unbounded following
          ) AS price
        FROM
          prices.usd
        WHERE
          date_trunc('hour', minute) >= cast('2021-01-05' AS TIMESTAMP)
          AND blockchain = 'ethereum'
          AND symbol = 'WETH'
      )
  ),
  
  -- This CTE retrieves the daily average price of stETH 
  steth_prices_daily AS (
    SELECT distinct
      DATE_TRUNC('day', minute) AS time,
      AVG(price) AS price
    FROM
      prices.usd
    WHERE
      date_trunc('day', minute) >= cast('2021-01-05' AS TIMESTAMP)
      AND date_trunc('day', minute) < date_trunc('day', now())
      AND blockchain = 'ethereum'
      AND contract_address = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84
    GROUP BY
      1
    UNION all
    SELECT distinct
      DATE_TRUNC('day', minute),
      last_value(price) over (
        partition by
          DATE_TRUNC('day', minute),
          contract_address
        ORDER BY
          minute range between unbounded preceding
          AND unbounded following
      ) AS price
    FROM
      prices.usd
    WHERE
      date_trunc('day', minute) = date_trunc('day', now())
      AND blockchain = 'ethereum'
      AND contract_address = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84
  ),
  
  -- This CTE retrieves the hourly exchange data to calculate trading volume
  token_exchange_hourly AS (
    SELECT
      date_trunc('hour', evt_block_time) AS time,
      SUM(
        CASE
          WHEN cast(sold_id AS INT) = 0 THEN cast(tokens_sold AS DOUBLE)
          ELSE cast(tokens_bought AS DOUBLE)
        END
      ) AS eth_amount_raw
    FROM
      curvefi_ethereum.steth_swap_evt_TokenExchange c
    GROUP BY
      1
  ),
  
  -- This CTE calculates the hourly trading volume of the pool
  trading_volume_hourly AS (
    SELECT
      t.time,
      t.eth_amount_raw * wp.price AS volume_raw
    FROM
      token_exchange_hourly t
      LEFT JOIN weth_prices_hourly wp ON t.time = wp.time
    ORDER BY
      1
  ),
  
  trading_volume AS (
    SELECT distinct
      date_trunc('day', time) AS time,
      SUM(volume_raw) / 1e18 AS volume
    FROM
      trading_volume_hourly
    GROUP BY
      1
  ),
  
  -- This CTE calculates the daily rate of stETH to ETH
  steth_eth_rate AS (
    SELECT
      time,
      AVG(price) AS avg_price,
      MIN(price) AS min_price,
      MAX(price) AS max_price,
      SUM(price * amount) / SUM(amount) AS weight_avg_price
    FROM
      (
        SELECT
          DATE_TRUNC('day', evt_block_time) AS time,
          cast(tokens_sold AS DOUBLE) / cast(tokens_bought AS DOUBLE) AS price,
          cast(tokens_bought AS DOUBLE) AS amount
        FROM
          curvefi_ethereum.steth_swap_evt_TokenExchange
        WHERE
          cast(sold_id AS DOUBLE) = 0
          AND cast(tokens_bought AS DOUBLE) <> 0
        UNION all
        (
          SELECT
            DATE_TRUNC('day', evt_block_time) AS time,
            cast(tokens_bought AS DOUBLE) / cast(tokens_sold AS DOUBLE) AS price,
            cast(tokens_sold AS DOUBLE) AS amount
          FROM
            curvefi_ethereum.steth_swap_evt_TokenExchange
          WHERE
            cast(sold_id AS DOUBLE) = 1
            AND cast(tokens_sold AS DOUBLE) <> 0
        )
      ) price_both
    GROUP BY
      1
  )
  
--final query combines all the calculated data from the previous CTEs 
SELECT
  d.day AS time,
  steth_balance AS "daily balance, stETH",
  steth_from_wsteth AS steth_pool,
  COALESCE(eth.eth_pool, 0) AS eth_pool,
  steth_from_wsteth * COALESCE(stethp.price, wethp.price) + COALESCE(eth.eth_pool, 0) * wethp.price AS tvl,
  (r.weight_avg_price -1) * 100 AS price_to_eth
FROM
  dates d
  LEFT JOIN steth_balances b on d.day = b.time
  LEFT JOIN eth_balances eth on d.day = eth.time
  LEFT JOIN steth_prices_daily stethp on d.day = stethp.time
  LEFT JOIN weth_prices_daily wethp on d.day = wethp.time
  LEFT JOIN trading_volume v on d.day = v.time
  LEFT JOIN steth_eth_rate r on d.day = r.time
ORDER BY
  1
  