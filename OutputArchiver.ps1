$resultsFile = "C:\Users\Tom\Desktop\speedtest\public\output.csv"
$wifiFile = "C:\Users\Tom\Desktop\speedtest\public\wifi.csv"
$ethernetFile = "C:\Users\Tom\Desktop\speedtest\public\ethernet.csv"
$archivePath = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\output_.csv"
$wifiPath = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\wifi\output_.csv"
$ethernetPath = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\ethrnet\output_.csv"
$indexFile =  "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\index.txt"

Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Archiver started"

# copy output to archive
$date = Get-Date -Format "yyyy-MM-ddTHHmmss"
$newFilePath = $archivePath.Replace('_', $date)
Copy-Item -Path $resultsFile -Destination $newFilePath 
Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Copied to $newFilePath"

# copy wifi to archive
$date = Get-Date -Format "yyyy-MM-ddTHHmmss"
$newFilePath = $wifiPath.Replace('_', $date)
Copy-Item -Path $wifiFile -Destination $newFilePath 
Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Copied to $newFilePath"

# copy ethernet to archive
$date = Get-Date -Format "yyyy-MM-ddTHHmmss"
$newFilePath = $ethernetPath.Replace('_', $date)
Copy-Item -Path $ethernteFile -Destination $newFilePath 
Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Copied to $newFilePath"


# add filenames to index.txt
$newFileName = $newFilePath.Substring(53);
Add-Content -Path $indexFile -Value $newFileName
# TODO: add wifi and ethernet filenames to index files

# empty files and re-add headers
$headerRow = Get-Content -Path $resultsFile -TotalCount 1
Clear-Content -Path $resultsFile # output.csv
Add-Content -Path $resultsFile -Value $headerRow
Clear-Content -Path $wifiFile # wifi.csv
Add-Content -Path $wifiFile -Value $headerRow
Clear-Content -Path $ethernetFile # ethernet.csv
Add-Content -Path $ethernet -Value $headerRow

Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Empied output.csv"