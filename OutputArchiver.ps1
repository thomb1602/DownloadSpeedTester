$resultsFile = "C:\Repos\Tom\DownloadSpeedTester\DownloadSpeedTester\useful_output.csv"

$archivePath = "C:\Repos\Tom\DownloadSpeedTester\DownloadSpeedTester\ResultsArchive\output_.csv"
$date = Get-Date -Format "yyyy-MM-ddTHHmmss"
$datedArchivePath = $archivePath.Replace('_', $date)

Copy-Item -Path $resultsFile -Destination $datedArchivePath 