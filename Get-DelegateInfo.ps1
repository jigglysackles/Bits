######################################

#Author = Sunil Chauhan
#Edited by John Hoffman 2023
#Name = Get-ResourceDelegates.ps1

######################################

#cls

#$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell" -Credential $cred -Authentication Basic -AllowRedirection
#Import-PSSession $session -AllowClobber

#Enable Exchange cmdlets
#add-pssnapin *exchange* -erroraction SilentlyContinue 

cls
$C = 0
write-host
write-host "Getting mailbox data.  Please wait..."

$Mbx=Get-Mailbox -ResultSize Unlimited
write-host "Mailbox Data Fetch Completed."
start-sleep 1
Write-host
write-host "Checking Resource Delegate info...."

$ResourceDelegates=
    foreach ($user in $mbx)
    {
        $C++ ;
        Write-host "Checking for Delegates of $user"        
        
        Try {
            Get-CalendarProcessing $user.alias }
        
        Catch {
            Write-Host "Error retrieving information for $user." }
    }

$Report= $ResourceDelegates | Select Identity, ResourceDelegates
$exportReport= $report | Export-CSV "c:\temp\ResourceDelegates2.csv"
write-host "Reporting completed, File Exported to c:\temp\ResourceDelegates2.csv"
start-sleep 1

#Close the session
Remove-PSSession $Session