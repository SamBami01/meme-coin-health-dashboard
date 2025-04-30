WITH transfers AS (
  SELECT
    DATE_TRUNC('day', t.evt_block_time) AS day,
    t.contract_address,
    SUM((
      t.value / POWER(10, COALESCE(m.decimals, 18))
    ) * p.price) AS volume_usd
  FROM erc20_ethereum.evt_transfer AS t
  JOIN prices.usd AS p
    ON t.contract_address = p.contract_address
    AND DATE_TRUNC('minute', t.evt_block_time) = p.minute
  LEFT JOIN tokens.erc20 AS m
    ON t.contract_address = m.contract_address
  WHERE
    t.contract_address IN (0x6982508145454ce325ddbe47a25d4ec3d2311933 /* PEPE */, 0xfb5b838b6cfeedc2873ab27866079ac55363d37e /* FLOKI */,  0x2f2a2543b76a4166549f7aab2e75bef0aefc5b0f /* SAFE */, 0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce /* SHIB */)
  GROUP BY
    1,
    2
)
SELECT
  day,
  contract_address,
  SUM(volume_usd) AS total_volume_usd
FROM transfers
GROUP BY
  day,
  contract_address
ORDER BY
  day DESC,
  total_volume_usd DESC
