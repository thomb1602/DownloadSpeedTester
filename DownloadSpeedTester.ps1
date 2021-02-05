# Note that SpeedTest source must have been created with new-EventLog, or logging will fail
# Note that speedtest.exe must be at the same location as this file
# Output.exe is assumed to already have header information, including date as first field

Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"

$resultsFile = "output.txt"
$result = .\speedtest.exe -f csv

$date = Get-Date
$dateWithFormat = "`"$date`","
$datedResult = -join($dateWithFormat, $result)

Add-Content -Path $resultsFile -Value $datedResult
