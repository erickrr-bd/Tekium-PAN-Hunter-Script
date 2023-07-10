# Tekium PAN Hunter Script v1.1.2

It's a tool that can be used to search drives for credit card numbers (PANs). This is useful for checking PCI DSS scope accuracy.

Born from the need to have a tool that is easy to run and use. Ideal if you need a tool that looks for possible PAN's on your organization.

# Characteristics
- Search for VISA, AMEX and MASTER CARD card numbers (based on regular expressions)
- Shows the first five matches of each file
- Masks the first 12 characters of the card number, for security reasons
- Generates a log file with the search results
- Shows the progress of the search on the screen

# Requirements for Windows Systems
- Windows operating system
- PowerShell (A recent version is recommended)
- PowerShell Console (Executed with administrator permissions)
- Script execution enabled (Otherwise, run `Set-ExecutionPolicy Unrestricted`)

# Requirements for Linux Systems
- Linux operating system (Tested on Red Hat, Rocky Linux, and CentOS)
- User with administrator permissions

# Running on Windows systems

By default, the script looks in C:\ and files with the extension txt, csv, and log. 

This can be changed using the parameters: "path_search", where the path where the search will be performed (recursively) is indicated. The other is "filters" where the file types where the PANs will be searched are indicated, these must be specified as follows: '*.txt', '*.docx', '*.xlsx' (separated by commas).

For example:

`.\Tekium_PAN_Hunter_Script.ps1 -path_search “C:\Users” -filters ‘*.log’, ‘*.txt’, ‘*.csv’, ‘*.docx’, ‘*.xlsx’, ‘*.xls’, ‘*.doc’`

# Running on Linux systems

Give execution permissions to the file "Tekium_PAN_Hunter_Script.sh", for this the following command is executed:

`chmod +x Tekium_PAN_Hunter_Script.sh`

By default, the script looks in files with the extension: txt, csv, docx, xlsx, xls, doc and log. 

You must indicate the path where the script will perform the search (recursively).

For example:

`.\Tekium_PAN_Hunter_Script.sh /home/user/Documents`

# Example output

```
-------------------------------------------------------------------------------------
Copyright©Tekium 2023. All rights reserved.
Author: Erick Roberto Rodriguez Rodriguez
Email: erodriguez@tekium.mx, erickrr.tbd93@gmail.com
GitHub: https://github.com/erickrr-bd/Tekium-PAN-Hunter-Script
Tekium PAN Hunter Script v1.1.2 for Windows - June 2023
-------------------------------------------------------------------------------------
Hostname: LAPTOP-NUDA94QT
Path: C:\Users\reric\Downloads
Filters: *.log *.txt *.csv *.docx *.xlsx *.xls *.doc

 XXXXXXXXXXXX0004  MASTER CARD
 XXXXXXXXXXXX0055  MASTER CARD
 XXXXXXXXXXXX0006  MASTER CARD
 XXXXXXXXXXXX0009  VISA
 XXXXXXXXXXXX0004  VISA

Possible PAN's found in: C:\Users\reric\Downloads\Nuevo Documento de texto.txt.FullName
```

# Commercial Support
![Tekium](https://github.com/unmanarc/uAuditAnalyzer2/blob/master/art/tekium_slogo.jpeg)

Tekium is a cybersecurity company specialized in red team and blue team activities based in Mexico, it has clients in the financial, telecom and retail sectors.

Tekium is an active sponsor of the project, and provides commercial support in the case you need it.

For integration with other platforms such as the Elastic stack, SIEMs, managed security providers in-house solutions, or for any other requests for extending current functionality that you wish to see included in future versions, please contact us: info at tekium.mx

For more information, go to: https://www.tekium.mx/
