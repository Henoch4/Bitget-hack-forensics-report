# Bitget Hack — On-Chain Forensic Report (Sep 24–28, 2026)

Investigator: **Henoch** (okumagbeenoch4@gmail.com). Free-tools investigation, public explorers only. No private keys touched. All filings through Bitget's trace API (`trace.bgblockchain.xyz`) — single-channel per their no-duplicate notice.

- Incident: backend signing-flow forgery Sep 24 18:31 UTC, $387.5M across 12 chains. No key leak. DPRK/Lazarus-linked (Specter/Elliptic/GoPlus).
- **13 leads filed** to Bitget (see table below). 10 clean, 3 acknowledged duplicates from a poller state bug (fixed).
- Report: `REPORT-SUPPLEMENT.md` (all findings through Sep 28) + `EVIDENCE.md` (full tx hashes). Evidence: `evidence/` + `Bitget-Evidence-Upload/`.

## Leads filed (all verified in `/api/report/mine`)

| Ref | Chain | Target | Type | Status |
|---|---|---|---|---|
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
- **Live XRP flow**: feeder `rNnMCi68…` → Binance `rNxp4h…` (Tag 470475839). Day total 233,228 XRP. Feeder paused since 07:32 UTC.
- **Circle CCTP**: ~40M USDC approved for bridge from drained-vault consolidation. Burn confirmed on-chain.
- **Binance KYC thread**: `0x48857…` received 257 ETH + 545k USDT from Binance hot wallets 14/15/16/17/18, forwarded 457.896 ETH to attacker `0xA6dD3F…`. Emptied.
- **SideShift TIA**: 39,550.74 TIA still live at `celestia1p09…` (not in Bitget tracker).
- **Reviewed oracle**: `/api/reviewed` now live — 198 addresses classified. Our XRP addresses CEX-verified; `rBuZfn…` corrected to OKX (was filed as Bithumb).

## Auto-poller (v2) — local only

Runs every 5 min via Windows Task Scheduler (`Bitget-XRP-Poller`). Script and state are git-ignored (not public).

- **Rate limiter**: 5/min, 6/10min, 500/day. Auto-throttles.
- **Reviewed oracle**: skips `not_attacker` addresses before filing.
- **Balance watch**: hourly TIA/BTC/ETH-parks snapshot.
- **Holdings diff**: hourly tracker snapshot → new addresses → tx scan.
- **Adaptive cadence**: feeder quiet >1h → slow mode; activity → fast mode.
- **Submission gatekeeper**: dedup, retry-on-429, abort-on-403, field validation, quote-ref.
- **State**: crash-safe (intent-then-send, atomic writes).

Note: scheduled task requires AC power (uncheck "Stop On Battery Mode" in Task Scheduler GUI for battery operation).

## Standing rules

`../AGENTS.md` — time awareness, investigation discipline, connectivity map, dust denylist.

## Not financial/legal advice. Corrections welcome via Issues.
