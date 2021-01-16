######### Absolute monitoring values ########## 
$maxpacketloss = 2 #how much % packetloss until we alert. 
$MinimumDownloadSpeed = 100 #What is the minimum expected download speed in Mbit/ps
$MinimumUploadSpeed = 20 #What is the minimum expected upload speed in Mbit/ps
######### End absolute monitoring values ######
 
$speedtestPath = "C:\Program Files (x86)\Ookla\speedtest.exe"
$resultsFile = "results.txt"

$PreviousResults = if (Test-Path $resultsFile) { Get-Content $resultsFile| ConvertFrom-Csv }

#$SpeedtestResults = & "$($speedtestPath)\speedtest.exe" /format="csv" /output="-header"
$SpeedtestResults = Start-Process -NoNewWindow -Wait -FilePath $speedtestPath -ArgumentList "--format=csv","--output-header" 

$SpeedtestResults | Format-Table