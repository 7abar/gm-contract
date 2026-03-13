# gm-contract ☀️

> gm is the most important primitive in Web3. Now it's onchain. Forever.

A simple, immutable smart contract on Base. Say **gm** once per day, build streaks, compete on the global leaderboard. No owner. No admin. No upgrades. Just gm.

## The Rules

1. Say gm.
2. Say gm tomorrow.
3. Don't break the streak.
4. There are no other rules.

## What It Does

- ☀️ **Say gm** — once per day, per address
- 🔥 **Build streaks** — consecutive daily gms grow your streak
- 💀 **Streak breaks** — miss a day, start from 1
- 🏆 **Global leaderboard** — top gm'ers ranked by total count
- 📊 **Stats** — track longest streak, first gm, total gms
- 🚫 **No owner** — fully immutable, nobody can take it away

## Contract Interaction

### Say gm
```bash
cast send CONTRACT "gm()" --rpc-url https://mainnet.base.org --private-key $PK
```

### Check your stats
```bash
cast call CONTRACT "records(address)" $ADDRESS --rpc-url https://mainnet.base.org
```

### View leaderboard (top 10)
```bash
cast call CONTRACT "getLeaderboard(uint256)" 10 --rpc-url https://mainnet.base.org
```

### Check if you've gm'd today
```bash
cast call CONTRACT "gmddToday(address)" $ADDRESS --rpc-url https://mainnet.base.org
```

## Deploy Your Own

```bash
curl -L https://foundry.paradigm.xyz | bash && foundryup
forge install foundry-rs/forge-std
forge test -v
forge script script/Deploy.s.sol --rpc-url https://mainnet.base.org --private-key $PK --broadcast --verify --etherscan-api-key $BASESCAN_KEY
```

## Philosophy

gm is more than a greeting. It's a commitment. Every day you wake up and say gm is a day you showed up. The contract doesn't care about your portfolio. It only cares: did you gm today?

**gm. 🌅**

---

*Fully onchain. No owner. No admin. Immutable vibes.*