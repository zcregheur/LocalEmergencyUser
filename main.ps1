Import-Module ActiveDirectory

# Safely compares two SecureString objects without decrypting them.
# Outputs $true if they are equal, or $false otherwise.
#Credits to Bill Stewart for this function https://stackoverflow.com/users/2102693/bill-stewart
function Compare-SecureString {
    param(
      [Security.SecureString]
      $secureString1,
  
      [Security.SecureString]
      $secureString2
    )
    try {
      $bstr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString1)
      $bstr2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString2)
      $length1 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr1,-4)
      $length2 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr2,-4)
      if ( $length1 -ne $length2 ) {
        return $false
      }
      for ( $i = 0; $i -lt $length1; ++$i ) {
        $b1 = [Runtime.InteropServices.Marshal]::ReadByte($bstr1,$i)
        $b2 = [Runtime.InteropServices.Marshal]::ReadByte($bstr2,$i)
        if ( $b1 -ne $b2 ) {
          return $false
        }
      }
      return $true
    }
    finally {
      if ( $bstr1 -ne [IntPtr]::Zero ) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr1)
      }
      if ( $bstr2 -ne [IntPtr]::Zero ) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr2)
      }
    }
  }

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

<#
 do {
    $testinput = Read-Host -Prompt "Enter string"
} while (!(checkAlphaNumerical $testinput "test"))
#>

#Ask domain controller and ensures it is valid
$rawDCvalid = $false
while (!$rawDCvalid) {
    $rawDC = Read-Host -Prompt "Enter your domain controller (eg: domain.com)"
    if ($rawDC.Contains(".")) {
        $rawDC = $rawDC.Split(".")
        $ifHyphensRawDC = $rawDC.Split("-") #Ensures hyphens won't get flaggued by alphanumeric verification as they are valid in domain name
        $validAN = checkAlphaNumerical $ifHyphensRawDC "domain name."
        if ($validAN) {
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
    $validAN = checkAlphaNumerical $group "group name."
} while (!($validAN))
do {
    $usrName = Read-Host -Prompt "Specify the user to create"
    $validAN = checkAlphaNumerical $usrName "user name"
} while (!($validAN))

do {
    $passwd = Read-Host -Prompt "Specify password" -asSecureString
    $confirmPasswd = Read-Host "Confirm password" -asSecureString

    $passwdMatch = Compare-SecureString $passwd $confirmPasswd
    if (!($passwdMatch)) {
        Write-Output "Passwords do not match"
    }
} while (!($passwdMatch)) 

#Creating the user
Write-Output "Creating the user account remotely on every computer. This might take a while. Time for another coffee (or beer)..."
foreach ($comp in $computers) {
    Invoke-Command -ComputerName $comp -ArgumentList $usrName, $passwd, $group -ScriptBlock {
        New-LocalUser -Name $args[0] -FullName $args[0] -Description 'Local Emergency Account' -Password $args[1] -PasswordNeverExpires -AccountNeverExpires
        Add-LocalGroupMember -Group $args[2] -Member $args[0]
    }
}
Write-Output "Job's done. Have a nice day."
