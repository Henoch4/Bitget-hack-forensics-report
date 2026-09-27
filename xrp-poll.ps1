$ErrorActionPreference = 'Stop'
# XRP poll loop: Tag-470475839 wallet, feeder, Tag-6415484 wallet. Prints only our-tag hits + feeder->Binance outbounds.
$wallets = @(
  'rNxp4h8apvRis6mJf9Sh8C6iRxfrDWN7AV',
  'rNnMCi68fuqVCk9nFPjat8mnzCzQGLRzfS',
  'rBuZfn1m4tA6znziHsRp9AyC1M3qg6rgbF'
)
foreach ($w in $wallets) {
  Write-Output ('=== ' + $w.Substring(0, 6) + ' ===')
  try {
    $j = (Invoke-WebRequest -Uri ('https://api.xrpscan.com/api/v1/account/' + $w + '/transactions?page=1&limit=25') -TimeoutSec 25).Content | ConvertFrom-Json
    $it = if ($j.transactions) { $j.transactions } else { $j }
    foreach ($t in $it) {
      $v = ([decimal]$t.Amount.value) / 1e6
      $interesting = ($t.DestinationTag -eq 470475839) -or ($w.StartsWith('rBuZfn') -and $t.DestinationTag -eq 6415484) -or ($t.Account -eq 'rNnMCi68fuqVCk9nFPjat8mnzCzQGLRzfS' -and $t.Destination -eq 'rNxp4h8apvRis6mJf9Sh8C6iRxfrDWN7AV')
      if ($interesting) {
        '{0} | {1}->{2} | tag={3} | {4} XRP | {5}' -f $t.date, $t.Account, $t.Destination, $t.DestinationTag, $v, $t.hash
      }
    }
  } catch { 'POLL-FAIL ' + $w.Substring(0, 6) + ': ' + $_.Exception.Message }
}
