--Name: Not finalized withdrawals requests
--Description: 
--Parameters: []
/* 
This query retrieves and summarizes data on pending withdrawal requests that have not been finalized.
 */
-- select the maximum waiting hours for pending withdrawals from 'query_3137746'(Not finalized withdrawals requests: time since request)
SELECT
  MAX(waiting_hours) AS waiting_hours,
  SUM(amount) AS amount
FROM
  query_3137746