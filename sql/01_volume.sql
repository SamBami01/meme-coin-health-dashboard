WITH token_filter AS (
  SELECT LOWER(token_address) AS token_address
  FROM UNNEST(SPLIT('{{token_list}}', ',')) AS t(token_address)
),

filtered_transfers AS (
  SELECT *
  FROM erc20_ethereum.evt_transfer
  WHERE LOWER(CAST(contract_address AS VARCHAR)) IN (SELECT token_address FROM token_filter)
    AND evt_block_time >= NOW() - INTERVAL '30' DAY
),

transfers AS (
  SELECT
    DATE_TRUNC('day', t.evt_block_time) AS day,
    t.contract_address,
    SUM((t.value / POWER(10, COALESCE(m.decimals, 18))) * p.price) AS volume_usd
  FROM filtered_transfers t
  LEFT JOIN tokens.erc20 AS m ON t.contract_address = m.contract_address
  INNER JOIN prices.usd AS p 
    ON t.contract_address = p.contract_address
    AND DATE_TRUNC('day', p.minute) = DATE_TRUNC('day', t.evt_block_time)
  GROUP BY 1, 2
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
