# Note that SpeedTest source must have been created with new-EventLog, or logging will fail
# Note that speedtest.exe must be at the same location as this file
# Output.exe is assumed to already have header information, including date as first field

Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"

$resultsFile = "output.txt"

try {
    # this works if I run the file, but if task scheduler does it .\speedtest.exe isn't recognised
    $result = speedtest.exe -f csv
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Executable executed"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing speed test: $_"
}


$date = Get-Date
$dateWithFormat = "`"$date`","
$datedResult = -join($dateWithFormat, $result)

try {
    Add-Content -Path $resultsFile -Value $datedResult
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Wrote to file"
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to file: $_"
}

Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest complete"
