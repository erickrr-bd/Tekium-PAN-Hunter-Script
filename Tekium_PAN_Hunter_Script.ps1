Param([string] $path_search = "C:\", [string[]] $filters = @('*.txt','*.csv','*.log'))
Clear-Host

function LuhnValidation {
    param (
        [Parameter(Mandatory=$True)]
        [string]$Number
    )
    
    $temp = $Number.ToCharArray();
    $numbers = @(0) * $Number.Length;
    $alt = $false;

    for($i = $temp.Length -1; $i -ge 0; $i--) {
       $numbers[$i] = [int]::Parse($temp[$i])
       if($alt){
           $numbers[$i] *= 2
           if($numbers[$i] -gt 9) { 
               $numbers[$i] -= 9 
           }
       }
       $sum += $numbers[$i]
       $alt = !$alt
    }
    return ($sum % 10) -eq 0
}

$i = $null
$names_files = $null
$hostname = hostname
$files_no_pans = $null
$dir_actual = (Get-Location).ToString()
$date_actual = Get-Date -Format "yyyy_MM_dd"
$log = $dir_actual + "\tekium_pan_hunter_$date_actual.log"
$amex_regex_without_spaces ='3\d{3}\d{4}\d{4}\d{4}'
$visa_regex_without_spaces ='4\d{3}\d{4}\d{4}\d{4}'
$master_regex_without_spaces ='5\d{3}\d{4}\d{4}\d{4}'
$amex_regex_dash = '3\d{3}-\d{4}-\d{4}-\d{4}'
$visa_regex_dash = '4\d{3}-\d{4}-\d{4}-\d{4}'
$master_regex_dash = '5\d{3}-\d{4}-\d{4}-\d{4}'
$amex_regex_with_spaces = '3\d{3}\s\d{4}\s\d{4}\s\d{4}'
$visa_regex_with_spaces = '4\d{3}\s\d{4}\s\d{4}\s\d{4}'
$master_regex_with_spaces = '5\d{3}\s\d{4}\s\d{4}\s\d{4}'
Write-Host -Object "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host -Object "Copyright©Tekium 2023. All rights reserved." -ForegroundColor green
Write-Host -Object "Author: Erick Roberto Rodriguez Rodriguez" -ForegroundColor green
Write-Host -Object "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" -ForegroundColor green
Write-Host -Object "GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script" -ForegroundColor green
Write-Host -Object "Tekium PAN Hunter Script for Windows v1.1.3 - October 2023" -ForegroundColor green
Write-Host -Object "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Output -InputObject "Hostname: $hostname`n"
Write-Output -InputObject "Path: $path_search`n"
Write-Output -InputObject "Filters: $filters`n"
Write-Output -InputObject "Searching for files with the filters set (this may take several minutes)`n"
$files_count = (Get-ChildItem -Path $path_search -Recurse -include $filters -ErrorAction SilentlyContinue | Measure-Object).Count -as [int]
if ($files_count -gt 0) {
    Write-Host -Object "$files_count files found`n" -ForegroundColor green
    Write-Output -InputObject "Searching for possible PANs in the found files (this may take several minutes)`n"
    $names_files = Get-ChildItem -Path $path_search -Recurse -include $filters -ErrorAction SilentlyContinue
    $names_files | ForEach-Object -Begin{
        $i = 0
        $files_no_pans = 0
        "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
        "Copyright©Tekium 2023. All rights reserved." | Out-File -FilePath $log -Append 
        "Author: Erick Roberto Rodriguez Rodriguez" | Out-File -FilePath $log -Append
        "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" | Out-File -FilePath $log -Append
        "GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script" | Out-File -FilePath $log -Append
        "Tekium PAN Hunter Script v1.1.3 for Windows - October 2023" | Out-File -FilePath $log -Append
        "-------------------------------------------------------------------------------------" | Out-File -FilePath $log -Append
        "Hostname: $hostname" | Out-File -FilePath $log -Append
        "Path: $path_search" | Out-File -FilePath $log -Append
        "Filters: $filters`n" | Out-File -FilePath $log -Append
    } -Process{
        $pans = Select-String -Path $_.FullName -Pattern $amex_regex_without_spaces, $visa_regex_without_spaces, $master_regex_without_spaces, $amex_regex_dash, $visa_regex_dash, $master_regex_dash, $amex_regex_with_spaces, $visa_regex_with_spaces, $master_regex_with_spaces -AllMatches -ErrorAction SilentlyContinue | Select-Object -First 5
        if ( $pans ){
            $cont = 0
            ForEach($pan in $pans.Matches){
                if($pan -match $amex_regex_without_spaces -Or $pan -match $visa_regex_without_spaces -Or $pan -match $master_regex_without_spaces){
                    if(LuhnValidation -Number $pan){
                        if ($pan -match $amex_regex_without_spaces) {
                            $begin = $pan.ToString().Substring(0,12) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest AMEX"
                            "$begin$rest AMEX" | Out-File -FilePath $log -Append
                        }
                        if ($pan -match $visa_regex_without_spaces) {
                            $begin = $pan.ToString().Substring(0,12) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest VISA"
                            "$begin$rest VISA" | Out-File -FilePath $log -Append
                        }
                        if ($pan -match $master_regex_without_spaces) {
                            $begin = $pan.ToString().Substring(0,12) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest MASTER CARD"
                            "$begin$rest MASTER CARD" | Out-File -FilePath $log -Append
                        }
                        $cont = $cont + 1
                    }
                }
                elseif($pan -match $amex_regex_dash -Or $pan -match $visa_regex_dash -Or $pan -match $master_regex_dash){
                    if(LuhnValidation -Number $pan.ToString().replace('-','')){
                        if ($pan -match $amex_regex_dash) {
                            $begin = $pan.ToString().Substring(0,15) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest AMEX"
                            "$begin$rest AMEX" | Out-File -FilePath $log -Append
                        }
                        if ($pan -match $visa_regex_dash) {
                            $begin = $pan.ToString().Substring(0,15) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest VISA"
                            "$begin$rest VISA" | Out-File -FilePath $log -Append
                        }
                        if ($pan -match $master_regex_dash) {
                            $begin = $pan.ToString().Substring(0,15) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest MASTER CARD"
                            "$begin$rest MASTER CARD" | Out-File -FilePath $log -Append
                        }
                        $cont = $cont + 1
                    }
                }
                elseif($pan -match $amex_regex_with_spaces -Or $pan -match $visa_regex_with_spaces -Or $pan -match $master_regex_with_spaces){
                    if(LuhnValidation -Number $pan.ToString().replace(' ','')){
                        if ($pan -match $amex_regex_with_spaces) {
                            $begin = $pan.ToString().Substring(0,15) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest AMEX"
                            "$begin$rest AMEX" | Out-File -FilePath $log -Append
                        }
                        if ($pan -match $visa_regex_with_spaces) {
                            $begin = $pan.ToString().Substring(0,15) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest VISA"
                            "$begin$rest VISA" | Out-File -FilePath $log -Append
                        }
                        if ($pan -match $master_regex_with_spaces) {
                            $begin = $pan.ToString().Substring(0,15) -replace '[0-9]','X'
                            $rest = $pan.ToString().Substring($pan.length -4) 
                            Write-Output -InputObject "$begin$rest MASTER CARD"
                            "$begin$rest MASTER CARD" | Out-File -FilePath $log -Append
                        }
                        $cont = $cont + 1
                    }
                }
            }
            if($cont -gt 0){
                Write-Host -Object "`nPossible PAN's found in: $_.FullName`n" -ForegroundColor Green
                "`nPossible PAN's found in: $_.FullName`n" | Out-File -FilePath $log -Append
            }
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