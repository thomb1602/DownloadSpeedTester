######### Absolute monitoring values ########## 
$maxpacketloss = 2 #how much % packetloss until we alert. 
$MinimumDownloadSpeed = 100 #What is the minimum expected download speed in Mbit/ps
$MinimumUploadSpeed = 20 #What is the minimum expected upload speed in Mbit/ps
######### End absolute monitoring values ######
 
$speedtestPath = "C:\Program Files (x86)\Ookla\speedtest.exe"
$resultsFile = "results.txt"

$PreviousResults = if (Test-Path $resultsFile) { Get-Content $resultsFile | ConvertFrom-Csv }

[string]$SpeedtestResults # can't get results into this variable
$resultsJob = Start-Job -Name "speedtestjob" -ScriptBlock { $SpeedtestResults = Start-Process -NoNewWindow -FilePath $speedtestPath -ArgumentList "--format=csv", "--output-header" }

Receive-Job -Name "speedtestjob"

$SpeedtestResults | Write-Host