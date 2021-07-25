Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Speedtest starting"
$ethernetResultsFile = "C:\Users\Tom\Desktop\speedtest\public\ethernet.csv"
$wifiResultsFile = "C:\Users\Tom\Desktop\speedtest\public\wifi.csv"
$ethernetName = "Ethernet";
$wifiName = "Wifi 2";

function Get-SpeedtestResult
{
	param (
		[bool]$wifi
	)

	# set up variables
	$adapterName = $ethernetName
	$resultsPath = $ethernetResultsFile
	if($wifi)
	{
		$adapterName = $wifiName
		$resultsPath = $wifiResultsFile

		Disable-NetAdapter -Name $ethernetName  -Confirm:$false
	}
	else 
	{
		Disable-NetAdapter -Name $wifiName  -Confirm:$false
	}
	Enable-NetAdapter -Name $adapterName -Confirm:$false

	while((Get-NetAdapter -Name $adapterName).Status -ne "Up") { Start-Sleep -s 1 }

	# do test
	try {
		# human readable format is harder to parse but has more useful information than csv
		$rawResult = speedtest.exe -f human-readable
		Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "$adapterName speedtest complete"
	}
	catch {
		Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error performing $adapterName speed test: $_"
	}

	# extract results to string
	$speedInMbPattern = '[0-9]*[0-9]\.[0-9][0-9]'
	$download = 0;
	$upload = 0
	$date = Get-Date
	$dateWithQuotes = "$date"
	if($rawResult[7] -match $speedInMbPattern) { $download = $Matches[0] }
	if($rawResult[9] -match $speedInMbPattern) { $upload = $Matches[0] }
	$result = "`"$dateWithQuotes`",`"$download`",`"$upload`""

	# write to ethernet.csv
	try {
		Add-Content -Path $resultsPath -Value $result
		Write-EventLog -LogName Application -Source "Speedtest" -EntryType Information -EventId 2 -Message "Wrote speedtest to local file $resultsPath"
	}
	catch {
		Write-EventLog -LogName Application -Source "Speedtest" -EntryType Error -EventId 2 -Message "Error writing to local file: $_"
	}
}

Get-SpeedtestResult -wifi $True