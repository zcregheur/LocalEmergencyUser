#Installing RSAT Tools 
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State