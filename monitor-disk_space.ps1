[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

[double]$threshold = Read-Host "`nEnter free space threshold (%): "

while(1)
{
    $disks = Get-CimInstance -classname CIM_LogicalDisk

    Write-Host "checking.."

    foreach ($disk in $disks)
    {
        if ($disk.DriveType -eq 3)
        {
            $size = $disk.Size/1GB
            $free = $disk.FreeSpace/1GB
            $percent = [math]::round($free/$size*100, 0)
            $name = $disk.Name
            
            if($percent -lt $threshold)
            {
                [System.Windows.Forms.Messagebox]::Show(
                "Free space on disk $name is below $threshold%",
                "Disk Space Alert",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
                )     
            }
            else
            {
               Write-Host "Disk $name - more than $threshold% of free space"
            }
        }
    }

    Start-Sleep -Seconds 30
}