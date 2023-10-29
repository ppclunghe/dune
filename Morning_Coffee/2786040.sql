--Name: Lido BC net deposits 7d
--Description: 
--Parameters: []
/* 
This query calculates the net amount of ETH deposited by Lido to BC  within the last 7 days
*/

-- This CTE fetches a list of addresses with names from a 'query_2005642' (ETH deposits labels)
with 
    addresses_list AS (
        SELECT 
            address, name 
        FROM query_2005642 
    )

-- This CTE gets all successful ETH deposit transactions address over the past 7 days    
, alldeposits AS (
    SELECT 
        "from" AS project,
        cast(value AS DOUBLE) AS amount
    FROM  ethereum.traces t
    WHERE to = 0x00000000219ab540356cbb839cbe05303d7705fa --BC deposits
    AND date_trunc('day', block_time) >= now() - interval '7' day
    AND call_type = 'call'
    AND success = True 
)

-- This CTE categorizes the deposit amounts to BC by protocol, mapping the project names
, deposits_projects AS (
SELECT 
    coalesce(name, 'Unidentified') AS name
    , sum(amount)/1e18 AS amount
FROM  alldeposits
LEFT JOIN addresses_list q ON q.address = alldeposits.project
GROUP BY 1
)

-- This CTE fetches all withdrawals from various projects within the last 7 days
, allwithdrawals AS (
    SELECT 
        project,
        withdrawn_principal AS amount
    FROM  dune.lido.result_withdrawals_transactions_assigned_to_projects --query_1038304
    WHERE date_trunc('day', time) >= now() - interval '7' day
    AND withdrawn_principal > 0
)

-- This CTE groups withdrawal amounts by protocol 
, withdrawals_projects AS ( 
    SELECT 
        project AS name ,
        sum(amount) AS amount
    FROM allwithdrawals
    GROUP BY 1
)

-- final query combines deposit and withdrawal information
SELECT
COALESCE(d.name,w.name) AS name,
COALESCE(d.amount,0) AS eth_deposited,
COALESCE(w.amount,0) AS eth_withdrawn,
COALESCE(d.amount,0) - COALESCE(w.amount,0) AS eth_deposits_net
FROM deposits_projects d
FULL OUTER JOIN withdrawals_projects w
ON d.name = w.name
WHERE d.name = 'Lido'
ORDER BY 4 DESC