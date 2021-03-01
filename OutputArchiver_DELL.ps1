Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"

$localResultsFile = "C:\Users\Tom\Desktop\speedtest\public\output.csv"

# do test
try {
    # human readable format is harder to parse but has more useful information than csv
    $rawResult = speedtest.exe -f human-readable
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing speed test: $_"
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
    Add-Content -Path $localResultsFile -Value $result
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Wrote to local file $localResultsFile"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to local file: $_"
}


Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest complete $datedResult"