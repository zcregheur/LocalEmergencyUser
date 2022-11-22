Import-Module ActiveDirectory
#Fetch every oneline computer inside the domain, list and save it 
Get-ADComputer -Filter * -SearchBase "DC=deshaies,DC=local" -Properties * |
Select-Object -Property Name |
Export-Csv ".\templist.csv" -NoTypeInformation -Encoding UTF8

