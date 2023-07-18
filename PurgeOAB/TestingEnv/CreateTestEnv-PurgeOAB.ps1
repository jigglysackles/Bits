#Create Test File Setup 
$MachineNameOrIP = hostname

# 1. Get the proper Path
$LoggedOnUser = Get-WMIObject Win32_Process -filter 'name="explorer.exe"' -computername $MachineNameOrIP |
    ForEach-Object { $owner = $_.GetOwner(); '{0}\{1}' -f $owner.Domain, $owner.User } |
    Sort-Object | Get-Unique

$CleanUser = $LoggedOnUser.split('\')[1]

$filePath1 = Join-Path -Path C:\Users\ $CleanUser 
$filePath2 = Join-Path -Path $filePath1 "\AppData\Local\Microsoft\Outlook\Offline Address Books\Test"
$filePath3 = Join-Path -Path $filePath2 "\testfolder01"
$filePath4 = Join-Path -Path $filePath2 "\testfolder02"
$testFile1 = Join-Path -Path $filepath2 "testfile01.txt"
$testFile2 = Join-Path -Path $filepath4 "testfile02.txt"

# 2. Make test Folders 
 
#[CmdletBinding()]
#Param(
#    [Parameter(Mandatory = $True)]
#    [String] $filePath2)

if (-not (Test-Path -LiteralPath $filePath2)) {
    
    try {
        New-Item -Path $filePath2 -ItemType Directory -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$DirectoryToCreate'. Error was: $_" -ErrorAction Stop
    }
    Write-Host "Successfully created directory '$filePath2'." -ForegroundColor DarkGreen -BackgroundColor Black

}
else {
    Write-Host "Test Directory Present" -ForegroundColor DarkGreen -BackgroundColor Black
}

#[CmdletBinding()]
#Param(
#    [Parameter(Mandatory = $True)]
#    [String] $filePath3)

if (-not (Test-Path -LiteralPath $filePath3)) {
    
    try {
        New-Item -Path $filePath3 -ItemType Directory -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$DirectoryToCreate'. Error was: $_" -ErrorAction Stop
    }
    Write-Host "Successfully created directory '$filePath3'." -ForegroundColor DarkGreen -BackgroundColor Black

}
else {
    Write-Host "Test Directory Present" -ForegroundColor DarkGreen -BackgroundColor Black
}

#[CmdletBinding()]
#Param(
#    [Parameter(Mandatory = $True)]
#    [String] $filePath4)

if (-not (Test-Path -LiteralPath $filePath4)) {
    
    try {
        New-Item -Path $filePath4 -ItemType Directory -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$DirectoryToCreate'. Error was: $_" -ErrorAction Stop
    }
    Write-Host "Successfully created directory '$filePath4'." -ForegroundColor DarkGreen -BackgroundColor Black

}
else {
    Write-Host "Test Directory Present" -ForegroundColor DarkGreen -BackgroundColor Black
}

##########################################################################################
# 2. Make test Files


#[CmdletBinding()]
#Param(
#    [Parameter(Mandatory = $True)]
#    [String] $testFile1)

if (-not (Test-Path -Path $testFile1 -PathType Leaf)) {
    
    try {
        New-Item -Path $testFile1 -ItemType File -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create file '$testFile1'. Error was: $_" -ErrorAction Stop
    }
    Write-Host "Successfully created file 'testfile01'." -ForegroundColor DarkGreen -BackgroundColor Black

}
else {
    Write-Host "Test File Present" -ForegroundColor DarkGreen -BackgroundColor Black
}


#[CmdletBinding()]
#Param(
#    [Parameter(Mandatory = $True)]
#    [String] $testFile2)

if (-not (Test-Path -Path $testFile2 -PathType Leaf)) {
    
    try {
        New-Item -Path $testFile2 -ItemType File -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create file '$testFile2'. Error was: $_" -ErrorAction Stop
    }
    Write-Host "Successfully created file 'testfile02'." -ForegroundColor DarkGreen -BackgroundColor Black

}
else {
    Write-Host "Test File Present" -ForegroundColor DarkGreen -BackgroundColor Black
}

#####################################################################################

#Adjust CreationTime attribute 

Write-Host "Adjusting the day of Creation" -ForegroundColor DarkGreen -BackgroundColor Black

Get-Item $testFile1 | % {$_.CreationTime ='03/06/2019 19:00:00'}
Get-Item $testFile1 | FT Name,CreationTime
Get-Item $testFile2 | % {$_.CreationTime ='03/06/2019 19:00:00'}
Get-Item $testFile2 | FT Name,CreationTime
Get-Item $FilePath3 | % {$_.CreationTime ='03/06/2019 19:00:00'}
Get-Item $FilePath3 | FT Name,CreationTime
Get-Item $filePath4 | % {$_.CreationTime ='03/06/2019 19:00:00'}
Get-Item $filePath4 | FT Name,CreationTime
