# Attacker tradecraft (Bitget, Sep 2026 — DPRK-attributed)

1. **Hit the decision layer, not the keys.** Backend data forgery drove legit signing flows (Bybit 2025 = front-end variant). Defense: independent pre-sign risk engine + circuit breaker + kill switch. No kill switch existed for ~3h.
2. **Dry-run before drain.** 0.84 ETH gas test at 18:31, main wave 18:58+. Test txs ALWAYS precede exploits — pre-exploit sweep is now intake SOP (see playbook).
3. **Speed is the weapon.** $228M/18min, $185M/1min. Pre-staged addresses + automation. First-hour response decides 90% of outcomes.
4. **Stables→native in minutes.** MetaSwap/Uniswap/1inch/Rizzolver within 10 min of receipt. Issuer-freeze window is minutes, not hours.
5. **Attackers learn from YOUR freezes.** Arbitrum→L1 dash = KelpDAO lesson applied by THEM. Expect venue-shifting after every public freeze.
6. **Deterministic peels.** 10k-ETH vaults, ~19.7k-XRP chunks, 12 BNB wallets, 388 BTC addrs. Amount-pattern = clustering fingerprint.
7. **Bridge diversity kills chokepoints.** Across/Stargate/LayerZero/THORChain/USDT0/Bridgers. No single venue to lean on.
8. **They touch CEXs.** Binance withdrawals + tag deposits = KYC surface. CEX touch = attribution gold. Always file the KYC thread, honestly framed.
9. **Probe hygiene.** 1-gwei ETH probes, 10-drop XRP tag probes with random tags. Dust is THEIR recon — and our filter list.
10. **Mixers are the endgame, not the start.** Wasabi only after chain-hopping failed to shake tracing. Pre-mix path is the fileable window.

# Our applied counter-playbook

- **Intake SOP for every new address:** (1) exact string, (2) pre-exploit back-trace (funders/test txs), (3) balance check, (4) label cross-check x2 explorers, (5) tracker membership, (6) log row. No filing before 1-5.
- **TRACE vs FREEZE gate:** freezable venue + live balance + full hashes, or it's TRACE. Overclaiming kills credibility on ALL leads.
- **Live-flow supplements:** while a flow moves, file fresh-hash supplements (V4U3→SBDZ in 8 min). Speed is OUR weapon too.
- **Holdings-diffing:** pull tracker snapshot on cadence, diff, alert. Caught 500+ addrs + our own validation overnight.
- **Evidence packs:** PNG set + hashes.txt sidecar, sized to form limits (Binance: 10 files max).
- **Narrative ≠ evidence.** Threads without hashes are intel, not filings. Corroborate labels independently.
- **Dust denylist:** maintain below. Never engage, never file.
- **Connectivity map:** maintain working/blocked host list; don't burn time on dead hosts.
- **OPSEC:** filings are public to competitors. File first, then publish. Burner wallet, connect-only, never sign on flagged domains.

# Dust denylist
- rwLCaBLPKcE55pjgmEicUYTtXHr8VawD9Z (10-XRP prober, seen Sep 27 on rBuZfn)
- 0xA6Dd99E200a977E4A4fD00Dc4BFD9efe11815545 (1-gwei poison/probe cluster)
- Gwei/sun dust, TRON sun amounts, lookalike-prefix poisoning tokens

# Connectivity (this network, last verified Sep 27)
- WORKS: trace.bgblockchain.xyz, eth.blockscout.com, api.xrpscan.com, celestia/cosmos-rest.publicnode.com, bsc-dataseed JSON-RPC, blockchain.info, webfetch/research
- BLOCKED: Etherscan/BscScan (403/retired), bsc.blockscout.com (backend 404), api.blockscout.com (402 paywall), THORChain all hosts (000), mempool.space (000), zcash explorers (404/430/520), Arkham (login wall)
