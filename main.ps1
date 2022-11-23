Import-Module ActiveDirectory

#Ask domain controller and ensures it is valid
$rawDCvalid = $false
while (!$rawDCvalid) {
    $rawDC = Read-Host -Prompt "Enter your domain controller (eg: domain.com)"
    if ($rawDC.Contains(".")) {
        $rawDC = $rawDC.Split(".")
        $ifHyphensRawDC = $rawDC.Split("-") #Ensures hyphens won't get flaggued by alphanumeric verification
        if ($ifHyphensRawDC -notmatch '^[a-z0-9]+$') {
            Write-Output "Domain name invalid"
        }
        else {
            $rawDCvalid = $true
        }
    }
    else {
        Write-Output "Domain name invalid"
    }
}

#Format domain name for Get-ADComputer function
$arrayIndex = -0
$DC = ""
foreach($name in $rawDC) {
    $arrayIndex +=1
    $DC = $DC + "DC=" + $name

    if ($arrayIndex -lt $rawDC.Length) {
        $DC = $DC + ","
    }
    
}

#Fetch every oneline computer inside the domain, list and save it 
$computers = Get-ADComputer -Filter * -SearchBase $DC -Properties * |
Select-Object -Property Name

$group = ""
$usrName = ""
$passwd = ""


while ($group -notmatch '^[a-z0-9]+$') {
    $group = Read-Host -Prompt "Specify the group which the user will belongs to"
    if ($group -notmatch '^[a-z0-9]+$') {
        Write-Output "Invalid group name"
    }
}

$usrName = Read-Host -Prompt "Specify the user name"
$passwd = Read-Host -Prompt "Specify password" #Will be entered twice, invisible field, no char verif

function checkAlphaNumerical {
    param (
        $stringToValidate, $stringDesc
    )

    while ($stringToValidate -notmatch '^[a-z0-9]+$') {
        Write-Output "Invalid " + $stringDesc
    }
    
}
