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
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    $path = $ARGS[0] + "\new_releases.txt"

    $data = Invoke-WebRequest https://rateyourmusic.com/new-music/

    $all = $data.Links | select class, innerText | where {($_.class -like "album newreleases_item_title" -or $_.class -like "artist")} 

    if($all.Count -eq 0)
    {
        write-host "Error occured"
        exit
    }

    $i = 0
    $album = 0
    while($album -ne 25)
    {
        if($all[$i].class -eq "album newreleases_item_title")
        {
            $album++
        }
        $i++
    }

    $extracted =  $all | Select-Object -First ($i-1)
    $str=[system.String]::Join(" ", $extracted)

    if(Test-Path $path -PathType Leaf) 
    {
    
        $fromFile = Get-Content -Path $path

        if($str -ne $fromFile)
        {
            [System.Windows.Forms.Messagebox]::Show(
            "Check out updates on Recommended New Releases",
            "Rate Your Music",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Asterisk
            )

            Write-Host "`nRECOMMENDED NEW RELEASES"
            foreach($element in $extracted)
            {
                if($element.class -eq "album newreleases_item_title")
                {
                    Write-Host "----------------------------------------------------------"
                    write-host $element.innerText -ForegroundColor Yellow
                }
                else
                {
                    write-host $element.innerText  
                }
            }

            Start-Sleep -s 10
        }
        else
        {
            Write-Host "`nUpdated`n"
            Start-Sleep -s 2
        }
    
    }

    $str | Out-File $path
 }