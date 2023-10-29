--Name: Withdrawals_transactions_assigned_to_projects
--Description: 
--Parameters: []
/*
This query (materialized view "dune.lido.result_withdrawals_transactions_assigned_to_projects") retrieves 
transactions related to staking and deposits, revealing project associations, categories, liquidity, and withdrawn principal amounts
*/

-- This CTE selects public key and row number, excluding the public keys from 'query_2367381'(ETH Failed Staking Pubkeys)
with indexes AS  (
    SELECT pubkey 
    , ROW_NUMBER() OVER (ORDER BY MIN(deposit_index)) - 1 AS  validator_index
    FROM staking_ethereum.deposits
    WHERE pubkey NOT IN (SELECT pubkey FROM query_2367381)
    GROUP BY 1
    )

-- This CTE retrieves project information for depositors and their deposits 
,projects AS  (

SELECT i.validator_index,
p.name AS  project,
p.category AS  category,
p.liquidity AS  liquidity,
depositor_address, 
pubkey
FROM
    (
    SELECT i.validator_index
    , d.depositor_address
    , d.pubkey
    FROM staking_ethereum.deposits d
    INNER JOIN indexes i ON i.pubkey = d.pubkey
    WHERE d.pubkey  NOT in (SELECT pubkey FROM query_3146090)
   
    ) i

LEFT JOIN (SELECT * FROM dune.lido.result_eth_depositors_labels) p
ON i.depositor_address = p.address

UNION all

SELECT i.validator_index,
p.entity AS  project,
p.category AS  category,
p.liquidity AS  liquidity,
contract, 
p.pubkey
FROM
    (
    SELECT i.validator_index
    , d.depositor_address
    , d.pubkey
    FROM staking_ethereum.deposits d
    INNER JOIN indexes i ON i.pubkey = d.pubkey
    ) i

JOIN query_3146090 p
ON i.pubkey = p.pubkey

)

-- final select combines the data from 'projects' CTE with withdrawals table

SELECT 
block_time AS  time
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE COALESCE(p.project, 'Unidentified') END AS project
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE COALESCE(p.category, 'Unidentified') END AS category
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Individual' ELSE COALESCE(p.liquidity, 'Unidentified') END AS liquidity
,CASE WHEN amount/1e9 BETWEEN 20 AND 32 THEN CAST(w.amount AS  DOUBLE)/1e9 
WHEN amount/1e9 > 32 THEN 32 ELSE 0 
END AS withdrawn_principal
FROM ethereum.withdrawals w
LEFT JOIN projects p ON w.validator_index = p.validator_index



/* 2023-10-27
with indexes AS  (
    SELECT pubkey
    , ROW_NUMBER() OVER (ORDER BY MIN(deposit_index)) - 1 AS  validator_index
    FROM staking_ethereum.deposits
    WHERE pubkey NOT IN (SELECT pubkey FROM query_2367381)
    GROUP BY 1
    )

,projects AS  (

SELECT i.validator_index,
p.name AS  project,
p.category AS  category,
p.liquidity AS  liquidity,
depositor_address, 
pubkey
FROM
    (
    SELECT i.validator_index
    , d.depositor_address
    , d.pubkey
    FROM staking_ethereum.deposits d
    INNER JOIN indexes i ON i.pubkey = d.pubkey
    WHERE d.pubkey  NOT in (SELECT pubkey FROM query_3146090)
   
    ) i

LEFT JOIN (SELECT * FROM dune.lido.result_eth_depositors_labels) p
on i.depositor_address = p.address

UNION all

SELECT i.validator_index,
p.entity AS  project,
p.category AS  category,
p.liquidity AS  liquidity,
contract, 
p.pubkey
FROM
    (
    SELECT i.validator_index
    , d.depositor_address
    , d.pubkey
    FROM staking_ethereum.deposits d
    INNER JOIN indexes i ON i.pubkey = d.pubkey
 
    ) i

JOIN query_3146090 p
on i.pubkey = p.pubkey

)



SELECT 
block_time AS  time
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE COALESCE(p.project, 'Unidentified') END AS project
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE COALESCE(p.category, 'Unidentified') END AS category
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Individual' ELSE COALESCE(p.liquidity, 'Unidentified') END AS liquidity
,CASE WHEN amount/1e9 BETWEEN 20 AND 32 THEN CAST(w.amount AS  DOUBLE)/1e9 
WHEN amount/1e9 > 32 THEN 32 ELSE 0 
END AS withdrawn_principal
FROM ethereum.withdrawals w
LEFT JOIN projects p ON w.validator_index = p.validator_index




/* 2023-10-27
with indexes AS  (
    SELECT pubkey
    , ROW_NUMBER() OVER (ORDER BY MIN(deposit_index)) - 1 AS  validator_index
    FROM staking_ethereum.deposits
    WHERE pubkey NOT IN (SELECT pubkey FROM query_2367381)
    GROUP BY 1
    )

,projects as
(
SELECT i.validator_index,
p.name AS  project,
p.category AS  category,
p.liquidity AS  liquidity,
depositor_address
FROM
    (
    SELECT i.validator_index
    , d.depositor_address
    FROM staking_ethereum.deposits d
    INNER JOIN indexes i ON i.pubkey = d.pubkey
    --WHERE d.pubkey NOT IN (SELECT pubkey FROM query_2367381)
    ) i

LEFT JOIN (SELECT * FROM dune.lido.result_eth_depositors_labels) p
on i.depositor_address = p.address
)

SELECT 
block_time AS  time
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE COALESCE(p.project, 'Unidentified') END AS project
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Solo Staker' ELSE COALESCE(p.category, 'Unidentified') END AS category
,CASE WHEN p.depositor_address in (SELECT address FROM dune.lido.dataset_solo_test) THEN 'Individual' ELSE COALESCE(p.liquidity, 'Unidentified') END AS liquidity
--,CAST(w.amount AS  DOUBLE)/1e9 AS  full_amount, 

,CASE WHEN amount/1e9 BETWEEN 20 AND 32 THEN CAST(w.amount AS  DOUBLE)/1e9 
WHEN amount/1e9 > 32 THEN 32 ELSE 0 
END AS withdrawn_principal

--,CASE WHEN amount/1e9 < 20 THEN CAST(w.amount AS  DOUBLE)/1e9 
--WHEN amount/1e9 > 32 THEN CAST(w.amount AS  DOUBLE)/1e9 - 32 
--ELSE 0 
--END AS withdrawn_rewards
--, w.validator_index
--, w.address AS  withdrawing_address

FROM ethereum.withdrawals w
LEFT JOIN projects p ON w.validator_index = p.validator_index

*/