#!/bin/bash

function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
	printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

function PrintPan {
	pan=$1
	pan_type=$2
	parsing_type=$3

	if [[ $parsing_type -eq 1 ]];then
		begin=${pan:0:12}
	else 
		begin=${pan:0:15}
	fi
	begin_mask=$(echo ${begin//[0-9]/X})
	rest=${pan: -4}
	begin_mask=$(echo $begin_mask | tr '_' ' ')
	echo "$begin_mask$rest $pan_type" | tee -a $log
}

function LuhnValidation {
	pan=$1
	pan_len="${#pan}"
	sum=0
	alt=0

	for ((i = pan_len - 1; i >= 0; i--)); do
		digit="${pan:$i:1}"
		if [[ $alt -eq 1 ]]; then
			digit=$((digit*2))
			if [[ $digit -gt 9 ]]; then
				digit=$((digit-9))
			fi
		fi
		sum=$((sum+digit))
		alt=$((!alt))
	done
	if [[ $((sum%10)) -eq 0 ]]; then
		return 0
	else
		return 1
	fi
}

clear
search_path=$1
filters=$2
exclude_path=$3
j=0
current_date=`date +"%d-%m-%Y"`
log="tekium_pan_hunter_$current_date.log"
hash_file="hash.txt"
amex_regex_without_spaces='3\d{3}\d{4}\d{4}\d{4}'
visa_regex_without_spaces='4\d{3}\d{4}\d{4}\d{4}'
master_regex_without_spaces='5\d{3}\d{4}\d{4}\d{4}'
amex_regex_dash='3\d{3}-\d{4}-\d{4}-\d{4}'
visa_regex_dash='4\d{3}-\d{4}-\d{4}-\d{4}'
master_regex_dash='5\d{3}-\d{4}-\d{4}-\d{4}'
amex_regex_underscore='3\d{3}_\d{4}_\d{4}_\d{4}'
visa_regex_underscore='4\d{3}_\d{4}_\d{4}_\d{4}'
master_regex_underscore='5\d{3}_\d{4}_\d{4}_\d{4}'
amex_regex_with_spaces='3\d{3}\s\d{4}\s\d{4}\s\d{4}'
visa_regex_with_spaces='4\d{3}\s\d{4}\s\d{4}\s\d{4}'
master_regex_with_spaces='5\d{3}\s\d{4}\s\d{4}\s\d{4}'
if [[ ! $search_path ]];then
	search_path="/"
fi
if [[ ! $filters ]];then
	filters="txt,csv,log" 
fi
echo -e "\033[33m-------------------------------------------------------------------------------\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\033[32mCopyright©Tekium 2024. All rights reserved.\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\033[32mAuthor: Erick Roberto Rodriguez Rodriguez\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\033[32mEmail: erodriguez@tekium.mx, erickrr.tbd93@gmail.com\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\033[32mGitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\033[32mTekium PAN Hunter Script for Linux v1.1.4 - February 2024\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\033[33m-------------------------------------------------------------------------------\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
echo -e "\nHostname: $HOSTNAME\n" | tee -a $log
echo -e "Scan start date: $(date)\n" | tee -a $log
echo -e "Path: $search_path" | tee -a $log
echo -e "Filters: $filters" | tee -a $log
echo -e "Exclude: $exclude_path\n" | tee -a $log 
echo -e "Searching for files with the filters set (this may take several minutes):\n"

aux=$(echo "$filters" | sed -r 's/,/|/g')
ext_file_regex=".*\.($aux)$"
if [[ $exclude_path ]]; then
	exclude_paths=$(echo $exclude_path | tr "," "\n")
	exclude_paths_array=($exclude_paths)
	total_exclude_paths="${#exclude_paths_array[@]}"
	if [[ $total_exclude_paths -eq 1 ]];then
		files=$(find $search_path -path $exclude_paths -prune -o -regextype posix-egrep -iregex $ext_file_regex -type f 2>/dev/null)
	else
		exclude_path_string=' -path '
		for path in $exclude_paths
		do
			if [[ $i < $((total_exclude_paths-1)) ]];then
				exclude_path_string="$exclude_path_string $path -o -path"
			else
				exclude_path_string="$exclude_path_string $path"
			fi
			i=$((i+1))
		done
		files=$(find $search_path \( $exclude_path_string  \) -prune -o -regextype posix-egrep -iregex $ext_file_regex -type f 2>/dev/null)
	fi
else
	files=$(find $search_path -regextype posix-egrep -iregex $ext_file_regex -type f 2>/dev/null)
fi
files_array=($files)
total_files="${#files_array[@]}"
if [[ $total_files -gt 0 ]]; then
	echo -e "\033[32m$total_files files found\033[0m\n" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
	echo -e "Searching for possible PANs in the found files (this may take several minutes):"
	for file in $files
	do
		j=$((j+1))
		if [ -f "$file" ]; then
			is_pan=0
			echo -e "\nSearch in: $file\n"
    		result=$(grep -Po "$amex_regex_without_spaces|$visa_regex_without_spaces|$master_regex_without_spaces|$amex_regex_dash|$visa_regex_dash|$master_regex_dash|$amex_regex_with_spaces|$visa_regex_with_spaces|$master_regex_with_spaces" $file 2>/dev/null | tr ' ' '_')
    		if [[ $result ]];then
    			for pan in $result
    			do
					if [ $(echo $pan | grep -Po "$amex_regex_dash|$visa_regex_dash|$master_regex_dash") ]; then
						pan_original=$pan
						pan_without_spaces=$(echo ${pan//-/''})
						if LuhnValidation $pan_without_spaces;then
							is_pan=$((is_pan+1))
							if [ $(echo $pan_original | grep -Po $amex_regex_dash) ];then
								PrintPan $pan_original "AMEX" 2
							elif [ $(echo $pan_original | grep -Po $visa_regex_dash) ];then
								PrintPan $pan_original "VISA" 2
							elif [ $(echo $pan_original | grep -Po $master_regex_dash) ];then
								PrintPan $pan_original "MASTER CARD" 2
							fi
						fi
					elif [ $(echo $pan | grep -Po "$amex_regex_underscore|$visa_regex_underscore|$master_regex_underscore") ]; then
						pan_original=$pan
						pan_without_spaces=$(echo ${pan//'_'/''})
						if LuhnValidation $pan_without_spaces;then
							is_pan=$((is_pan+1))
							if [ $(echo $pan_original | grep -Po $amex_regex_underscore) ];then
								PrintPan $pan_original "AMEX" 2
							elif [ $(echo $pan_original | grep -Po $visa_regex_underscore) ];then
								PrintPan $pan_original "VISA" 2
							elif [ $(echo $pan_original | grep -Po $master_regex_underscore) ];then
								PrintPan $pan_original "MASTER CARD" 2
							fi
						fi
					else
						if LuhnValidation $pan;then
							is_pan=$((is_pan+1))
							if [ $(echo $pan | grep -Po $amex_regex_without_spaces) ];then
								PrintPan $pan "AMEX" 1
							elif [ $(echo $pan | grep -Po $visa_regex_without_spaces) ];then
								PrintPan $pan "VISA" 1
							elif [ $(echo $pan | grep -Po $master_regex_without_spaces) ];then
								PrintPan $pan "MASTER CARD" 1
							fi
						fi
					fi
    			done
    		else
    			files_no_pans=$((files_no_pans+1))
    		fi
    		if [[ $is_pan -gt 0 ]];then
    			echo -e "\n\033[32mTotal possible PAN's: $is_pan\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
    			echo -e "\033[32mPossible PANs found in: $file\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
    		fi
		else
			echo -e "\n\033[31mFile not found: $file\033[0m"
		fi
		echo '' | tee -a $log
		ProgressBar $j $total_files
	done
	if [[ $files_no_pans -eq $total_files ]];then
		echo -e "\n\n\033[31mNo PAN's found\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
	fi
	echo -e "\n\nScan end date: $(date)" | tee -a $log
	sha256sum $log > $hash_file
else
	echo -e "\033[31mNo files found\033[0m" | tee >(sed $'s/\033[[][^A-Za-z]*m//g' >> $log)
fi