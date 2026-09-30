# Bitget Hack — On-Chain Forensic Report (Sep 24–30, 2026)

Investigator: **Henoch** (okumagbeenoch4@gmail.com). Free-tools investigation, public explorers only. No private keys touched. All filings through Bitget's trace API (`trace.bgblockchain.xyz`) — single-channel per their no-duplicate notice.

- Incident: backend signing-flow forgery Sep 24 18:31 UTC, $387.5M across 12 chains. No key leak. DPRK/Lazarus-linked (Specter/Elliptic/GoPlus).
- **15 leads filed** to Bitget (see table below). 12 clean, 3 acknowledged duplicates (fixed).
- Report: `REPORT-SUPPLEMENT.md` (all findings through Sep 30) + `EVIDENCE.md` (full tx hashes). Evidence: `evidence/` + `Bitget-Evidence-Upload/`.

## Leads filed (all verified in `/api/report/mine`)

| Ref | Chain | Target | Type | Status |
|---|---|---|---|---|
| `260928-215012-CXFB` | ETH | `0x4fEB8…88AB` | Live peel hub (777 ETH, auto-fanout) + 5 untracked hops | ✅ filed |
| `260928-213158-3GGU` | multi | 5 aliases | ZachXBT Chinese-launderer identities (Discord/TG + txs) | ✅ filed |
| `260928-080321-KJLL` | ETH | `0xbA3c…AdeC` | New untracked drainage dest (594 ETH) | ✅ filed |
| `260928-061523-4KF4` | XRP | `rNxp4h…` | Duplicate (poller bug) | ⚠️ dup |
| `260928-061344-HEME` | XRP | `rNxp4h…` | Duplicate (poller bug) | ⚠️ dup |
| `260928-053942-RPIO` | ETH | `0x4268…` | Circle CCTP/USDC freeze (~40M USDC) | ✅ filed |
| `260928-053203-CSKF` | ETH | `0xD2C2…` | Vault drainage TRACE (both 10k vaults) | ✅ filed |
| `260928-053119-UMKO` | ETH | `0xD2C2…` | Drainage (pre-fix, ~CKSF dup) | ⚠️ dup |
| `260927-180529-55YM` | XRP | `rNxp4h…` | Batched live-flow supplement (104,792 XRP) | ✅ filed |
| `260927-143757-SBDZ` | XRP | `rNxp4h…` | Live-flow supplement (65,226 XRP) | ✅ filed |
| `260927-143003-V4U3` | XRP | `rNxp4h…` | First API freeze filing (63,210 XRP) | ✅ filed |
| `260926-222530-IMTY` | ETH | `0x4885…` | QF7O reclassification (TRACE, not freeze) | ✅ filed |
| `260926-220250-OYGP` | TIA | `celest…` | SideShift freeze (39,550 TIA live) | ✅ filed |
| `260926-220130-QF7O` | ETH | `0x4885…` | Binance-funded consolidation (7 txs) | ✅ filed |
| `260926-210958-4ICW` | XRP | `rBuZfn…` | Tag 6415484 + batch (OKX per reviewed) | ✅ filed |

## Key findings

- **Dormant vaults drained Sep 27**: both 10k-ETH vaults emptied (~20k ETH total). Funds consolidated into 19 tracker addresses + fresh untracked wallets (`0xbA3c…AdeC` = 594 ETH).
- **Live XRP flow**: feeder `rNnMCi68…` → Binance `rNxp4h…` (Tag 470475839). Paused 42h, resumed Sep 29 with small dribbles (2–18k XRP, auto-skipped — CEX-verified dest).
- **Circle CCTP**: ~40M USDC approved for bridge from drained-vault consolidation. Burn confirmed on-chain.
- **Binance KYC thread**: `0x48857…` received 257 ETH + 545k USDT from Binance hot wallets 14/15/16/17/18, forwarded 457.896 ETH to attacker `0xA6dD3F…`. Emptied.
- **SideShift TIA**: 39,550.74 TIA still live at `celestia1p09…` (not in Bitget tracker).
- **Reviewed oracle**: `/api/reviewed` now items-based — 201 addresses (cex 7, vault 25, arb 16, attacker 144). Our XRP addresses CEX-verified; `rBuZfn…` corrected to OKX (was filed as Bithumb).
- **Sep 28 live peel**: vault `0x600cfeDc` re-used as hub — 4,326 ETH in from attacker dest, ~4,950 ETH peeled to 11 hops (all tracked), converging on untracked fan-out hub `0x4fEB8…88AB` (777 ETH, 11–13 ETH chunks every 12s).
- **ZachXBT thread** (Sep 28): 5 Chinese laundering aliases openly coordinating in Discord/TG; funds chain-hopping bridges → Wasabi. Identity lead filed.
- **CEX sweep Sep 29**: all 7 CEX tags checked live. Binance XRP `rNxp4h…` swept 125,904 → 304 XRP into house wallet (venue plumbing, Sep 29 21:55Z) — freeze fate is now Binance's internal decision on our 3 asks. No segregated attacker balance remains on any CEX tag (OKX/MEXC/FixedFloat/Kraken balances are commingled venue funds).
- **Hub drained**: CXFB fan-out hub `0x4fEB8…88AB` 777 → 159.5 ETH. Still untracked ~31h after filing.
- **NEAR Intents** (Sep 28, intel): $50M+ attempts blocked, $166k slipped, $503k frozen by NEAR (their freeze, not our lead — no filing).
- **Tracker growth**: BTC 946→1638, ETH 861→1366, new Hyperliquid chain (Bitget's own discovery).

## Standing rules

`../AGENTS.md` — time awareness, investigation discipline, connectivity map, dust denylist.

## Not financial/legal advice. Corrections welcome via Issues.
