# meme-coin-health-dashboard
Dune Analytics project scoring meme-coin health

This project analyzes the "health" of ERC-20 tokens using on-chain data from Ethereum.  
It uses three metrics:
- 📊 **Volume** – Trading activity in USD
- 👥 **Unique Traders** – Number of distinct wallets interacting with the token
- 📉 **Volatility** – 7-day rolling standard deviation of log returns

These are normalized daily and combined into a **Health Score**
Health Score = 0.4 × Volume + 0.3 × Traders + 0.3 × (1 - Volatility)


### 🔗 Live Dashboard

View the dashboard here: [Token Health Tracker on Dune](https://dune.com/0xster01/token-health-tracker)

---

### 🧪 Data Sources
- `erc20_ethereum.evt_transfer`
- `prices.usd`
- `tokens.erc20`

---

### ⚙️ Features
- Token-level breakdown
- Health score normalization
- Optional token filters via Dune parameters



