if($ARGS.Count -lt 3)
{
    Write-Host "Add:
1. argument: the path to <monitor-new_releases.ps1> file
2. argument: username
3. argument: the path to the folder where <new_releases.txt> file should be stored"
}
elseif($ARGS.Count -gt 3)
{
    Write-Host "Too many arguments. Add:
1. argument: the path to <monitor-new_releases.ps1> file
2. argument: username
3. argument: the path to the folder where <new_releases.txt> file should be stored"
}
elseif(-NOT(Test-Path $ARGS[0]) -or -NOT(Test-Path $ARGS[2]))
{
    Write-Host "Wrong path. Add:
1. argument: the path to <monitor-new_releases.ps1> file
2. argument: username
3. argument: the path to the folder where <new_releases.txt> file should be stored"
}
else
{

    $path = $ARGS[0]
    $user = $ARGS[1]
    $arg = $ARGS[2]
    $name = hostname

    $A = New-ScheduledTaskAction -Execute "%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument "$path $arg"
    $T = New-ScheduledTaskTrigger -Once -at '18:04' -RepetitionInterval (New-TimeSpan -Minutes 1)
    $P = New-ScheduledTaskPrincipal "$name\$user"
    $S = New-ScheduledTaskSettingsSet 
    $D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
    Register-ScheduledTask -TaskName "RateYourMusic_NewReleases"  MojeZadania -InputObject $D    
}