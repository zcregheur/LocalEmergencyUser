Import-Module ActiveDirectory
Get-ADComputer -Filter * -SearchBase "OU=Utilisateurs,DC=deshaies,DC=local" -Properties * |
Select-Object -Property Name,LastLogonDate