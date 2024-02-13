# Tekium PAN Hunter Script v1.1.4

It's a tool that can be used to search drives for credit card numbers (PANs). This is useful for checking PCI DSS scope accuracy.

Born from the need to have a tool that is easy to run and use. Ideal if you need a tool that looks for possible PAN's on your organization.

# Characteristics
- Search for VISA, AMEX and MASTER CARD card numbers (based on regular expressions)
- Shows the total number of possible PAN's per file
- Masks the first 12 characters of the card number, for security reasons
- Option to exclude specific directories or folders
- Generates a log file with the search results
- Shows the progress of the search on the screen
- Validate the possible PAN using the [Luhn algorithm](https://es.wikipedia.org/wiki/Algoritmo_de_Luhn)
- Obtains the hash of the file with the result (validate file integrity)

# Requirements for Windows Systems
- Windows system
- PowerShell (A recent version is recommended)
- PowerShell Console (Executed with administrator permissions)
- Script execution enabled (Otherwise, run `Set-ExecutionPolicy Unrestricted`)

# Requirements for Linux Systems
- Linux system (Tested on Red Hat 8, Rocky Linux 8, and CentOS 8)
- User with administrator permissions

# Running on Windows systems

```
usage: .\Tekium_PAN_Hunter_Script.ps1 [-search_path] [-filters] [-exclude_path]

optional arguments:
  -search_path       Path where the possible PANs will be searched (default: C:\)
  -filters       Extensions of the files to be searched (default: '*.txt','*.csv','*.log')
  -exclude_path       Path or paths that are excluded from the search
```

By default, the script looks in C:\ and files with the extension .txt, .csv, and .log. 

This can be changed using the parameters: "search_path", where the path where the search will be performed (recursively) is indicated. The other is "filters" where the file types where the PANs will be searched are indicated, these must be specified as follows: `‘*.txt’, ‘*.docx’, ‘*.xml’` (separated by commas). The "exclude_path" parameter is optional and should only be used if you need to exclude certain directories or folders from the search. These paths must be specified as follows: `"C:\Windows", "C:\Program and Files"` (separated by commas).

For example:

`.\Tekium_PAN_Hunter_Script.ps1 -search_path “C:\Users” -filters ‘*.log’, ‘*.txt’, ‘*.csv’, ‘*.docx’, ‘*.xlsx’, ‘*.xls’, ‘*.doc’ -exclude_path "C:\Users\Downloads"`

**NOTE:** To obtain information about the script, such as usage and parameters, you can use the following command:

`Get-Help .\Tekium_PAN_Hunter_Script.ps1 -full`

# Running on Linux systems

Give execution permissions to the "Tekium_PAN_Hunter_Script.sh" file. Use the following command:

`chmod +x Tekium_PAN_Hunter_Script.sh`

By default, the script looks in / and files with the extension .txt, .csv, and .log. 

This can be changed using the parameters: The first parameter indicates the path where the search will be performed (recursively). The second parameter indicates the types of files where the PANs will be searched, these must be specified as follows: `txt,docx,xml` (separated by commas). The third parameter is optional and should only be used if you need to exclude certain directories or folders from the search. These paths must be specified as follows: `/home/user,/etc/,/bin` (separated by commas).

For example:

`./Tekium_PAN_Hunter_Script.sh /home/user/Documents txt,csv,docx,xlsx,xml /home/user/Documents/new_folder`

# Generate executable file on Windows systems

It's possible to generate an executable for Windows systems (.exe) using the ps2exe tool. To do this, you must first install the plugin:

`Install-Module ps2exe`

To generate the executable you must use the tool as follows:

`ps2exe .\Tekium_PAN_Hunter_Script.ps1 .\Tekium_PAN_Hunter_Script.exe`

For more information:
[ps2exe tool](https://github.com/MScholtes/PS2EXE)

**NOTE:** It was observed that when generating the executable, the parameters didn't work correctly. Therefore, this is ideal when you require the search to be performed with the default values.

# Generate executable file on Linux systems

It's possible to generate an executable for Linux systems using the Shc tool. To do this, you must first install the tool:

`yum install shc`

To generate the executable you must use the tool as follows:

`shc -f Tekium_PAN_Hunter_Script.sh` 

For more information:
[Shell Script Compiler](https://github.com/neurobin/shc)

# Example output

```
-------------------------------------------------------------------------------------
Copyright©Tekium 2024. All rights reserved.
Author: Erick Roberto Rodriguez Rodriguez
Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com
GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script
Tekium PAN Hunter Script v1.1.4 for Windows - February 2024
-------------------------------------------------------------------------------------
Hostname: LAPTOP-NUDA94QT
Scan start date: 02/12/2024 16:58:19
Path: C:\Users
Filters: *.log *.txt *.csv *.xlsx *.xls
Exclude: 

XXXXXXXXXXXX0004 MASTER CARD
XXXXXXXXXXXX0055 MASTER CARD
XXXXXXXXXXXX0006 MASTER CARD
XXXXXXXXXXXX0009 VISA
XXXXXXXXXXXX0004 VISA
XXXXXXXXXXXX3011 VISA
XXXXXXXXXXXX2012 VISA
XXXXXXXXXXXX0787 VISA
XXXXXXXXXXXX8884 MASTER CARD
XXXXXXXXXXXX8885 VISA
XXXXXXXXXXXX4940 VISA
XXXXXXXXXXXX7709 VISA

Total possible PAN's: 12

Possible PAN's found in: C:\Users\reric\Downloads\prueba.txt.FullName

Scan end date: 02/12/2024 16:58:25
```
```
-------------------------------------------------------------------------------
Copyright©Tekium 2024. All rights reserved.
Author: Erick Roberto Rodriguez Rodriguez
Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com
GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script
Tekium PAN Hunter Script for Linux v1.1.4 - February 2024
-------------------------------------------------------------------------------
Hostname: srv-develops-tekium
Scan start date: lun feb 12 16:55:26 CST 2024
Path: /home/erodriguez/Documentos/
Filters: txt,csv,log
Exclude:

4 files found

XXXX XXXX XXXX 0004 MASTER CARD
XXXX-XXXX-XXXX-0055 MASTER CARD
XXXXXXXXXXXX0006 MASTER CARD
XXXXXXXXXXXX0009 VISA
XXXXXXXXXXXX0004 VISA
XXXXXXXXXXXX3011 VISA
XXXXXXXXXXXX2012 VISA
XXXXXXXXXXXX0787 VISA
XXXXXXXXXXXX8884 MASTER CARD
XXXXXXXXXXXX8885 VISA
XXXXXXXXXXXX4940 VISA
XXXXXXXXXXXX7709 VISA

Total possible PAN's: 12
Possible PANs found in: /home/erodriguez/Documentos/Pruebas/prueba.txt

Scan end date: lun feb 12 16:55:27 CST 2024
```

# Commercial Support
![Tekium](https://github.com/unmanarc/uAuditAnalyzer2/blob/master/art/tekium_slogo.jpeg)

Tekium is a cybersecurity company specialized in red team and blue team activities based in Mexico, it has clients in the financial, telecom and retail sectors.

Tekium is an active sponsor of the project, and provides commercial support in the case you need it.

For integration with other platforms such as the Elastic stack, SIEMs, managed security providers in-house solutions, or for any other requests for extending current functionality that you wish to see included in future versions, please contact us: info at tekium.mx

For more information, go to: https://www.tekium.mx/
