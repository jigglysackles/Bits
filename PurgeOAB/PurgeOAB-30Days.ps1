#REM Delete if older than 30 days
#REM "C:\Users\%username%\AppData\Local\Microsoft\Outlook\Offline Address Books"
#REM 

#Get-ChildItem "C:\Users\%username%\AppData\Local\Microsoft\Outlook\Offline Address Books" -Recurse | Where {$_.whenCreated -gt $datecutoff} | sort LastWriteTime -desc | Write-Output
#Get-ChildItem "C:\Users\%username%\AppData\Local\Microsoft\Outlook\Offline Address Books" -Recurse | where{-not $_.PsIsContainer} -and Where {$_.whenCreated -gt $datecutoff} | sort LastWriteTime -desc | Remove-Item -Force


# Get-ADUser -Filter * -Property whenCreated | Where {$_.whenCreated -gt $datecutoff} | FT Name, whenCreated -Autosize

#Select-Object @{N="Username";E={$_.Username -replace ".+\\"}}
try {
Write-Host "Establishing Date Cutoff: " -NoNewLine  
$DateCutOff=(Get-Date).AddDays(-30)
Write-Host $DateCutOff -ForegroundColor DarkGreen -BackgroundColor Black
}
catch {
	Write-Host "No Dice. Error occured, check logs or fix script." -ForegroundColor Magenta -BackgroundColor Black
}

try {
Write-Host "Machine Name: " -NoNewLine
$MachineNameOrIP = hostname
Write-Host $MachineNameOrIP -ForegroundColor DarkGreen -BackgroundColor Black
}
catch {
	Write-Host "Not happening. Error occured. Are you doing this right?" -ForegroundColor Magenta -BackgroundColor Black
}


try {
Write-Host "Getting Logged On User: "-NoNewLine
$LoggedOnUser = Get-WMIObject Win32_Process -filter 'name="explorer.exe"' -computername $MachineNameOrIP |
    ForEach-Object { $owner = $_.GetOwner(); '{0}\{1}' -f $owner.Domain, $owner.User } |
    Sort-Object | Get-Unique
Write-Host $LoggedOnUser -ForegroundColor DarkGreen -BackgroundColor Black
}
catch {
	Write-Host "Not gonna lie, if it was going to go wrong it'd be here. Check Permissions or script." -ForegroundColor Magenta -BackgroundColor Black
}

Try {
Write-Host "Stripping Domain: " -NoNewLine
$CleanUser = $LoggedOnUser.split('\')[1]
Write-Host $CleanUser -ForegroundColor DarkGreen -BackgroundColor Black
}
catch {
	Write-Host "Error. Not much to go wrong here, check permissions, ensure prior command giving domain\username output." -ForegroundColor Magenta -BackgroundColor Black
}

Try {
Write-Host "Making the FilePath: " -NoNewLine
$filePath1 = Join-Path -Path C:\Users\ $CleanUser 
$filePath2 = Join-Path -Path $filePath1 "\AppData\Local\Microsoft\Outlook\Offline Address Books"
Write-Host $filePath2 -ForegroundColor DarkGreen -BackgroundColor Black
}

catch {
	Write-Host "Error. That doesn't look right." -ForegroundColor Magenta -BackgroundColor Black
}

Try {
Write-Host "Purging the heretics..." 
#TestBeforeDelete# Get-ChildItem $filepath2 -Recurse | Where {$_.CreationTime -lt $datecutoff} | sort CreationTime -desc | Select-Object Name, CreationTime | Write-Output
Get-ChildItem $filepath2 -Recurse | Where {$_.CreationTime -lt $datecutoff} | sort CreationTime -desc | Remove-Item -Force
}

catch {
	Write-Host "Error. No heretics purged. The age requirement might not be met, or something else broke." -ForegroundColor Magenta -BackgroundColor Black
}