# Note that SpeedTest source must have been created with new-EventLog, or logging will fail
# Note that speedtest.exe must be at the same location as this file
# Output.exe is assumed to already have header information, including date as first field

# speedtest.exe is available here: https://www.speedtest.net/apps/cli

Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"

# without the full file path the file will be saved in system32 if thi script is run by Task Scheduler
$resultsFile = "C:\Program Files (x86)\Ookla\output.txt"

try {
    $result = speedtest.exe -f csv
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing speed test: $_"
}

$date = Get-Date
$dateWithFormat = "`"$date`","
$datedResult = -join($dateWithFormat, $result)

try {
    Add-Content -Path $resultsFile -Value $datedResult
}
catch {
    Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to file: $_"
}

Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest complete"
