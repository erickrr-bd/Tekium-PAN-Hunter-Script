<#
.Description
The script searches for possible PANs in text files using regular expressions.
.PARAMETER search_path
Path where the possible PAN's will be searched.
It is an optional value.
.PARAMETER filters
File extensions where possible PANs will be searched.
It is an optional value.
.PARAMETER exclude_path
Path or paths that should be excluded from the search.
It is an optional value.
.EXAMPLE
PS> .\Tekium_PAN_Hunter_Script.ps1 -search_path "C:\Users" -filters '*.log', '*.txt', '*.csv', '*.docx', '*.xlsx', '*.xls', '*.doc' -exclude_path "C:\Windows"
.SYNOPSIS
PowerShell script that searches for possible PANs on Windows systems.
#>
Param([string] $search_path = "C:\", [string[]] $filters = @('*.txt','*.csv','*.log'), [string[]] $exclude_path)
Clear-Host

function LuhnValidation {
    param (
        [Parameter(Mandatory=$True)]
        [string]$Pan
    )
    
    $temp = $Pan.ToCharArray();
    $numbers = @(0) * $Pan.Length;
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

function PrintPan{
    param (
        [Parameter(Mandatory=$True)]
        [string]$Pan,
        [Parameter(Mandatory=$True)]
        [string]$Pan_type,
        [Parameter(Mandatory=$True)]
        [int]$Parsing_type
    )
    if($Parsing_type -eq 1){
        $begin = $pan.Substring(0,12) -replace '[0-9]','X'
    }
    else{
        $begin = $pan.Substring(0,15) -replace '[0-9]','X'
    }
    $rest = $pan.Substring($pan.length -4) 
    Write-Output -InputObject "$begin$rest $Pan_type"
    "$begin$rest $Pan_type" | Out-File -Encoding utf8 -FilePath $log -Append
}

$i = $null
$names_files = $null
$files_no_pans = $null
$exclusion_string = $null
$log = "tekium_pan_hunter_$(Get-Date -Format "yyyy_MM_dd").log"
$hash_file = "hash.txt"
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
Write-Host -Object "Copyright©Tekium 2024. All rights reserved." -ForegroundColor green
Write-Host -Object "Author: Erick Roberto Rodriguez Rodriguez" -ForegroundColor green
Write-Host -Object "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" -ForegroundColor green
Write-Host -Object "GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script" -ForegroundColor green
Write-Host -Object "Tekium PAN Hunter Script for Windows v1.1.4 - February 2024" -ForegroundColor green
Write-Host -Object "-------------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Output -InputObject "Hostname: $(hostname)`n"
Write-Output -InputObject "Scan start date: $(Get-Date)`n"
Write-Output -InputObject "Path: $search_path`n"
Write-Output -InputObject "Filters: $filters`n"
Write-Output -InputObject "Exclude: $exclude_path`n"
Write-Output -InputObject "Searching for files with the filters set (this may take several minutes)`n"
if($exclude_path){
    $exclusion_string = $exclude_path -join '|'
    $exclusion_string = $exclusion_string.Replace('\','\\')
    $names_files = Get-ChildItem -Path $search_path -Recurse -include $filters -ErrorAction SilentlyContinue | Where-Object {$_.DirectoryName -notmatch $exclusion_string}
}
else{
    $names_files = Get-ChildItem -Path $search_path -Recurse -include $filters -ErrorAction SilentlyContinue
}
$total_files = $names_files.count
if ($total_files -gt 0) {
    Write-Host -Object "$total_files files found`n" -ForegroundColor green
    Write-Output -InputObject "Searching for possible PANs in the found files (this may take several minutes)`n"
    $names_files | ForEach-Object -Begin{
        $i = 0
        $files_no_pans = 0
        "-------------------------------------------------------------------------------------" | Out-File -Encoding utf8 -FilePath $log -Append
        "Copyright©Tekium 2024. All rights reserved." | Out-File -Encoding utf8 -FilePath $log -Append 
        "Author: Erick Roberto Rodriguez Rodriguez" | Out-File -Encoding utf8 -FilePath $log -Append
        "Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com" | Out-File -Encoding utf8 -FilePath $log -Append
        "GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script" | Out-File -Encoding utf8 -FilePath $log -Append
        "Tekium PAN Hunter Script v1.1.4 for Windows - February 2024" | Out-File -Encoding utf8 -FilePath $log -Append
        "-------------------------------------------------------------------------------------" | Out-File -Encoding utf8 -FilePath $log -Append
        "Hostname: $(hostname)" | Out-File -Encoding utf8 -FilePath $log -Append
        "Scan start date: $(Get-Date)" | Out-File -Encoding utf8 -FilePath $log -Append
        "Path: $search_path" | Out-File -Encoding utf8 -FilePath $log -Append
        "Filters: $filters" | Out-File -Encoding utf8 -FilePath $log -Append
        "Exclude: $exclude_path`n" | Out-File -Encoding utf8 -FilePath $log -Append
    } -Process{
        $pans = Select-String -Path $_.FullName -Pattern $amex_regex_without_spaces, $visa_regex_without_spaces, $master_regex_without_spaces, $amex_regex_dash, $visa_regex_dash, $master_regex_dash, $amex_regex_with_spaces, $visa_regex_with_spaces, $master_regex_with_spaces -AllMatches -ErrorAction SilentlyContinue 
        if ( $pans ){
            $is_pan = 0
            ForEach($pan in $pans.Matches){
                if($pan -match $amex_regex_without_spaces -Or $pan -match $visa_regex_without_spaces -Or $pan -match $master_regex_without_spaces){
                    if(LuhnValidation -Pan $pan){
                        if ($pan -match $amex_regex_without_spaces) {
                            PrintPan -Pan $pan.ToString() -Pan_type "AMEX" -Parsing_type 1
                        }
                        if ($pan -match $visa_regex_without_spaces) {
                           PrintPan -Pan $pan.ToString() -Pan_type "VISA" -Parsing_type 1
                        }
                        if ($pan -match $master_regex_without_spaces) {
                            PrintPan -Pan $pan.ToString() -Pan_type "MASTER CARD" -Parsing_type 1
                        }
                        $is_pan = $is_pan + 1
                    }
                }
                elseif($pan -match $amex_regex_dash -Or $pan -match $visa_regex_dash -Or $pan -match $master_regex_dash){
                    if(LuhnValidation -Pan $pan.ToString().replace('-','')){
                        if ($pan -match $amex_regex_dash) {
                            PrintPan -Pan $pan.ToString() -Pan_type "AMEX" -Parsing_type 2
                        }
                        if ($pan -match $visa_regex_dash) {
                            PrintPan -Pan $pan.ToString() -Pan_type "VISA" -Parsing_type 2
                        }
                        if ($pan -match $master_regex_dash) {
                            PrintPan -Pan $pan.ToString() -Pan_type "MASTER CARD" -Parsing_type 2
                        }
                        $is_pan = $is_pan + 1
                    }
                }
                elseif($pan -match $amex_regex_with_spaces -Or $pan -match $visa_regex_with_spaces -Or $pan -match $master_regex_with_spaces){
                    if(LuhnValidation -Pan $pan.ToString().replace(' ','')){
                        if ($pan -match $amex_regex_with_spaces) {
                            PrintPan -Pan $pan.ToString() -Pan_type "AMEX" -Parsing_type 2
                        }
                        if ($pan -match $visa_regex_with_spaces) {
                            PrintPan -Pan $pan.ToString() -Pan_type "VISA" -Parsing_type 2
                        }
                        if ($pan -match $master_regex_with_spaces) {
                            PrintPan -Pan $pan.ToString() -Pan_type "MASTER CARD" -Parsing_type 2
                        }
                        $is_pan = $is_pan + 1
                    }
                }
            }
            if($is_pan -gt 0){
                Write-Host -Object "`nTotal possible PAN's: $is_pan" -ForegroundColor Green
                "`nTotal possible PAN's: $is_pan" | Out-File -Encoding utf8 -FilePath $log -Append
                Write-Host -Object "`nPossible PAN's found in: $_.FullName`n`n" -ForegroundColor Green
                "`nPossible PAN's found in: $_.FullName`n`n" | Out-File -Encoding utf8 -FilePath $log -Append
            }
        }
        else{
            $files_no_pans = $files_no_pans + 1
        }
        $i = $i+1
        $Completed = ($i/$names_files.count) * 100
        Write-Progress -Activity "Searching PAN's in: $_.FullName" -Status "Progress:" -PercentComplete $Completed -ErrorAction SilentlyContinue
    } -End{
        Write-Output -InputObject "Scan end date: $(Get-Date)`n"
        "Scan end date: $(Get-Date)" | Out-File -Encoding utf8 -FilePath $log -Append
        if ($files_no_pans -eq $names_files.count){
            Write-Host -Object "No PAN's found`n" -ForegroundColor Red
            "`nNo PAN's found" | Out-File -Encoding utf8 -FilePath $log -Append
        }
        $(Get-FileHash -Path $log).Hash | Out-File -FilePath $hash_file
    }
}
else{
    Write-Host -Object "No files found`n" -ForegroundColor Red
}