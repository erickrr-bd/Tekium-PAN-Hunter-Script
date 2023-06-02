#!/bin/bash

function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done

    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
	
	printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

clear
path_search=$1
current_date=`date +"%d-%m-%Y"`
log="tekium_pan_hunter_$current_date.log"
regex_amex='([^0-9-]|^)(3(4[0-9]{2}|7[0-9]{2})( |-|)[0-9]{6}( |-|)[0-9]{5})([^0-9-]|$)'
regex_visa='([^0-9-]|^)(4[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)'
regex_master='([^0-9-]|^)(5[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4}))([^0-9-]|$)'
echo -e "\033[33m-------------------------------------------------------------------------------\033[0m" | tee -a $log
echo -e "\033[32mCopyright©Tekium 2023. All rights reserved.\033[0m" | tee -a $log
echo -e "\033[32mAuthor: Erick Roberto Rodriguez Rodriguez\033[0m" | tee -a $log
echo -e "\033[32mEmail: erodriguez@tekium.mx, erickrr.tbd93@gmail.com\033[0m" | tee -a $log
echo -e "\033[32mGitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script\033[0m" | tee -a $log
echo -e "\033[32mTekium PAN Hunter Script for Linux v1.1 - June 2023\033[0m" | tee -a $log
echo -e "\033[33m-------------------------------------------------------------------------------\033[0m" | tee -a $log
echo -e "Hostname: $HOSTNAME\n" | tee -a $log
echo -e "Path: $path_search\n" | tee -a $log
echo -e "Start the file search with the filters (it takes a few minutes)\n"
files_count=$(find $path_search -regextype posix-egrep -iregex '.*\.(txt|csv|docx|xlsx|log|xls|doc)$' -type f 2>/dev/null | wc -l) 
if [[ $files_count -gt 0 ]];then
	i=0
	files_no_pans=0
	echo -e "\033[32m$files_count files found\033[0m\n" | tee -a $log
	echo -e "Start the search for PAN's in the found files (it takes a few minutes)"
	names_files=$(find $path_search -regextype posix-egrep -iregex '.*\.(txt|csv|docx|xlsx|log|xls|doc)$' -type f 2>/dev/null) 
	for file in $names_files
	do
		if [ -f "$file" ]; then
			echo -e "\nSearch in: $file"
    		result=$(egrep -l "$regex_amex|$regex_visa|$regex_master" $file 2>/dev/null)
    		if [ $result ];then
    			echo -e "\n\033[32mPAN's found in: $result\033[0m\n" | tee -a $log
    			lines=$(egrep -n "$regex_amex|$regex_visa|$regex_master" $file 2>/dev/null)
    			echo -e "$lines\n" | tee -a $log
    		else
    			let files_no_pans=files_no_pans+1
    		fi
    	else
    		echo -e "\n\033[31mFile not found: $file\033[0m"
		fi
		ProgressBar ${i} ${files_count}
    	let i=i+1
	done
	if [[ $files_no_pans -eq $files_count ]];then
		echo -e "\n\033[31mNo PAN's found\033[0m" | tee -a $log
	else
		echo -e "\n\033[32mPAN's found\033[0m" | tee -a $log
	fi
	echo -e "\n\033[32mThe search for PAN's ended\033[0m"
else
	echo -e "\033[31mNo files found\033[0m" | tee -a $log
fi