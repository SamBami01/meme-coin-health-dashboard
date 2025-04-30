WITH daily_prices AS (
  SELECT
    p.contract_address AS token_address,
    DATE_TRUNC('day', p.minute) AS day,
    AVG(p.price) AS avg_price
  FROM prices.usd AS p
  WHERE p.contract_address IN (
    0x6982508145454ce325ddbe47a25d4ec3d2311933, -- PEPE
    0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce  -- SHIB
  )
  GROUP BY 1, 2
),
log_returns AS (
  SELECT
    token_address,
    day,
    LN(avg_price / LAG(avg_price) OVER (PARTITION BY token_address ORDER BY day)) AS log_return
  FROM daily_prices
)
SELECT
  token_address,
  day,
  STDDEV_SAMP(log_return)
    OVER (
      PARTITION BY token_address
      ORDER BY day
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS vol_7d
FROM log_returns
ORDER BY day desc
