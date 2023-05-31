# Tekium PAN Hunter Script v1.1

It's a tool that can be used to search drives for credit card numbers (PANs). This is useful for checking PCI DSS scope accuracy.

Born from the need to have a tool that is easy to run and use. Being developed in PowerShell doesn't require external libraries. Ideal if you require a tool that searches for possible PAN's in files on Windows computers within your organization.

Search for American Express, VISA and MasterCard card numbers.

# Requirements
- Windows operating system
- PowerShell (A recent version is recommended)
- PowerShell Console (Executed with administrator permissions)
- Script execution enabled (Otherwise, run `Set-ExecutionPolicy Unrestricted`)

# Execution

By default, the script looks in C:\ and files with the extension txt, csv, and log. 

This can be changed using the parameters: "path_search", where the path where the search will be performed (recursively) is indicated. The other is "filters" where the file types where the PANs will be searched are indicated, these must be specified as follows: '*.txt', '*.docx', '*.xlsx' (separated by commas).

Here is an example:

`.\Tekium_PAN_Hunter_Script.ps1 -path_search “C:\Users” -filters ‘*.log’, ‘*.txt’, ‘*.csv’, ‘*.docx’, ‘*.xlsx’`

# Commercial Support
![Tekium](https://github.com/unmanarc/uAuditAnalyzer2/blob/master/art/tekium_slogo.jpeg)

Tekium is a cybersecurity company specialized in red team and blue team activities based in Mexico, it has clients in the financial, telecom and retail sectors.

Tekium is an active sponsor of the project, and provides commercial support in the case you need it.

For integration with other platforms such as the Elastic stack, SIEMs, managed security providers in-house solutions, or for any other requests for extending current functionality that you wish to see included in future versions, please contact us: info at tekium.mx

For more information, go to: https://www.tekium.mx/
