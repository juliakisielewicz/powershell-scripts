$source = 'https://api.covid19api.com/summary' 

$data = Invoke-WebRequest $source | ConvertFrom-Json | Select Date, Countries

$startdate = $data.Date
$enddate = (Get-Date)

$delta = NEW-TIMESPAN –Start $startdate –End $enddate
$dd = $delta.Days
$hh = $delta.Hours
$mm = $delta.Minutes

if($dd -eq 0 -and $hh -ne 0)
{
    $time = Write-Output "$hh h $mm m"
}
elseif($dd -eq 0 -and $hh -eq 0)
{
    $time = Write-Output "$mm m"
}
else
{
    $time = Write-Output "$dd dni $hh h $mm m"
}

$info = $data.Countries | Select-Object -Property Country, TotalConfirmed, TotalRecovered, TotalDeaths
$info | Add-Member -MemberType NoteProperty  -Name TimeSinceLastUpdate -Value $time
$info | Format-Table Country, TotalConfirmed, TotalRecovered, TotalDeaths, TimeSinceLastUpdate -AutoSize