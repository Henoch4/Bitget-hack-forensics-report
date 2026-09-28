$ErrorActionPreference = 'Continue'
$StateDir = 'C:\Users\Henoch\Documents\Programming Folder\Bitget-hack-forensics-report\poller-state'
$AlertFile = Join-Path $StateDir 'ALERTS.txt'
$LogFile = Join-Path $StateDir 'poller.log'
$Contact = 'okumagbeenoch4@gmail.com'
$LastFiled = Join-Path $StateDir 'last-filed.json'
$IntentFile = Join-Path $StateDir 'filing-intent.json'
$HoldingsSnap = Join-Path $StateDir 'holdings-last.json'
$ReviewedSnap = Join-Path $StateDir 'reviewed-last.json'
$BalanceSnap = Join-Path $StateDir 'balance-last.json'
$QuotaFile = Join-Path $StateDir 'filing-quota.json'
$ActivityFile = Join-Path $StateDir 'last-activity.json'
if (-not (Test-Path $StateDir)) { New-Item -ItemType Directory -Path $StateDir | Out-Null }

$ABORT = $false

function Log($m) { $ts = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'); Add-Content -Path $LogFile -Value "$ts $m" }
function Alert($m) { $ts = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'); Add-Content -Path $AlertFile -Value "$ts $m" }
function Get-Txs($w) {
  try {
    $j = (Invoke-WebRequest -Uri "https://api.xrpscan.com/api/v1/account/$w/transactions?page=1&limit=25" -TimeoutSec 25).Content | ConvertFrom-Json
    return $(if ($j.transactions) { $j.transactions } else { $j })
  } catch { return @() }
}
function Save-State($state) {
  $tmp = "$LastFiled.tmp"
  $lines = @()
  foreach ($h in $state) { $lines += ('"' + $h + '":"2026-09-27"') }
  [System.IO.File]::WriteAllText($tmp, ('{' + ($lines -join ',') + '}'))
  Move-Item -Path $tmp -Destination $LastFiled -Force
}
function Load-State {
  $state = New-Object 'System.Collections.Generic.HashSet[string]'
  if (Test-Path $LastFiled) {
    try {
      $raw = [System.IO.File]::ReadAllText($LastFiled)
      if ($raw.Length -gt 0 -and $raw[0] -eq [char]0xFEFF) { $raw = $raw.Substring(1) }
      $obj = $raw | ConvertFrom-Json
      foreach ($p in $obj.PSObject.Properties) { [void]$state.Add($p.Name) }
    } catch { $state = New-Object 'System.Collections.Generic.HashSet[string]' }
  }
  return $state
}
function Check-Reviewed($addr) {
  try {
    $j = (Invoke-WebRequest -Uri 'https://trace.bgblockchain.xyz/api/reviewed' -TimeoutSec 20).Content | ConvertFrom-Json
    $hit = $j.items | Where-Object { $_.address -eq $addr } | Select-Object -First 1
    if ($hit) { return $hit.verdict }
    return $null
  } catch { return $null }
}
function Check-RateLimit {
  $now = [DateTime]::UtcNow
  $quota = @{ minute = @(); tenmin = @(); day = @() }
  if (Test-Path $QuotaFile) {
    try { $quota = (Get-Content $QuotaFile -Raw | ConvertFrom-Json -AsHashtable) } catch { }
  }
  $quota.minute = @($quota.minute | Where-Object { [DateTime]$_ -gt $now.AddMinutes(-1) })
  $quota.tenmin = @($quota.tenmin | Where-Object { [DateTime]$_ -gt $now.AddMinutes(-10) })
  $quota.day = @($quota.day | Where-Object { [DateTime]$_ -gt $now.AddDays(-1) })
  if ($quota.minute.Count -ge 5) { return 'throttled' }
  if ($quota.tenmin.Count -ge 6) { return 'throttled' }
  if ($quota.day.Count -ge 500) { return 'throttled' }
  return 'ok'
}
function Record-Filing {
  $now = [DateTime]::UtcNow
  $quota = @{ minute = @(); tenmin = @(); day = @() }
  if (Test-Path $QuotaFile) {
    try { $quota = (Get-Content $QuotaFile -Raw | ConvertFrom-Json -AsHashtable) } catch { }
  }
  $quota.minute = @($quota.minute + $now.ToString('o'))
  $quota.tenmin = @($quota.tenmin + $now.ToString('o'))
  $quota.day = @($quota.day + $now.ToString('o'))
  $quota | ConvertTo-Json -Compress | Out-File -FilePath $QuotaFile -Encoding utf8
}
function File-Supplement($addr, $amount, $txs, $note, $priorRef) {
  $desc = "AUTO-FILED supplement - live Tag 470475839 flow. $note Full hashes verified via api.xrpscan.com."
  if ($priorRef) { $desc = "Supplement to $priorRef. $desc" }
  if ($desc.Length -gt 10000) { $desc = $desc.Substring(0, 9997) + '...' }
  $payload = @{
    contact = $Contact; alias = 'Henoch'; kind = 'funds'; dest = 'cex'
    chain = 'XRP Ledger'; address = $addr; amount = "$amount"; token = 'XRP'
    txs = ($txs -join "`n"); desc = $desc
  } | ConvertTo-Json -Compress -Depth 5
  $tmp = Join-Path $StateDir 'payload.json'
  $payload | Out-File -FilePath $tmp -Encoding utf8
  $resp = curl.exe -s -m 30 -A 'my-client/1.0' -H 'Content-Type: application/json' -X POST 'https://trace.bgblockchain.xyz/api/report' --data-binary "@$tmp"
  Log "FILED: $resp"
  if ($resp -match '"ok":true') {
    Alert "AUTO-FILED: $addr $amount XRP - $resp"
    Record-Filing
    return $true
  } elseif ($resp -match 'rate_limited') {
    Alert "RATE LIMITED: filing deferred"
    return $false
  } elseif ($resp -match '403|forbidden') {
    $script:ABORT = $true
    Alert "ABORT: 403 forbidden - auto-filing stopped"
    return $false
  } else {
    Alert "FILE FAILED: $resp"
    return $false
  }
}

$tagWallet = 'rNxp4h8apvRis6mJf9Sh8C6iRxfrDWN7AV'
$feeder = 'rNnMCi68fuqVCk9nFPjat8mnzCzQGLRzfS'
$bithumbWallet = 'rBuZfn1m4tA6znziHsRp9AyC1M3qg6rgbF'
$tiaWallet = 'celestia1p09mn4zpwy4mhl47clmxx4nd9pw83krmsx0ndv'
$btcSample = 'bc1qzacwkkldkee3cnsg3ntq9a4ppxcy8kyl8tecsw'
$ethParks = @('0xD2C2f029eFF5caCc686F24377CfdDcfc82d9F899', '0x600cfeDc6Bd65Fa79B604dC44964f419e45784b2')

$now = [DateTime]::UtcNow
Log "=== poll tick $($now.ToString('HH:mm:ss')) ==="

$state = Load-State

$feederTxs = Get-Txs $feeder
$newSends = @()
foreach ($t in $feederTxs) {
  if ($t.Destination -eq $tagWallet -and $t.DestinationTag -eq 470475839) {
    $h = $t.hash
    if (-not $state.Contains($h)) { $newSends += $t; [void]$state.Add($h) }
  }
}

if ($newSends.Count -gt 0) {
  $total = 0
  foreach ($t in $newSends) { $total += ([decimal]$t.Amount.value) / 1e6 }
  $txs = @(); foreach ($t in $newSends) { $txs += $t.hash }
  Alert "NEW TAG SENDS: $($newSends.Count) / $total XRP from feeder"
  $verdict = Check-Reviewed $tagWallet
  if ($verdict -eq 'not_attacker') {
    Alert "SKIP: $tagWallet is reviewed not_attacker - not filing"
  } else {
    $quota = Check-RateLimit
    if ($quota -eq 'throttled') {
      Alert "THROTTLED: rate limit reached - filing deferred"
    } else {
      $intent = @{ ts = $now.ToString('o'); addr = $tagWallet; amount = $total; txs = $txs; status = 'intent' }
      $intent | ConvertTo-Json -Compress -Depth 5 | Out-File -FilePath $IntentFile -Encoding utf8
      Log "intent written: $($txs.Count) hashes"
      $ok = File-Supplement $tagWallet $total $txs "$($newSends.Count) new sends at $($now.ToString('HH:mm:ss')) UTC, total $total XRP." $null
      if ($ok) {
        $intent.status = 'sent'
        $intent | ConvertTo-Json -Compress -Depth 5 | Out-File -FilePath $IntentFile -Encoding utf8
        Save-State $state
      }
    }
  }
}

$tagTxs = Get-Txs $tagWallet
$tagBalance = 0
try { $acc = (Invoke-WebRequest -Uri "https://api.xrpscan.com/api/v1/account/$tagWallet" -TimeoutSec 20).Content | ConvertFrom-Json; $tagBalance = ([decimal]$acc.xrpBalance) / 1e6 } catch {}

$tia = (Invoke-WebRequest -Uri "https://celestia-rest.publicnode.com/cosmos/bank/v1beta1/balances/$tiaWallet" -TimeoutSec 20).Content | ConvertFrom-Json
$tiaBal = ($tia.balances | Where-Object { $_.denom -eq 'utia' } | Select-Object -First 1).amount

Log "tagWallet=$tagBalance XRP feederNew=$($newSends.Count) tia=$tiaBal utia"

if ($now.Minute -eq 0 -or -not (Test-Path $HoldingsSnap)) {
  try {
    $h = (Invoke-WebRequest -Uri 'https://trace.bgblockchain.xyz/api/holdings' -TimeoutSec 40).Content | ConvertFrom-Json
    $tmp = "$HoldingsSnap.tmp"
    $h | ConvertTo-Json -Compress -Depth 6 | Out-File -FilePath $tmp -Encoding utf8
    Move-Item -Path $tmp -Destination $HoldingsSnap -Force
    Log "holdings snapshot saved"
  } catch { Log "holdings snapshot failed" }
}

if ($now.Minute -eq 0 -or -not (Test-Path $BalanceSnap)) {
  $balances = @{
    tia = $tiaBal
    btcSample = $null
    ethPark1 = $null
    ethPark2 = $null
  }
  try {
    $btc = (Invoke-WebRequest -Uri "https://blockchain.info/rawaddr/$btcSample" -TimeoutSec 20).Content | ConvertFrom-Json
    $balances.btcSample = $btc.final_balance
  } catch { }
  try {
    $p1 = (Invoke-WebRequest -Uri "https://eth.blockscout.com/api/v2/addresses/$($ethParks[0])" -TimeoutSec 15).Content | ConvertFrom-Json
    $balances.ethPark1 = $p1.coin_balance
  } catch { }
  try {
    $p2 = (Invoke-WebRequest -Uri "https://eth.blockscout.com/api/v2/addresses/$($ethParks[1])" -TimeoutSec 15).Content | ConvertFrom-Json
    $balances.ethPark2 = $p2.coin_balance
  } catch { }
  $balances | ConvertTo-Json -Compress | Out-File -FilePath $BalanceSnap -Encoding utf8
  Log "balance snapshot saved"
}

if (Test-Path $AlertFile) {
  $age = (Get-Item $AlertFile).LastWriteTime
  if ($age -lt $now.AddMinutes(-60)) { Clear-Content $AlertFile }
}
Log "tick complete"
