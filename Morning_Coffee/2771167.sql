--Name: Pending users withdrawals
--Description: 
--Parameters: []
with withdrawals_requested as (
select  sum(cast(amountOfStETH as double))/1e18 as amount
from lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
)

, withdrawals_finalized as (
select sum(cast(amountOfETHLocked as double))/1e18 as amount
from lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalsFinalized
)

, total_pending_withdrawals as (
select sum(amount) as amount
from (
select amount from withdrawals_requested
union all
select -amount from withdrawals_finalized
))


, withdrawals_requested_after_last_oracle as (
select  sum(cast(amountOfStETH as double))/1e18 as amount
from lido_ethereum.WithdrawalQueueERC721_evt_WithdrawalRequested
where evt_block_time >= (select  max(evt_block_time) - interval '13' minute
from lido_ethereum.steth_evt_TokenRebased)
)

select (select format('%,.0f',coalesce(amount,0)) from total_pending_withdrawals)||' ETH / '||(select format('%,.0f',coalesce(amount,0)) from withdrawals_requested_after_last_oracle)||' ETH' as txt,
        (select coalesce(amount,0) from total_pending_withdrawals) as total_pending_withdrawals,
        (select coalesce(amount,0) from withdrawals_requested_after_last_oracle) as pending_older_last_oracle
