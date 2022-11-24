Import-Module ActiveDirectory

#Validate that entered data is alphanumerical
function checkAlphaNumerical {
    param (
        #First, the string to validate, then a string to append to the error message
        $stringToValidate, $stringDesc
    )
    if ($stringToValidate -notmatch '^[a-z0-9]+$') {
        Write-Output ("Invalid $($stringDesc)")
        return $false
    }
    else {
        return $true
    }
}


 do {
    $testinput = Read-Host -Prompt "Enter string"
} while (!(checkAlphaNumerical $testinput "test"))

#Ask domain controller and ensures it is valid
$rawDCvalid = $false
while (!$rawDCvalid) {
    $rawDC = Read-Host -Prompt "Enter your domain controller (eg: domain.com)"
    if ($rawDC.Contains(".")) {
        $rawDC = $rawDC.Split(".")
        $ifHyphensRawDC = $rawDC.Split("-") #Ensures hyphens won't get flaggued by alphanumeric verification as they are valid in domain name
        if (checkAlphaNumerical $ifHyphensRawDC "domain name.") {
            $rawDCvalid = $true
        }
    }
    else {
        Write-Output "Invalid domain name."
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
Write-Output "Fetching computers hostnames in specified domain. This might take couple minutes depending on domain size. Go get yourself a coffee... or a beer. I'm judging no one." 
$computers = Get-ADComputer -Filter * -SearchBase $DC -Properties * |
Select-Object -Property Name

#Asking user credentials
do {
    $group = Read-Host -Prompt "Specify the group which the user will belongs to"
} while (!(checkAlphaNumerical $group "group name."))
do {
    $usrName = Read-Host -Prompt "Specify the user to create."
} while (!(checkAlphaNumerical $usrName "user name."))
$passwd = Read-Host -Prompt "Specify password" #Will be entered twice, invisible field, no char verif

