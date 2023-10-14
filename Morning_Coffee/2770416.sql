--Name: (w)stETH 7d trading volume dynamics (breakdown)
--Description: 
--Parameters: []
/* This query calculates cumulative (w)steth trading volume in USD for last 7d by protocol
*/
with dates as (
    with hour_seq as (
            SELECT (
                SEQUENCE(
                    CAST(date_trunc('day', now()) - interval '7' day AS TIMESTAMP)
                    , CAST(NOW()  as TIMESTAMP)
                    , INTERVAL '1' hour
                )
            ) AS hour
        )
    SELECT 
    hours.hour
    FROM hour_seq
    CROSS JOIN unnest(hour) as hours(hour)
 )


, trades as (
select date_trunc('hour', block_time) as time, block_date,  project, sum(amount_usd) as volume
from dex.trades
where (lower(token_sold_symbol) in ('wsteth','steth') or lower(token_bought_symbol) in ('wsteth','steth'))
   and date_trunc('day', block_date) >= date_trunc('day', now() ) - interval '7' day
   and project not in ('Bancor Network', '0x API')
group by 1,2, 3 
)


, dates_per_venue as (
select hour, project 
from dates
left join (select distinct  project from trades) on 1 = 1

)

select d.hour as time,  d.project, coalesce(volume,0) as volume, sum(coalesce(volume,0)) over (partition by d.project order by d.hour) as "cumulative volume"
from dates_per_venue  d
left join trades t on d.hour = date_trunc('hour',t.time) and d.project = t.project
order by 1
