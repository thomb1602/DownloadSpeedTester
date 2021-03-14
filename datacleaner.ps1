# fills in rows of output csv files that have been left out
# due to power outage, laptop death, or whatever
 
$outfile = "C:\Git\source\repos\Tom\DownloadSpeedTester\ethernet.csv"
$cleanedfile = "C:\Git\source\repos\Tom\DownloadSpeedTester\ethernet_cleaned.csv"

$ouputcsv = Import-Csv -Path $outfile 
for ($i = 0; $i -le $ouputcsv.length; $i++)
{
    $time = $ouputcsv[$i].Time;
    $upload = $ouputcsv[$i].Upload;
    $download = $ouputcsv[$i].Download;

    $dateTime = [datetime]::ParseExact($ouputcsv[$i].Time, 'dd/MM/yyyy HH:mm:ss', $null)
    $nextTimeIdeal = $dateTime.AddMinutes(5);
    $nextTimeLower = $nextTimeIdeal.AddSeconds(-45);
    $nextTimeUpper = $nextTimeIdeal.AddSeconds(45);

    $actualNextTime = [datetime]::ParseExact($ouputcsv[$i + 1].Time, 'dd/MM/yyyy HH:mm:ss', $null)

    if (($nextTimeLower.TimeOfDay -lt $actualNextTime.TimeOfDay) -and ($nextTimeUpper.TimeOfDay -gt $actualNextTime.TimeOfDay))
    {
        Add-Content -Value "`"$time`",`"$upload`",`"$download`"" -Path $cleanedfile
    }
    else 
    {
        Add-Content -Value "`"$nextTimeIdeal`",`"0`",`"0`"" -Path $cleanedfile
    }
}

