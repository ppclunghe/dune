--Name: stETH locked by protocol 1d ago
--Description: 
--Parameters: []
/* This query returns the amount of stETH locked by protocol 1 day ago
*/

 with not_address_list AS ( --from query steth holders without curve
SELECT
    0x0000000000000000000000000000000000000000 AS address
union 
SELECT
     0xD15a672319Cf0352560eE76d9e89eAB0889046D3 -- Burner  
)

,contract_address AS (
SELECT
    0xae7ab96520de3a18e5e111b5eaab095312d7fe84 AS address --stETH 
)

,
transfers AS (
SELECT
    DATE_TRUNC('day', evt_block_time) AS time,
    evt_tx_hash AS tx_hash,
    tr."from"  AS address,
    0 AS amount_in,
    -cast(tr.value as double) AS amount_out
FROM lido_ethereum.steth_evt_Transfer tr
WHERE contract_address IN (SELECT address FROM contract_address) 
AND  "from"  NOT IN (SELECT address FROM not_address_list)
and date_trunc('day', evt_block_time) <= now() - interval '1' day

UNION ALL

SELECT
    DATE_TRUNC('day', evt_block_time) AS time,
    evt_tx_hash AS tx_hash,
    tr.to  AS address,
    cast(tr.value as double) AS amount_in,
    0 AS amount_out
FROM lido_ethereum.steth_evt_Transfer tr 
WHERE contract_address IN (SELECT address FROM contract_address) 
AND  to  NOT IN (SELECT address FROM not_address_list)
and date_trunc('day', evt_block_time) <= now() - interval '1' day
)


, namespace AS (

    SELECT DISTINCT
        a.address
        , COALESCE(b.namespace, c.namespace) as namespace
        , COALESCE(NULLIF(c.namespace,''),'depositor')
    FROM (SELECT DISTINCT(address) AS address FROM transfers) a
    LEFT JOIN (select * from query_2415558) b ON a.address = b.address
    LEFT JOIN ethereum.contracts c ON a.address = c.address 


)

, steth_table AS (
    SELECT 
       distinct tr.address,
       namespace,
       sum(amount_in) / 1e18 as amount_in,
       sum(amount_out) / 1e18 as amount_out,
       sum(amount_in) / 1e18 + sum(amount_out) / 1e18 as balance 
    FROM transfers tr
    LEFT JOIN namespace n ON n.address = tr.address
    where namespace != 'depositor' --and namespace != 'gnosis_multisig' and namespace != 'gnosis_safe' and namespace != 'proxy_multisig'
        
    GROUP BY 1,2
    HAVING (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 10
    ORDER BY balance DESC

)

, wsteth_table as (
    with not_address_list AS
    (
    SELECT
        0x0000000000000000000000000000000000000000 as address
    )
    
    ,contract_address AS
    (
    SELECT
        0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0 as address
    
    ) 
    
    ,transfers AS 
    (
    SELECT
        DATE_TRUNC('day', evt_block_time) AS time,
        evt_tx_hash AS tx_hash,
        tr."from" AS address,
        0 AS amount_in,
        -cast(tr.value as double) AS amount_out
    FROM erc20_ethereum.evt_Transfer tr
    WHERE contract_address IN (SELECT address FROM contract_address) AND "from" NOT IN (SELECT address FROM not_address_list)
    and date_trunc('day', evt_block_time) <= now() - interval '1' day
    
    UNION ALL
    
    SELECT
        DATE_TRUNC('day', evt_block_time) AS time,
        evt_tx_hash AS tx_hash,
        tr."to" AS address,
        cast(tr.value as double) AS amount_in,
        0 AS amount_out
    FROM erc20_ethereum.evt_Transfer tr 
    WHERE contract_address IN (SELECT address FROM contract_address) AND "to" NOT IN (SELECT address FROM not_address_list)
    and date_trunc('day', evt_block_time) <= now() - interval '1' day
    )
    
    
    , namespace AS (
    
        SELECT DISTINCT
            a.address
            , COALESCE(b.namespace, c.namespace) as namespace
            , COALESCE(NULLIF(c.namespace,''),'depositor')
        FROM (SELECT DISTINCT(address) AS address FROM transfers) a
        LEFT JOIN (select * from query_2415558) b ON a.address = b.address
        LEFT JOIN ethereum.contracts c ON a.address = c.address 
    
    )
    
    
SELECT 
   distinct tr.address,
   namespace,
   sum(amount_in)/1e18 as amount_in,
   sum(amount_out)/1e18 as amount_out,
   sum(amount_in)/1e18+sum(amount_out)/1e18 as balance 
FROM transfers tr
LEFT JOIN namespace n ON n.address = tr.address
where namespace != 'depositor'
GROUP BY 1,2
HAVING (sum(amount_in) / 1e18 + sum(amount_out) / 1e18) > 10
ORDER BY balance DESC

)

,wsteth_rate as
(
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
      and call_block_time <= CAST(now() as timestamp) - interval '24' hour
      and call_block_time >= CAST(now() as timestamp) - interval '48' hour
      
    UNION ALL
    SELECT
      DATE_TRUNC('day', call_block_time) AS time,
      _stETHAmount AS steth,
      output_0 AS wsteth
    FROM
      lido_ethereum.WstETH_call_wrap
    WHERE
      call_success = TRUE
      and call_block_time <= CAST(now() as timestamp) - interval '24' hour
      and call_block_time >= CAST(now() as timestamp) - interval '48' hour
  )
)

, combined AS (
    SELECT
        *
    FROM steth_table
    WHERE address <> 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0
    
    UNION ALL
    
    SELECT
        address,
        namespace,
        amount_in * (select price from wsteth_rate ) as amount_in,
        amount_out * (select price from wsteth_rate ) as amount_out,
        balance * (select price from wsteth_rate ) as balance
    FROM wsteth_table--query_1974110
)

SELECT
    address
    ,namespace
    --,SUM(amount_in) AS amount_in
    --,SUM(amount_out) AS amount_out
    ,SUM(amount_in) + SUM(amount_out) AS balance
FROM combined where address not in (0x1982b2f5814301d4e9a8b0201555376e62f82428, 0xdc24316b9ae028f1497c275eb9192a3ea0f67022)
GROUP BY 1, 2

union all
SELECT
0x1982b2f5814301d4e9a8b0201555376e62f82428 as address,
'aave_v2' as namespace,
"cumulative balance, stETH" as balance
from query_459431
where day = (select max(day) - interval '1' day from query_459431)
--date_trunc('day', now() - interval '1' day)

union all
SELECT
0xdc24316b9ae028f1497c275eb9192a3ea0f67022 as address,
'curve' as namespace,
steth_pool as balance
from query_374112
where time = (select max(time) - interval '1' day from query_374112)
--date_trunc('day', now() - interval '1' day)


ORDER BY balance DESC