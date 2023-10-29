--Name: Pending users withdrawals
--Description: 
--Parameters: []
/* 
This query calculates the total amount of pending withdrawals and the amount 
of pending withdrawals after the last oracle update
 */
-- This CTE calculate the total amount of withdrawals requested
with
  withdrawals_requested AS (
    SELECT
      SUM(cast(amountOfStETH AS DOUBLE)) / 1e18 AS amount
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
  )
  -- This CTE calculate the total amount of withdrawals that have been finalized
,
  withdrawals_finalized AS (
    SELECT
      SUM(cast(amountOfETHLocked AS DOUBLE)) / 1e18 AS amount
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized
  )
  -- This CTE calculate the total amount of pending withdrawals by subtracting finalized withdrawals from requested withdrawals
,
  total_pending_withdrawals AS (
    SELECT
      SUM(amount) AS amount
    FROM
      (
        SELECT
          amount
        FROM
          withdrawals_requested
        UNION all
        SELECT
          - amount
        FROM
          withdrawals_finalized
      )
  )
  -- This CTE calculate the total amount of withdrawals requested after the last oracle update (within the last 13 minutes)
,
  withdrawals_requested_after_last_oracle AS (
    SELECT
      SUM(cast(amountOfStETH AS DOUBLE)) / 1e18 AS amount
    FROM
      lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
    WHERE
      evt_block_time >= (
        SELECT
          MAX(evt_block_time) - interval '13' minute
        FROM
          lido_ethereum.steth_evt_TokenRebased
      )
  )
  -- Select and format the calculated values 
SELECT
  (
    SELECT
      FORMAT('%,.0f', COALESCE(amount, 0))
    FROM
      total_pending_withdrawals
  ) || ' ETH / ' || (
    SELECT
      FORMAT('%,.0f', COALESCE(amount, 0))
    FROM
      withdrawals_requested_after_last_oracle
  ) || ' ETH' AS txt,
  (
    SELECT
      COALESCE(amount, 0)
    FROM
      total_pending_withdrawals
  ) AS total_pending_withdrawals,
  (
    SELECT
      COALESCE(amount, 0)
    FROM
      withdrawals_requested_after_last_oracle
  ) AS pending_older_last_oracle