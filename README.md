# Bitget Hack — On-Chain Forensic Report (Sep 24–26, 2026)

Investigator: **Henoch** (okumagbeenoch4@gmail.com). Free-tools investigation, public explorers only. No private keys touched.

- Incident: backend wallet spoof Sep 24 18:31 UTC, $351.6M → $387.5M. Hot+warm drained, cold safe.
- Filed: BITGET LazarusBounty + Binance fraud portal. Status: submitted, 48h review pending, no payout claimed.
- Full writeup: Medium (link) + `Bitget-Hack-Forensic-Report-Sep2026.docx` in this repo.
- Evidence: `evidence/` (30 PNGs, numbered filing order) + `Bitget-Binance-Tag470475839-evidence.zip`.

## Key leads (full hashes in EVIDENCE.md)
- Binance Tag **470475839**: `rNnMCi68fuqVCk9nFPjat8mnzCzQGLRzfS` → `rNxp4h8apvRis6mJf9Sh8C6iRxfrDWN7AV`, 194,629 XRP in 25 sends + supplements (running ~229,962 XRP). Upstream `rU7dx...` → `rDRV...` → `rwNhef...` (Bitget consolidator).
- Swap Tag **6415484** → Bithumb DT **1082757429**: `rDWxja...` → `rBuZfn...` 14,835 XRP in 8 sends (SourceTag 1741383633 = shared wallet-service fingerprint) + 37,970 XRP batch to Bithumb `rDxfhNRg...`.
- Dormant: `r6NcwN...` 22,976,677 + `rwSjB...` 20M still zero-outbound (r3UGf/rH7oMF broke overnight - see report).
- Bridge: TRON `TTe3o6...` → UsdtOFT `TFG4...` 367,355 USDT (EID 30101) → `0x0193...` → 136 ETH to `0xDbD0...`.
- ZEC `t1WgMdt...` 18,911 transparent watch. EVM 10k parks `0xD2C2...`/`0x600c...` dormant.

Not financial/legal advice. Corrections welcome via Issues.
