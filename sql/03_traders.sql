WITH unique_wallets AS (
  SELECT
    DATE_TRUNC('day', evt_block_time) AS day,
    contract_address AS token_address,
    "from" AS wallet
  FROM erc20_ethereum.evt_transfer
  WHERE contract_address IN (
    0x6982508145454ce325ddbe47a25d4ec3d2311933, -- PEPE
    0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce  -- SHIB
  )

  UNION

  SELECT
    DATE_TRUNC('day', evt_block_time) AS day,
    contract_address AS token_address,
    "to" AS wallet
  FROM erc20_ethereum.evt_transfer
  WHERE contract_address IN (
    0x6982508145454ce325ddbe47a25d4ec3d2311933,
    0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce
  )
)

SELECT
  day,
  token_address,
  COUNT(DISTINCT wallet) AS unique_traders
FROM unique_wallets
GROUP BY day, token_address
ORDER BY day DESC, token_address
