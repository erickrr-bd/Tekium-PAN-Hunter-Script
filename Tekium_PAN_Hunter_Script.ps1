Param([string] $path_search = "C:\", [string[]] $filters = @('*.txt','*.csv','*.log'))
Clear-Host
$i = $null
$names_files = $null
$hostname = hostname
$files_no_pans = $null
$dir_actual = (Get-Location).ToString()
$date_actual = Get-Date -Format "yyyy_MM_dd"
$log = $dir_actual + "\tekium_pan_hunter_$date_actual.log"
$regex_amex = '([^0-9-]|^)(3(4[0-9]{2}|7[0-9]{2})( |-|)[0-9]{6}( |-|)[0-9]{5})([^0-9-]|$)'
$regex_visa = '([^0-9-]|^)(4[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)'
$regex_master = '([^0-9-]|^)(5[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)'
Write-Host -Object "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host -Object "Copyright©Tekium 2023. All rights reserved." -ForegroundColor green
Write-Host -Object "Author: Erick Roberto Rodriguez Rodriguez" -ForegroundColor green
Write-Host -Object "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" -ForegroundColor green
Write-Host -Object "GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script" -ForegroundColor green
Write-Host -Object "Tekium PAN Hunter Script for Windows v1.1.2 - June 2023" -ForegroundColor green
Write-Host -Object "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host -Object "Hostname: $hostname`n"
Write-Host -Object "Path: $path_search`n"
Write-Host -Object "Filters: $filters`n"
Write-Host -Object "Searching for files with the filters set (this may take several minutes)`n"
$files_count = (Get-ChildItem -Path $path_search -Recurse -include $filters -ErrorAction SilentlyContinue | Measure-Object).Count -as [int]
if ($files_count -gt 0) {
    Write-Host -Object "$files_count files found`n" -ForegroundColor green
    Write-Host -Object "Searching for possible PANs in the found files (this may take several minutes)`n"
    $names_files = Get-ChildItem -Path $path_search -Recurse -include $filters -ErrorAction SilentlyContinue
    $names_files | ForEach-Object -Begin{
        $i = 0
        $files_no_pans = 0
        "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
        "Copyright©Tekium 2023. All rights reserved." | Out-File -FilePath $log -Append 
        "Author: Erick Roberto Rodriguez Rodriguez" | Out-File -FilePath $log -Append
        "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" | Out-File -FilePath $log -Append
        "GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script" | Out-File -FilePath $log -Append
        "Tekium PAN Hunter Script v1.1.2 for Windows - June 2023" | Out-File -FilePath $log -Append
        "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
        "Hostname: $hostname" | Out-File -FilePath $log -Append
        "Path: $path_search" | Out-File -FilePath $log -Append
        "Filters: $filters`n" | Out-File -FilePath $log -Append
    } -Process{
        $pans = Select-String -Path $_.FullName -Pattern $regex_amex, $regex_visa, $regex_master -AllMatches -ErrorAction SilentlyContinue | Select-Object -First 5
        if ( $pans ){
            ForEach($pan in $pans.Matches){
                $begin = $pan.ToString().Substring(0,13) -replace '[0-9]','X'
                $rest = $pan.ToString().Substring($pan.length -5) 
                if ($pan -match $regex_amex) {
                    Write-Host "$begin$rest AMEX"
                    "$begin$rest AMEX" | Out-File -FilePath $log -Append
                }
                if ($pan -match $regex_visa) {
                    Write-Host "$begin$rest VISA"
                    "$begin$rest VISA" | Out-File -FilePath $log -Append
                }
                if ($pan -match $regex_master) {
                    Write-Host "$begin$rest MASTER CARD"
                    "$begin$rest MASTER CARD" | Out-File -FilePath $log -Append
                }
            }
            Write-Host -Object "`nPossible PAN's found in: $_.FullName`n" -ForegroundColor Green
            "`nPossible PAN's found in: $_.FullName`n" | Out-File -FilePath $log -Append
        }
        else{
            $files_no_pans = $files_no_pans + 1
        }
        $i = $i+1
        $Completed = ($i/$names_files.count) * 100
        Write-Progress -Activity "Searching PAN's in: $_.FullName" -Status "Progress:" -PercentComplete $Completed -ErrorAction SilentlyContinue
    } -End{
        Write-Host -Object "The search for PAN's is over`n" -ForegroundColor Green
        if ($files_no_pans -eq $names_files.count){
            Write-Host -Object "No PAN's found`n" -ForegroundColor Red
            "`nNo PAN's found" | Out-File -FilePath $log -Append
        }
    }
}
else{
    Write-Host -Object "No files found`n" -ForegroundColor Red
}