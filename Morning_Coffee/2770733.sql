--Name: (w)stETH 7d trading volume dynamics
--Description: 
--Parameters: []
with hours as (
  with hour_seq as(
  SELECT(sequence(cast(date_trunc('hour', now() - interval '360' hour) as timestamp), cast(date_trunc('hour',now()) as timestamp), interval '1' hour)) hour 
  )
    select hours.hour
    from hour_seq
    cross join unnest(hour) as hours(hour)
)


, volumes as (
select date_trunc('hour', block_time) as time, block_date as day,  sum(amount_usd) as volume
from dex.trades
where (lower(token_sold_symbol) in ('wsteth','steth') or lower(token_bought_symbol) in ('wsteth','steth'))
   and date_trunc('day', block_date) >= date_trunc('day', now()) - interval '15' day
group by 1,2
)

, volumes_with_ma as (
select hours.hour, time, volume,
 avg(volume) over (order by time rows between 167 preceding and current row) as ma168h
from hours
left join volumes on date_trunc('hour',hours.hour) = date_trunc('hour',volumes.time)
order by time
)


select time, volume, ma168h as ma_7d
from volumes_with_ma
where time >= cast(date_trunc('hour', now()) - interval '168' hour as date)



