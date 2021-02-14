Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"

$resultsFile = "C:\Program Files (x86)\Ookla\useful_output.csv"
try {
    # human readable format is harder to parse buthas more useful information than csv
    $rawResult = speedtest.exe -f human-readable
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Executable executed"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing speed test: $_"
}

# extract results to object
$speedInMbPattern = '[0-9]*[0-9]\.[0-9][0-9]'
$download = 0;
$upload = 0
$date = Get-Date
$dateWithQuotes = "$date"
if($rawResult[7] -match $speedInMbPattern) { $download = $Matches[0] }
if($rawResult[9] -match $speedInMbPattern) { $upload = $Matches[0] }

$result = "`"$dateWithQuotes`",`"$download`",`"$upload`""

try {
    Add-Content -Path $resultsFile -Value $result
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Wrote to file"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to file: $_"
}

Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest complete $datedResult"