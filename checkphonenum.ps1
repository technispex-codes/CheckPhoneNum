Import-Module ActiveDirectory
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

function CheckPhoneNum(){ param($FilePath)

    # Create/Append to Success file
    $date = Get-Date -Format FileDate
    
    $outfile = "C:\working\Success-Numbers-$date.txt"
    if (-not (Test-Path -Path $outfile -PathType Leaf)) {
        try {
            $null = New-Item -ItemType File -Path $outfile -Force -ErrorAction Stop
            Write-Host "Success file can be found here: $outfile"
        }
        catch {
            throw $_.Exception.Message
        }
    }
    else {
        Write-Host "Success file already exists, it can be found here: $outfile"
    }

    # Create/Append to Fail file
    $errorlog = "C:\working\Fail-Numbers-$date.txt"
    if (-not (Test-Path -Path $errorlog -PathType Leaf)) {
        try {
            $null = New-Item -ItemType File -Path $errorlog -Force -ErrorAction Stop
            Write-Host "Fail file can be found here: $errorlog"
        }
        catch {
            throw $_.Exception.Message
        }
    }
    else {
        Write-Host "Fail file already exists, it can be found here: $errorlog"
    }


    # Convert FilePath parameter to num for foreach loop
    $PhoneNums = Get-Content -Path $FilePath
    
    # Verify if num is found within AD, if not, output to Fail file
    foreach ($num in $PhoneNums) {
        $exists = Get-ADUser -filter "telephoneNumber -eq $num" | Select-Object -ExpandProperty SamAccountName
        if ($exists) {
            $exists >> $outfile
        }
        else {
            $num >> $errorlog
        }
    }
}
