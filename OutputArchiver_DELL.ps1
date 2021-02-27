$resultsFile = "C:\Users\Tom\Desktop\speedtest\public\output.csv"
$archivePath = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\output_.csv"
$indexFile = "C:\Users\Tom\Desktop\speedtest\public\ResultsArchive\index.txt";

Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Archiver started"
# copy output to archive
$date = Get-Date -Format "yyyy-MM-ddTHHmmss"
$newFilePath = $archivePath.Replace('_', $date)
Copy-Item -Path $resultsFile -Destination $newFilePath 
Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Copied to $newFilePath"

# add filename to index.txt
$newFileName = $newFilePath.Substring(53);
Add-Content -Path $indexFile -Value $newFileName

# empty file and re-add header
$headerRow = Get-Content -Path $resultsFile -TotalCount 1

Clear-Content -Path $resultsFile
Add-Content -Path $resultsFile -Value $headerRow

Write-EventLog -LogName Application -Source "SpeedtestArchiver" -EntryType Information -EventId 2 -Message "Empied output.csv"