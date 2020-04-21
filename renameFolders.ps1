function Merge-Folders{
    param( [string]$sourcePath, [string]$destinationPath)

    Get-ChildItem -Path ($sourcePath + "\*") -Recurse | Move-Item -Destination ($destinationPath) ##moves everything from the duplicate folder, 
    ## if something exists, it is ignored but a warning will occurr
    Remove-Item $sourcePath -Recurse -Force -Confirm:$False ##removes duplicate folders and all duplicate files that were not copied
}

$parentFolderPath = Read-Host -Prompt "Enter the full path to the directory, ex. C:\Users\AnejaOrlic\OneDrive\13-xxxx"

$changed = $true

while($changed){
    $folderList = dir $parentFolderPath -Directory | Select-Object -ExpandProperty "Name"
    $changed = $false

    Write-Host "-------------------------------NEW LOOP --------------------------------------"

    for($i = 0; $i -lt ($folderList.Length -1); $i++){ ##last one will be checked in the previous check
        $case1 = $folderList[$i].split(" ", 2)[0] ##only case nb of the first folder
        $case2 = $folderList[$i+1].split(" ", 2)[0] ##only case nb of the second folder


        if ($case1 -eq $case2){ ##case nbs match


            if( ($folderList[$i].Length -eq ($folderList[$i +1].Length-1)) -and ($folderList[$i] -eq $folderList[$i+1].substring(0, $folderList[$i+1].Length - 1)) ){
                ##length without last char matches and names without last char match
                $source = $parentFolderPath + "\" + $folderList[$i+1]
                $destination = $parentFolderPath + "\" + $folderList[$i] ##to here
                Merge-Folders $source $destination

                $changed = $true
            } else{
                $found = $false ##if a combination is found and this folder is merged
                for($j = 0; $j -lt $folderList[$i +1].Length; $j++){ ##Length == case2 because case2 is the one we are removing letters from
                    $temp = $folderList[$i +1].remove($j, 1)

                    if($folderList[$i] -eq $temp){
                        $source = $parentFolderPath + "\" + $folderList[$i+1]
                        $destination = $parentFolderPath + "\" + $folderList[$i] ##to here
                        Merge-Folders $source $destination

                        $found = $true
                    }
                }
                if($found -eq $false){
                    Write-Host "FOLDER NOT MERGED " $folderList[$i]
                }
            }
        }
    }
}

Write-Host "Folders merged."



