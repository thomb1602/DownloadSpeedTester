$resultsFile = "C:\Repos\Tom\DownloadSpeedTester\DownloadSpeedTester\useful_output.csv"
$archivePath = "C:\Repos\Tom\DownloadSpeedTester\DownloadSpeedTester\ResultsArchive\output_.csv"

# copy output to archive
$date = Get-Date -Format "yyyy-MM-ddTHHmmss"
$newFilePath = $archivePath.Replace('_', $date)

Copy-Item -Path $resultsFile -Destination $newFilePath 

# empty file and re-add header
$headerRow = Get-Content -Path $resultsFile -TotalCount 1

Clear-Content -Path $resultsFile
Add-Content -Path $resultsFile -Value $headerRow