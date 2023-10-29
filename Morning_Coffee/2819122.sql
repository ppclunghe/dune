--Name: (w)stETH locked 1d change by protocols
--Description: shows only protocols where delta >= 5% total (w)stETH locked in this protocol and delta >= 5k stETH
--Parameters: []
/* 
This query calculates the change of (w)stETH amount locked by protocols with 1d frequency
where delta >= 5% total (w)stETH locked in this protocol and delta >= 5k stETH 
 */
-- This CTE combines the current and 1-day ago stETH balances locked by protocols 
with
  balances AS (
    SELECT
      address,
      namespace,
      balance AS current_balance,
      0 AS d1_ago_balance
    FROM
      query_54574 --stETH locked by protocol
    UNION all
    SELECT
      address,
      namespace,
      0,
      balance
    FROM
      query_54908 --stETH locked by protocol 1d ago
  )
  -- final select calculates changes in stETH balances between current and 1 day ago for each protocol  
SELECT
  address,
  namespace,
  SUM(current_balance) AS current_balance,
  SUM(d1_ago_balance) AS d1_ago_balance,
  SUM(current_balance) - SUM(d1_ago_balance) AS change,
  100 * (SUM(current_balance) - SUM(d1_ago_balance)) / SUM(d1_ago_balance) AS change_prc
FROM
  balances
WHERE
  namespace NOT in (
    'gnosis_safe',
    'proxy_multisig',
    'argent',
    'lido:withdrawal_queue'
  )
GROUP BY
  1,
  2
HAVING
  (
    abs(SUM(current_balance) - SUM(d1_ago_balance)) >= 5000
    AND abs(
      (SUM(current_balance) - SUM(d1_ago_balance)) / SUM(d1_ago_balance)
    ) >= 0.05
  )