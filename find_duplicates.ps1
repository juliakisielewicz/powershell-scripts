if($ARGS.Count -eq 0)
{
    Write-Host "No argument"
}
elseif($ARGS.Count -gt 1)
{
    Write-Host "Too many arguments"
}
elseif(-NOT(Test-Path $ARGS[0]))
{
    Write-Host "Wrong path"
}
else
{
    $path = $ARGS[0]
    $time = (Get-Date -Format G)

    if(Test-Path .\hash.json -PathType Leaf) 
    {
        $fromFile = Get-Content -Path  .\hash.json | ConvertFrom-Json

        $folder = $fromFile | ForEach-Object -MemberName $path 
        
        if($folder.Path -eq $path)
        {
            $prevTime = $folder.LastExecutionTime
            $prevTime = [Datetime]::ParseExact($prevTime, 'G', $null)
            
            $files = Get-ChildItem $path -File -Recurse -ErrorAction SilentlyContinue 
            $files = $files | Where-Object {$_.LastWriteTime -gt $prevTime} | Get-FileHash | Select-Object Path, Hash

            $folder.Duplicates += $files
            $folder.LastExecutiontime = $time

            $duplicates = $files | Group-Object -Property Hash | Where-Object Count -gt 1 | Select-Object -Expand Group 
            $duplicates

            $fromFile | ConvertTo-Json | Out-File .\hash.json
        }
        else
        {
            $files = Get-ChildItem $path -File -Recurse -ErrorAction SilentlyContinue | Get-FileHash | Select-Object Path, Hash

            $Folder = @{'Path' = $path;
                        'LastExecutionTime' = $time;
                         'Duplicates' = $files}


            $fromFile | Add-Member -Name $path -Value $Folder -MemberType NoteProperty
            
            $duplicates = $fromFile.$path.Duplicates | Group-Object -Property Hash | Where-Object Count -gt 1 | Select-Object -Expand Group 
            $duplicates
        
            $fromFile | ConvertTo-Json | Out-File .\hash.json
        }
    }
    else
    {
        $files = Get-ChildItem $path -File -Recurse -ErrorAction SilentlyContinue | Get-FileHash | Select-Object Path, Hash
        
        $object = @{$path = @{'Path' = $path;
                              'LastExecutionTime' = $time;
                              'Duplicates' = $files}}
          
        $duplicates = $files | Group-Object -Property Hash | Where-Object Count -gt 1 | Select-Object -Expand Group  
        $duplicates

        $object | ConvertTo-Json | Out-File .\hash.json
    }
}
























    <#
    #$Object = @()
    
    $duplicates = Get-ChildItem $path -File -Recurse -ErrorAction SilentlyContinue | Get-FileHash #| Select-Object | Where-Object -Property LastWriteTime -gt $prev | Get-FileHash
    #$duplicates
    $dup = $duplicates | Group-Object -Property Hash | Where-Object Count -gt 1 | Select-Object -Expand Group | Select-Object Path, Hash #| Format-List Path, Hash | Out-File .\duplicates.txt  -Append
    #$dup #| Get-Member
    #$dup
    #$Object | Add-Member -MemberType NoteProperty -Name Duplicates -Value $dup
      $dup | Add-Member -MemberType NoteProperty  -Name Folder -Value $path
  $dup | Add-Member -MemberType NoteProperty  -Name LastExecutionTime -Value $time
    $dup | ConvertTo-Json | Out-File C:\Users\kisie\Desktop\duplicates.json
    #$time | Out-File .\duplicates.txt -Append

    #$duplicates #| Get-Member 

}



<#


 $object = @{'LastExecutionTime2'=$time;
                                'Logical Name'=$logicalname;
            	                'Server Name'=$computer;
            	                'Drive'=$drive.DeviceID;
            	                'Size(GB)'=[decimal]$drive."Size(GB)";
            	                'Free Space(GB)'=[decimal]$drive."Free Space(GB)";
            	                'Free (%)'=$drive."Free (%)";
                                'IP'=$ip
                                #>#>