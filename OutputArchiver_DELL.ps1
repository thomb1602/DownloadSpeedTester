Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"
$ethernetResultsFile = "C:\Users\Tom\Desktop\speedtest\public\ethernet.csv"
$wifiResultsFile = "C:\Users\Tom\Desktop\speedtest\public\wifi.csv"
$ethernetName = "Ethernet";
$wifiName = "Wifi";

# ---------------------------------------------------------------------------

# ensure ethernet
if( (Get-NetAdapter -Name $ethernetName).Status -eq "Disabled"){
    Disable-NetAdapter -Name $wifiName
    Enable-NetAdapter -Name $ethernetName
    "Ethernet enabled, Wifi disabled"
  }

# do test
try {
    # human readable format is harder to parse but has more useful information than csv
    $rawResult = speedtest.exe -f human-readable
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Ethernet speedtest complete"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing ethernet speed test: $_"
}

# extract results to string
$speedInMbPattern = '[0-9]*[0-9]\.[0-9][0-9]'
$download = 0;
$upload = 0
$date = Get-Date
$dateWithQuotes = "$date"
if($rawResult[7] -match $speedInMbPattern) { $download = $Matches[0] }
if($rawResult[9] -match $speedInMbPattern) { $upload = $Matches[0] }
$result = "`"$dateWithQuotes`",`"$download`",`"$upload`""


# write to output.csv
try {
    Add-Content -Path $ethernetResultsFile -Value $result
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Wrote speedtest to local file $ethernetResultsFile"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to local file: $_"
}

# ----------------------------------------------------------------------------------------

# ensure wifi
if( (Get-NetAdapter -Name $wifiName).Status -eq "Disabled"){
    Disable-NetAdapter -Name $ethernetName
    Enable-NetAdapter -Name $wifiName
    "Wifi enabled, Ethernet disabled"
  }

# do test
try {
    # human readable format is harder to parse but has more useful information than csv
    $rawResult = speedtest.exe -f human-readable
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "$wifiName speedtest complete"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing $wifiName speed test: $_"
}

# extract results to string
$speedInMbPattern = '[0-9]*[0-9]\.[0-9][0-9]'
$download = 0;
$upload = 0
$date = Get-Date
$dateWithQuotes = "$date"
if($rawResult[7] -match $speedInMbPattern) { $download = $Matches[0] }
if($rawResult[9] -match $speedInMbPattern) { $upload = $Matches[0] }
$result = "`"$dateWithQuotes`",`"$download`",`"$upload`""


# write to output.csv
try {
    Add-Content -Path $ethernetResultsFile -Value $result
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Wrote speedtest to local file $wifiResultsFile"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to local file: $_"
}