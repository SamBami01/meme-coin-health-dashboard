with wallets as (
    select
        DATE_TRUNC('day', evt_block_time) as day
        , contract_address
        , "from" as wallet
        from erc20_ethereum.evt_transfer
        where CAST(contract_address as VARCHAR) in (
                select
                    *
                from unnest (split('{{token_list}}', ',')) as token_address)
        union
        select
    DATE_TRUNC('day', evt_block_time)
    , contract_address
    , "to"
        from erc20_ethereum.evt_transfer
        where CAST(contract_address as VARCHAR) in (
                select
                    *
                from unnest (split('{{token_list}}', ',')) as token_address))
        , traders as (
        select
        day
        , contract_address
        , COUNT(distinct wallet) as unique_traders
        from wallets
        group by
    1
    , 2)
select
    *
from traders
order by
    day desc
