cls
$dir_actual = (pwd).ToString()
$hostname = hostname
$ip = Test-Connection -ComputerName(hostname) -Count 1 | Select-Object ipv4address
$ip_address = $ip.IPV4Address.ToString()
$date_actual = Get-Date -Format "yyyy_MM_dd"
$log = $dir_actual + "\tekium_pan_hunter_$date_actual.log"
$path_search = 'C:\'
$filters = '*.txt', '*.csv', '*.doc', '*.docx', '*.xls', '*.xlsx', '*.log'
$regex_amex = '([^0-9-]|^)(3(4[0-9]{2}|7[0-9]{2})( |-|)[0-9]{6}( |-|)[0-9]{5})([^0-9-]|$)'
$regex_visa = '([^0-9-]|^)(4[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)'
$regex_master = '([^0-9-]|^)(5[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)'
Write-Host "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
write-host "Copyright©Tekium 2023. All rights reserved." -ForegroundColor green
write-host "Author: Erick Roberto Rodriguez Rodriguez" -ForegroundColor green
write-host "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" -ForegroundColor green
write-host "Tekium PAN Hunter Script v1.0" -ForegroundColor green
Write-Host "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "Hostname: $hostname"
Write-Host ""
Write-Host "IP Address: $ip_address"
Write-Host ""
$pans = Get-ChildItem -Path $path_search -Recurse -include $filters | Select-String -Pattern $regex_amex, $regex_visa, $regex_master -AllMatches | Select-Object Filename, Line
if ( $pans )
{
    Write-Host "PAN's found" -ForegroundColor green
    "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
    "Copyright©Tekium 2023. All rights reserved." | Out-File -FilePath $log -Append 
    "Author: Erick Roberto Rodriguez Rodriguez" | Out-File -FilePath $log -Append
    "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" | Out-File -FilePath $log -Append
    "Tekium PAN Hunter Script v1.0" | Out-File -FilePath $log -Append
    "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
    "Hostname: $hostname" | Out-File -FilePath $log -Append
    "IP Address: $ip_address" | Out-File -FilePath $log -Append
    "Path: $path_search" | Out-File -FilePath $log -Append
    $prueba | Out-File -FilePath $log -Append
}
else{
    Write-Host "No PAN's found" -ForegroundColor Red
}