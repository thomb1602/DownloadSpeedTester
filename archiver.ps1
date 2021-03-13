$wifiFile = "C:\Users\Tom\Desktop\speedtest\public\wifi.csv"
$ethernetFile = "C:\Users\Tom\Desktop\speedtest\public\ethernet.csv"

$wifiPath = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\wifi\output_.csv"
$ethernetPath = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\ethernet\output_.csv"

$indexFile =  "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\index.txt"

Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Archiver started"
$date = Get-Date -Format "yyyy-MM-dd"

# copy wifi to archive
$newFilePath = $wifiPath.Replace('_', $date)
Copy-Item -Path $wifiFile -Destination $newFilePath 
Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Copied to $newFilePath"

# copy ethernet to archive
$newFilePath = $ethernetPath.Replace('_', $date)
Copy-Item -Path $ethernetFile -Destination $newFilePath 
Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Copied to $newFilePath"

# add filenames to index.txt
$newFileName = $newFilePath.Substring(62);
Add-Content -Path $indexFile -Value $newFileName

# empty files and re-add headers
$headerRow = Get-Content -Path $wifiFile -TotalCount 1
Clear-Content -path $wifiFile # wifi.csv
Add-Content -path $wifiFile -value $headerRow
Clear-Content -path $ethernetFile # ethernet.csv
Add-Content -path $ethernetFile -value $headerRow

Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Empied output.csv"
Read-Host -prompt "wait"