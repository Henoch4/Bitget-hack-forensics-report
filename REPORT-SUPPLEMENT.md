# Report Supplement — Sep 27–28, 2026

This supplement updates `Bitget-Hack-Forensic-Report-Sep2026.docx` (last updated Sep 26 11:59 AM) with all findings from Sep 27–28.

## 1. Vault Drainage (Sep 27, 17:12–21:22 UTC)

Both 10k-ETH dormant vaults were drained:

| Vault | Before | After | Outbound txs |
|---|---|---|---|
| `0xD2C2f029eFF5caCc686F24377CfdDcfc82d9F899` | 10,000 ETH | 0.0000426 ETH | 32 |
| `0x600cfeDc6Bd65Fa79B604dC44964f419e45784b2` | 10,000 ETH | 9.268 ETH | 6 |

Funds consolidated into 19 addresses (all already in Bitget tracker) + fresh untracked wallets. This contradicts AMLBot's Sep 25 "dormant" assessment — the attacker is active on ETH.

## 2. New Untracked Destination (KJLL)

`0xbA3cB449bD2B4ADddBc894D8697F5170800EAdeC` received **594.46 ETH** from `0x5115C5F6Ae81872D2C208C35730D1650e8072e83` (tracker address added Sep 27 23:18 UTC). Not in Bitget's holdings API at filing time. Attacker is consolidating into fresh untracked wallets.

## 3. Circle CCTP / USDC Freeze (RPIO)

Drained-vault consolidation addresses are actively converting to USDC and bridging:

- `0x425775DDDa26eA78d0822C17ce39251d94a0a47C` → 1.47M USDC approved for CCTP bridge (depositForBurn confirmed 18:37 UTC)
- `0x8719fCbFcB3f9caEB198C8910FfEecC1e321e61C` → 39M USDC approved for CCTP bridge (depositForBurn confirmed 19:07 UTC)
- `0x426874600F34eDc1eECb63Aee383Ddc0b9A42293` → 659,827 USDC transferred to Circle (recipient `0x6889ccf8`)
- `0xa34e6599c38b131f32c84F623B77cf283c9a178F` → 649,633 USDC transferred to Circle (recipient `0xcc902b6e`)

Total Circle exposure: ~1.31M USDC transferred to issuer + ~40.5M USDC approved for CCTP bridge. Email sent to Circle compliance (compliance@circle.com) with full hashes and CCTP status.

## 4. Live XRP Flow (V4U3/SBDZ/55YM)

Feeder `rNnMCi68fuqVCk9nFPjat8mnzCzQGLRzfS` → Binance `rNxp4h8apvRis6mJf9Sh8C6iRxfrDWN7AV` (Tag 470475839):

| Batch | Sends | Total XRP | Time (UTC) |
|---|---|---|---|
| V4U3 | 6 | 63,210 | 06:30 |
| SBDZ | 8 | 65,226 | 06:37 |
| 55YM | 16 | 104,792 | 10:05 |
| **Day total** | **30** | **233,228** | |

Feeder paused since 07:32 UTC Sep 27. Upstream funders: `rpnu6d…` (20,520 XRP), `r4duMq…` (11,557 XRP), `rU7dx…` (17,766 XRP). Binance internal sweeps: 973,479 XRP + 602,874 XRP to `rDAE53…`.

## 5. Reviewed Oracle Corrections

`/api/reviewed` now live (198 addresses classified):

- `rNxp4h…` — CEX-verified (Binance) ✅
- `rNnMCi68…` (feeder) — CEX-verified ✅
- `rBuZfn…` — **corrected to OKX** (was filed as Bithumb in 4ICW) ⚠️
- `rs2dgzY…` — MEXC XRP deposit (feeder upstream)
- `bc1qns9f…` — FixedFloat BTC deposit
- 24 THORChain vault addresses (ATOM/BTC/Chainflip)
- 3 poison addresses (EVM)

## 6. QF7O Reclassification (IMTY)

`0x48857fc6B57ac0c60360568279C8Ac90a5427c8E` reclassified from "Binance CEX deposit" to "Binance-funded intermediate/consolidation wallet." Emptied (0.0009 ETH remainder). Correct handling: TRACE/attribution + upstream Binance account preservation, not a freeze claim.

## 7. Holdings Tracker Growth

| Date | ETH | BTC | XRP | Total |
|---|---|---|---|---|
| Sep 26 | 628 | 453 | 155 | ~1,236 |
| Sep 27 | 734 | 821 | 194 | ~1,749 |
| Sep 28 | 861 | 946 | 194 | ~2,001 |

+765 addresses in 48h. New chains: NOBLE (+63), ATOM (+3). All new addresses are Bitget's own discoveries — recon only, no back-filing.

## 8. Auto-Poller v2

Deployed and running. Architecture:

- Rate limiter (5/min, 6/10min, 500/day)
- Reviewed oracle (skips `not_attacker`)
- Balance watch (hourly TIA/BTC/ETH-parks)
- Holdings diff (hourly tracker snapshot)
- Adaptive cadence (quiet → slow, active → fast)
- Submission gatekeeper (dedup, retry-on-429, abort-on-403, field validation, quote-ref)
- Crash-safe state (intent-then-send, atomic writes)

## 9. Leads Summary

**13 leads filed** (10 clean, 3 acknowledged duplicates):

| Ref | Type | Status |
|---|---|---|
| KJLL | New untracked drainage dest | ✅ |
| RPIO | Circle CCTP/USDC freeze | ✅ |
| CKSF | Vault drainage TRACE | ✅ |
| 55YM | XRP live-flow supplement | ✅ |
| SBDZ | XRP live-flow supplement | ✅ |
| V4U3 | XRP first API freeze | ✅ |
| IMTY | QF7O reclassification | ✅ |
| OYGP | SideShift TIA freeze | ✅ |
| QF7O | Binance-funded consolidation | ✅ |
| 4ICW | Tag 6415484 + batch | ✅ |
| HEME | Duplicate (poller bug) | ⚠️ |
| 4KF4 | Duplicate (poller bug) | ⚠️ |
| UMKO | Drainage (pre-fix, ~CKSF dup) | ⚠️ |

## 10. What's Next

- XRP feeder still paused — auto-poller will file supplements when it resumes
- Circle email sent — awaiting response
- Binance portal supplement still pending (user action)
- DOCX regeneration pending (needs original generation script)
- Evidence PNGs for new findings pending (user doesn't have time for screenshots)
