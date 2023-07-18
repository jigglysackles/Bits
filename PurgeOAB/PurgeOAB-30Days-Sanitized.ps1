$DateCutOff=(Get-Date).AddDays(-30)
$MachineNameOrIP = hostname

$LoggedOnUser = Get-WMIObject Win32_Process -filter 'name="explorer.exe"' -computername $MachineNameOrIP |
    ForEach-Object { $owner = $_.GetOwner(); '{0}\{1}' -f $owner.Domain, $owner.User } |
    Sort-Object | Get-Unique

$CleanUser = $LoggedOnUser.split('\')[1]

$filePath1 = Join-Path -Path C:\Users\ $CleanUser 
$filePath2 = Join-Path -Path $filePath1 "\AppData\Local\Microsoft\Outlook\Offline Address Books"

Get-ChildItem $filepath2 -Recurse | Where {$_.CreationTime -lt $datecutoff} | sort CreationTime -desc | Remove-Item -Force
