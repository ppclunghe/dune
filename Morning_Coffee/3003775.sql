--Name: wstETH:stETH rate
--Description: 
--Parameters: []
/* This query returns current wstETH:stETH rate*/

select time, sum(steth)/sum(wsteth) AS rate
from 
    (
    select date_trunc('day', call_block_time) as time, COALESCE(CAST("output_0" as DOUBLE),0) as steth, COALESCE(CAST("_wstETHAmount" as double),0) as wsteth 
    from lido_ethereum.WstETH_call_unwrap where call_success = TRUE
    
    union all
    select date_trunc('day', call_block_time) as time, COALESCE(CAST("_stETHAmount" as double),0) as steth, COALESCE(CAST("output_0" as DOUBLE),0) as wsteth 
    from lido_ethereum.WstETH_call_wrap where "call_success" = TRUE 
    )
group by 1
order by 1 desc
limit 1