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
Write-Host -Object "Tekium PAN Hunter Script v1.1" -ForegroundColor green
Write-Host -Object "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host -Object "Hostname: $hostname"
Write-Host -Object ''
Write-Host -Object "Path: $path_search"
Write-Host -Object ''
Write-Host -Object "Filters: $filters"
Write-Host -Object ''
Write-Host -Object "Start the file search with the filters (it takes a few minutes)"
Write-Host -Object ''
$files_count = (Get-ChildItem -Path $path_search -Recurse -include $filters -ErrorAction SilentlyContinue | Measure-Object).Count -as [int]
if ($files_count -gt 0) {
    Write-Host -Object "$files_count files found" -ForegroundColor green
    Write-Host -Object ''
    Write-Host -Object "Start the search for PAN's in the found files (it takes a few minutes)"
    Write-Host -Object ''
    $names_files = Get-ChildItem -Path $path_search -Recurse -include $filters -ErrorAction SilentlyContinue
    $names_files | ForEach-Object -Begin{
        $i = 0
        $files_no_pans = 0
        "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
        "Copyright©Tekium 2023. All rights reserved." | Out-File -FilePath $log -Append 
        "Author: Erick Roberto Rodriguez Rodriguez" | Out-File -FilePath $log -Append
        "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" | Out-File -FilePath $log -Append
        "Tekium PAN Hunter Script v1.1" | Out-File -FilePath $log -Append
        "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
        "Hostname: $hostname" | Out-File -FilePath $log -Append
        "Path: $path_search" | Out-File -FilePath $log -Append
        "Filters: $filters" | Out-File -FilePath $log -Append
    } -Process{
        $pans = Select-String -Path $_.FullName -Pattern $regex_amex, $regex_visa, $regex_master -AllMatches -ErrorAction SilentlyContinue | Select-Object -Property Filename, Line
        if ( $pans ){
            $pans | Out-File -FilePath $log -Append
            Write-Host -Object "PAN's found in: $_.FullName" -ForegroundColor Green
            Write-Host -Object ''
            "PAN's found in: $_.FullName" | Out-File -FilePath $log -Append
            '' | Out-File -FilePath $log -Append
        }
        else{
            $files_no_pans = $files_no_pans + 1
        }
        $i = $i+1
        $Completed = ($i/$names_files.count) * 100
        Write-Progress -Activity "Searching PAN's in: $_.FullName" -Status "Progress:" -PercentComplete $Completed -ErrorAction SilentlyContinue
    } -End{
        Write-Host -Object "The search for PAN's ended" -ForegroundColor Green
        Write-Host -Object ''
        if ($files_no_pans -eq $names_files.count){
            Write-Host -Object "No PAN's found" -ForegroundColor Red
            Write-Host -Object ''
            '' | Out-File -FilePath $log -Append
            "No PAN's found" | Out-File -FilePath $log -Append
        }
    }
}
else{
    Write-Host -Object "No files found" -ForegroundColor Red
    Write-Host -Object ''
}