with daily_prices as (
    select
        p.contract_address as token_address
        , DATE_TRUNC('day', p.minute) as day
        , AVG(p.price) as avg_price
        from prices.usd as p
        where LOWER(CAST(p.contract_address as VARCHAR)) in (
                select LOWER(token_address)
                from unnest (split('{{token_list}}', ',')) as t(token_address))
   and p.minute >= NOW() - INTERVAL '40' DAY
        group by
    1
    , 2)
    , log_returns as (
        select
        token_address
        , day
        , LN(
                avg_price / LAG(avg_price) over (
                    partition by
                        token_address
                    order by
    day)) as log_return
        from daily_prices)
        , volatility as (
        select
        token_address
        , day
        , STDDEV_SAMP(log_return) over (
                partition by
                    token_address
                order by
    day rows between 6 preceding
   and current ROW) as vol_7d
        from log_returns)
select
    *
from volatility
order by
    day desc
    , token_address
