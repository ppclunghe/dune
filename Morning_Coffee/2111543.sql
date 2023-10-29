--Name: ETH staked with Lido (deposits + protocol buffer)
--Description: Dune SQL
--Parameters: []
/* 
This query calculates the amount of ETH daily deposited/withdrawn, 
cumulative amount of ETH deposited/withdrawn and amount of ETH in Lido buffer
*/

-- This CTE generate a data sequence from 2020-11-01 to the current date 
with calendar AS (
-- This inner CTE generates a sequence of dates from '2020-11-01' to the current date, with a one-day interval
  with day_seq AS (SELECT( sequence(cast('2020-11-01' AS DATE),cast(now() AS DATE), interval '1' day)) day )
    -- selects the individual dates from the day_seq CTE
    SELECT days.day
    FROM day_seq
    CROSS JOIN unnest(day) AS days(day)
)

 -- This CTE calculates the daily amount of ETH deposited into the Lido protocol
, lido_deposits_daily AS ( 
    
    SELECT date_trunc('day',block_time) AS time, SUM(cast(value AS DOUBLE))/1e18 AS lido_deposited
    FROM  ethereum.traces
    WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa --BC deposits 
      AND call_type = 'call'
      AND success = True 
      AND "from" in (0xae7ab96520de3a18e5e111b5eaab095312d7fe84, --stETH
                    0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f --Lido Withdrawal Vault
                    , 0xFdDf38947aFB03C621C71b06C9C70bce73f12999) --Lido Staking Router
    GROUP BY 1
    
)

-- This CTE calculates the daily amount of ETH withdrawn from the Lido Withdrawal Vault
, lido_all_withdrawals_daily AS (
    SELECT block_time AS time, SUM(amount)/1e9 AS amount,
    SUM(CASE WHEN amount/1e9 BETWEEN 20 AND 32 THEN CAST(amount AS DOUBLE)/1e9 
    WHEN amount/1e9 > 32 THEN 32 ELSE 0 END) AS withdrawn_principal
    FROM ethereum.withdrawals
    WHERE address = 0xB9D7934878B5FB9610B3fE8A5e441e8fad7E293f --Lido Withdrawal Vault
    GROUP BY 1
)

-- This CTE calculates the daily principal amount withdrawn from the Lido Withdrawal Vault
, lido_principal_withdrawals_daily AS (
    SELECT 
    date_trunc('day',time) AS time,
    (-1) * SUM(withdrawn_principal) AS amount
    FROM lido_all_withdrawals_daily
    WHERE withdrawn_principal > 0
    GROUP BY 1
 )

-- This CTE SELECTs data from 'query_2481449'(Lido protocol buffer) to get Lido protocol buffer amounts
, lido_buffer_amounts_daily AS (
SELECT * FROM query_2481449 
) 

-- The final SELECT statement combines the results from the CTEs to calculate various metrics for each day
SELECT 
    calendar.day
    , COALESCE(lido_deposited,0) AS lido_deposited_daily
    , SUM(COALESCE(lido_deposited,0)) over (ORDER BY calendar.day) AS lido_deposited_cumu
    , COALESCE(eth_balance,0) AS lido_buffer
    , COALESCE(withdrawals.amount,0) AS lido_witdrawals_daily
    , SUM(COALESCE(withdrawals.amount,0)) over (ORDER BY calendar.day) AS lido_withdrawals_cumu
    , SUM(COALESCE(lido_deposited,0)) over (ORDER BY calendar.day) + COALESCE(eth_balance,0) + SUM(COALESCE(withdrawals.amount,0)) over (ORDER BY calendar.day) AS lido_amount
FROM calendar
LEFT JOIN lido_deposits_daily AS lido_amounts ON lido_amounts.time = calendar.day
LEFT JOIN lido_buffer_amounts_daily AS buffer_amounts ON buffer_amounts.time = calendar.day
LEFT JOIN lido_principal_withdrawals_daily AS withdrawals ON withdrawals.time = calendar.day
ORDER BY 1
