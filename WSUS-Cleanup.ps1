#Requires -Version 3.0
################################
#       Adamj Clean-WSUS       #
#         Version 3.2          #
#                              #
#   The last WSUS Script you   #
#       will ever need!        #
#                              #
#       By: Adam Marshall      #
#     http://www.adamj.org     #
################################
<#
################################
#  End User License Agreement  #
################################
http://www.adamj.org/clean-wsus/end-user-license-agreement.html

################################
#         Prerequisites        #
################################

1. This script has to be saved as plain text in ANSI format. If you use Notepad++, you might need to
   change the encoding to ANSI (Encoding > 'Encode in ANSI' or Encode > 'Convert to ANSI').
   An easy way to tell if it is saved in plain text (ANSI) format is that there is a #Requires
   statement at the top of the script. Make sure that there is a hyphen before the word
   "Version" and you shouldn't have a problem with executing it. If you end up with an error
   like below, it is due to the encoding of the file as you can tell by the – characters
   before the word Version.

   At C:\Scripts\Clean-WSUS.ps1:1 char:13
   + #Requires –Version 3.0

2. You must run this on the WSUS Server itself and any downstream WSUS servers you may have.
   It does not matter the order on where you run it as the script takes care of everything
   for you.

3. On the WSUS Server, you must install the SQL Server Management Studio (SSMS) from Microsoft
   so that you have the SQLCMD utility. The SSMS is not a requirement but rather a good tool for
   troubleshooting if needed. The bare minimum requirement is the Microsoft Command Line
   Utilities for SQL Server at whatever version yours is.

4. You must have PowerShell 3.0 or higher installed. I recommend version 4.0 or higher.

    Prerequisite Downloads
    ----------------------

    - For Server 2008 SP2:
        - Install Windows PowerShell from Server Manager - Features
        - Install .NET 3.5 SP1 from - https://www.microsoft.com/en-ca/download/details.aspx?id=25150
        - Install SQL Server Management Studio from https://www.microsoft.com/en-ca/download/details.aspx?id=30438
          You want to choose SQLManagementStudio_x64_ENU.exe
        - Install .NET 4.0 - https://www.microsoft.com/en-us/download/details.aspx?id=17718
        - Install PowerShell 2.0 & WinRM 2.0 from https://www.microsoft.com/en-ca/download/details.aspx?id=20430
        - Install Windows Management Framework 3.0 from https://www.microsoft.com/en-ca/download/details.aspx?id=34595

    - For Server 2008 R2:
        - Install .NET 4.5.2 from https://www.microsoft.com/en-ca/download/details.aspx?id=42642
        - Install Windows Management Framework 4.0 and reboot from https://www.microsoft.com/en-ca/download/details.aspx?id=40855
        - Install SQL Server Management Studio from https://www.microsoft.com/en-ca/download/details.aspx?id=30438
          You want to choose SQLManagementStudio_x64_ENU.exe

    - For SBS 2008: This script WILL work on SBS 2008 - you just have to install the prerequisites below.
                    .NET 4 is backwards compatible and I have a lot of users who have installed it on SBS 2008 and use the script.
        - Install Windows PowerShell from Server Manager - Features
        - Install .NET 3.5 SP1 from - https://www.microsoft.com/en-ca/download/details.aspx?id=25150
        - Install SQL Server Management Studio from https://www.microsoft.com/en-ca/download/details.aspx?id=30438
          You want to choose SQLManagementStudio_x64_ENU.exe
        - Install .NET 4.0 - https://www.microsoft.com/en-us/download/details.aspx?id=17718
        - Install PowerShell 2.0 & WinRM 2.0 from https://www.microsoft.com/en-ca/download/details.aspx?id=20430
        - Install Windows Management Framework 3.0 from https://www.microsoft.com/en-ca/download/details.aspx?id=34595
        - See "A note to SBS users:" Below

    - For SBS 2011: This script WILL work on SBS 2011 - you just have to install the prerequisites below.
                    .NET 4 is backwards compatible and I have a lot of users who have installed it on SBS 2011 and use the script.
        - Install .NET 4.5.2 from https://www.microsoft.com/en-ca/download/details.aspx?id=42642
        - Install Windows Management Framework 4.0 and reboot from https://www.microsoft.com/en-ca/download/details.aspx?id=40855
        - Install SQL Server Management Studio from https://www.microsoft.com/en-ca/download/details.aspx?id=30438
          You want to choose SQLManagementStudio_x64_ENU.exe
        - See "A note to SBS users:" Below

    - For Server 2012 & 2012 R2
        - Install SQL Server Management Studio from https://www.microsoft.com/en-us/download/details.aspx?id=29062
          You want to choose the ENU\x64\SQLManagementStudio_x64_ENU.exe

    - For Server 2016
        - I've not personally tested this on server 2016, however many people have run it without issues on Server 2016.
          I don't think Microsoft has changed much between 2012 R2 WSUS and 2016 WSUS.
        - Install SQL Server Management Studio from https://msdn.microsoft.com/library/mt238290.aspx

    IF YOU DON'T WANT TO INSTALL SQL SERVER MANAGEMENT STUDIO:
    Microsoft Command Line Utilities for SQL Server (Minimum requirement instead of SQL Server Management Studio)
        SQL 2008/2008R2 - https://www.microsoft.com/en-ca/download/details.aspx?id=16978
        SQL 2012/2014 - Version 11 - https://www.microsoft.com/en-us/download/details.aspx?id=36433
                      - ODBC Driver Version 11 - https://www.microsoft.com/en-gb/download/details.aspx?id=36434
        SQL 2016 - Version 13 - https://www.microsoft.com/en-us/download/details.aspx?id=53591

    A note to SBS users:
        For those of you who have already Googled and have read that there are compatibility issues with PowerShell 3.0
        or 4.0 and/or Windows Management Framework 3.0 or 4.0 and have seen all of the release notes and posts saying
        not to install these on SBS, please take notes of the dates of these pages and advice notes. Most of these are
        relying on and regurgitating old information. If a site has a recent post that says not to install it as there
        are compatibility issues, find their source of information and if you follow the source, you'll notice that
        they are regurgitating a post from years ago. When you are reading things on the Internet, think critically,
        look at dates, and use your intelligence to figure out if it still makes sense. Don't blindly rely on words
        on pages of the internet.

        An example is .NET 4.7 which was released 2017.06.15 and which has a warning to not install .NET 4.7 on an
        Exchange server. This holds true until it can be properly tested, and if issues found, patches to .NET 4.7.x
        released for compatibility with Exchange. The biggest issue - all previous forums, blogs and writings on the
        Internet will not be updated to say that .NET 4.7 is now compatible to install on Exchange servers. This
        showcases my point that imagine in 2019 someone who is thinking about updating an Exchange server, Googling
        to find out if .NET 4.7 is compatible (when current version of .NET is probably around version 5.0 or 5.1)
        and finding all these warnings about not installing it on an Exchange server.

        One note for any system, but something to mention specifically for this thought:
        The best thing you can do is make sure your system is updated. Non-updated systems suffer problems and exploits
        that in the end, cause you more time in troubleshooting and fixing than to keep systems updated.

################################
#         Instructions         #
################################

 1. Edit the variables below to match your environment (It's only email server settings if you
    use my default settings)
 2. Open PowerShell using "Run As Administrator" on the WSUS Server.
 3. Because you downloaded this script from the internet, you cannot initially run it directly
    as the ExecutionPolicy is default set to "Restricted" (Server 2008, Server 2008 R2, and
    Server 2012) or "RemoteSigned" (Server 2012 R2).  You must change your ExecutionPolicy to
    Bypass. You can do this with Set-ExecutionPolicy, however that will change it globally for
    the server, which is not recommended. Instead, launch another PowerShell.exe with the
    ExecutionPolicy set to bypass for just that session. At your current PowerShell prompt,
    type in the following and then press enter:

        PowerShell.exe -ExecutionPolicy Bypass

 3. Run the script using -FirstRun.

        .\Clean-WSUS.ps1 -FirstRun

You can use Get-Help .\Clean-WSUS.ps1 for more information.
#>

<#
.SYNOPSIS
This is the last WSUS Script you will ever need. It cleans up WSUS and runs all the maintenance scripts to keep WSUS running at peak performance.

.DESCRIPTION
################################
#    Background Information    #
#          on Streams          #
################################

All my recommendations are set in -ScheduledRun.

Adamj WSUS Index Optimization Stream
-----------------------------------------------------

This stream will add the necessary SQL Indexes into the SUSDB Database that make WSUS work about
1,000 to 1,500 times faster on many database operations, making your WSUS installation better
than what Microsoft has left us with.

This stream will be run first on -FirstRun to ensure the rest of the script doesn't take as long
as it has in prior times.

You can use -WSUSIndexOptimization to run this manually from the command-line.

Adamj Remove WSUS Drivers Stream
-----------------------------------------------------

This stream will remove all WSUS Drivers Classifications from the WSUS database.
This has 2 possible running methods - Run through PowerShell, or Run directly in SQL.
The -FirstRun Switch will force the SQL method, but all other automatic runs will use the
PowerShell method. I recommend this be done every quarter.

You can use -RemoveWSUSDriversSQL or -RemoveWSUSDriversPS to run these manually from the command-line.

Adamj Remove Obsolete Updates Stream
-----------------------------------------------------

This stream will use SQL code to execute pre-existing stored procedures that will return the update id
of each obsolete update in the database and then remove it. There is no magic number of obsolete updates
that will cause the server to time-out. Running this stream can easily take a couple of hours to delete
the updates. While the process is running you might see WSUS synchronization errors. I recommend that
this be done monthly.

You can use -RemoveObsoleteUpdates to run this manually from the command-line.

Adamj Compress Update Revisions Stream
-----------------------------------------------------

This stream will use SQL code to execute pre-existing stored procedures that will return the update id
of each update revision that needs compressing and then compress it. I recommend that this be done
monthly.

You can use -CompressUpdateRevisions to run this manually from the command-line.

Adamj Decline Multiple Types Of Updates Stream
-----------------------------------------------------

This stream will decline multiple types of updates: Superseded, Expired, and Itanium to name a few.
This is configurable on a per-type basis for inclusion or exclusion when the stream is run.

I recommend that this stream be run every month.

You can use -DeclineMultipleTypesOfUpdates to run this manually from the command-line.

### A note about the default types of updates to be removed. ###

Expired: Decline updates that have been pulled by Microsoft.
Itanium: Decline updates for Itanium computers.
Beta: Decline updates for beta products and beta updates.
Superseded: Decline updates that are superseded and not yet declined.
Preview: Decline preview updates as preview updates may contain bugs because they are not the finished product.

### Please read the background information below on superseded updates for more details. ###

This will be the biggest factor in shrinking down the size of your WSUS Server. Any update that
has been superseded but has not been declined is using extra space. This will save you GB of data
in your WsusContent folder. A superseded update is a complete replacement of a previous release
update. The superseding update has everything that the superseded update has, but also includes
new data that either fixes bugs, or includes something more.

The Server Cleanup Wizard (SCW) declines superseded updates, only if:

    The newest update is approved, and
    The superseded updates are Not Approved, and
    The superseded update has not been reported as NotInstalled (i.e. Needed) by any computer in the previous 30 days.

There is no feature in the product to automatically decline superseded updates on approval of the newer update,
and in fact, you really do not want that feature. The "Best Practice" in dealing with this situation is:

1. Approve the newer update.
2. Verify that all systems have installed the newer update.
3. Verify that all systems now report the superseded update as Not Applicable.
4. THEN it is safe to decline the superseded update.

To SEARCH for superseded updates, you need only enable the Superseded flag column in the All Updates view, and sort on that column.

There will be four groups:

1. Updates which have never been superseded (blank icon).
2. Updates which have been superseded, but have never superseded another update (icon with blue square at bottom).
3. Updates which have been superseded and have superseded another update (icon with blue square in middle).
4. Updates which have superseded another update (icon with blue square at top).

There's no way to filter based on the approval status of the updates in group #4, but if you've verified that all
necessary/applicable updates in group #4 are approved and installed, then you'd be free to decline groups #2 and #3 en masse.

If you decline superseded updates using the method described:

1. Approve the newer update.
2. Verify that all systems have installed the newer update.
3. Verify that all systems now report the superseded update as Not Applicable.
4. THEN it is safe to decline the superseded update.

### THIS SCRIPT DOES NOT FOLLOW THE ABOVE GUIDELINES. IT WILL JUST DECLINE ANY SUPERSEDED UPDATES. ###

Adamj Clean Up WSUS Synchronization Logs Stream
-----------------------------------------------------

This stream will remove all synchronization logs beyond a specified time period. WSUS is lacking the ability
to remove synchronization logs through the GUI. Your WSUS server will become slower and slower loading up
the synchronization logs view as the synchronization logs will just keep piling up over time. If you have
your synchronization settings set to synchronize 4 times a day, it would take less than 3 months before you
have over 300 logs that it has to load for the view. This is very time consuming and many just ignore this
view and rarely go to it. When they accidentally click on it, they curse. I recommend that this be done daily.

You can use -CleanUpWSUSSynchronizationLogs to run this manually from the command-line.

Adamj Remove Declined WSUS Updates Stream
-----------------------------------------------------

This stream will remove any Declined WSUS updates from the WSUS Database. This is good if you are removing
Specific products (Like Server 2003 / Windows XP updates) from the WSUS server under the Products and
Classifications section. Since this will remove them from the database, if they are still valid, and you
want them to re-appear, you will have to re-add them using 1 of 2 methods. Use the 'Import Update' option
from within the WSUS Console to install specific updates through the Windows Catalog, or remove the product
family, sync, re-select the product family, and then the next synchronizations will pick up the updates
again, along with everything else in that product family. I recommend that this be done every quarter.
This stream is NOT included on -FirstRun on purpose.

You can use -RemoveDeclinedWSUSUpdates to run this manually from the command-line.

Adamj Computer Object Cleanup Stream
-----------------------------------------------------

This stream will find all computers that have not synchronized with the server within a certain time period
and remove them. This is usually done through the Server Cleanup Wizard (SCW), however the SCW has been
hard-coded to 30 days. I've setup this stream to be configurable. You can also tell it not to delete any
computer objects if you really want to. The default I've kept at 30 days. I recommend that this be done daily.

You can use -ComputerObjectCleanup to run this manually from the command-line.

Adamj WSUS Database Maintenance Stream
-----------------------------------------------------

This stream will perform basic maintenance tasks on SUSDB, the WSUS Database. It will identify indexes
that are fragmented and defragment them. For certain tables, a fill-factor is set in order to improve
insert performance. It will then update potentially out-of-date table statistics. I recommend that this
be done daily.

You can use -WSUSDBMaintenance to run this manually from the command-line.

Adamj Server Cleanup Wizard Stream
-----------------------------------------------------

The Server Cleanup Wizard (SCW) is integrated into the WSUS GUI, and can be used to help you manage your
disk space. This runs the SCW through PowerShell which has the added bonus of not timing out as often
the SCW GUI would.

This wizard can do the following things:
    - Remove unused updates and update revisions
      The wizard will remove all older updates and update revisions that have not been approved.

    - Delete computers not contacting the server
      The wizard will delete all client computers that have not contacted the server in thirty days or more.
      This is DISABLED by default as the Computer Object Cleanup Stream takes care of this in a more
      configurable method.

    - Delete unneeded update files
      The wizard will delete all update files that are not needed by updates or by downstream servers.

    - Decline expired updates
      The wizard will decline all updates that have been expired by Microsoft.

    - Decline superseded updates
      The wizard will decline all updates that meet all the following criteria:
          The superseded update is not mandatory
          The superseded update has been on the server for thirty days or more
          The superseded update is not currently reported as needed by any client
          The superseded update has not been explicitly deployed to a computer group for ninety days or more
          The superseding update must be approved for install to a computer group

I recommend that this be done daily. When using -FirstRun, all of the script's streams perform compression and
removal tasks prior to the SCW being run. Therefore, with the exception of DiskSpaceFreed, all of the other
fields of the SCW will return 0 when using -FirstRun.

You can use -WSUSServerCleanupWizard to run this manually from the command-line.

Adamj Application Pool Memory Configuration Stream
-----------------------------------------------------
Why does the WSUS Application pool crash and how can we fix it? The WSUS Application pool has a
"private memory limit" setting that is configured by default to a low number based on RAM. The
Application pool crashes because it can't keep up and the limit is reached. So why couldn't the WSUS
Application pool keep up? This has to do with the larger number of updates in the Update Catalog
(database) which continues to grow over time. WSUS does not handle an excessive number of updates well
and as as the number increases, the load on the application pool increases causing it to slowly run out
of memory until the limit is hit and WSUS crashes. I've seen it start having issues above the low
number of 10,000 updates and above the high number of 100,000 updates. The number of updates can in
part be due to obsolete updates that remain in the database and it varies in every system and
implementation. In order to help alleviate this, we can increase the memory on the WSUS Application Pool.

I recommend that this be done manually, only if necessary, by the command-line.

-DisplayApplicationPoolMemory to display the current application pool memory.
-SetApplicationPoolMemory <number in MB> to set the private memory limit by the number specified.

Adamj Dirty Database Check Stream
-----------------------------------------------------

From a similar phrase from the movie 'Sleeping With Other People', I coined this stream the
Dirty Database Check. This stream will run a SQL Query that originally came from Microsoft but has been
expanded by me to include all future upgrades of Windows 10. This SQL query checks to see if your
database is 'in a bad state' which is Microsoft's wording but mine sounds a whole lot more fun :)

In addition to checking to see if you have a dirty database, it will fully fix your database
automatically if it is found to be dirty. This again follows Microsoft's methods, but expanded
by me to include all future upgrades of Windows 10.

If your upgrades for Windows 10 are not installing properly and have been approved on your WSUS
server, run this check to see if you have a dirty database and subsequently fix it.

I recommend that this be done manually from the command-line, if you suspect that you may have a
dirty database.

You can use -DirtyDatabaseCheck to run this manually from the command-line.

.NOTES
Name: Clean-WSUS
Author: Adam Marshall
Website: http://www.adamj.org
Donations Accepted: http://www.adamj.org/clean-wsus/donate.html

This script has been tested on Server 2008 SP2, Server 2008 R2, Server 2012, and Server 2012 R2. This script should run
fine on Server 2016 and others have ran it with success on 2016, but I have not had the ability to test it in production.

################################
#      Version History &       #
#        Release Notes         #
################################

Previous Version History - http://www.adamj.org/clean-wsus/release-notes.html

  Version 3.1 to 3.2
 - Bug Fix: Dirty Database Fix SQL Script to 1.1 - Added use SUSDB.
 - Added EULA.

.EXAMPLE
Clean-WSUS -FirstRun
Description: Run the routines that are recommended for running this script for the first time.

.EXAMPLE
Clean-WSUS -InstallTask
Description: Install the Scheduled task to run this script at 8AM daily with the -ScheduledRun switch.

.EXAMPLE
Clean-WSUS -HelpMe
Description: Run the HelpMe stream to create a transcript of the session and provide troubleshooting information in a log file.

.EXAMPLE
Clean-WSUS -DisplayApplicationPoolMemory
Description: Display the current Private Memory Limit for the WSUS Application Pool

.EXAMPLE
Clean-WSUS -SetApplicationPoolMemory 4096
Description: Set the Private Memory Limit for the WSUS Application Pool to 4096 MB (4GB)

.EXAMPLE
Clean-WSUS -SetApplicationPoolMemory 0
Description: Set the Private Memory Limit for the WSUS Application Pool to 0 MB (Unlimited)

.EXAMPLE
Clean-WSUS -DirtyDatabaseCheck
Description: Checks to see if the WSUS database is in a bad state.

.EXAMPLE
Clean-WSUS -DailyRun
Description: Run the recommended daily routines.

.EXAMPLE
Clean-WSUS -MonthlyRun
Description: Run the recommended monthly routines.

.EXAMPLE
Clean-WSUS -QuarterlyRun
Description: Run the recommended quarterly routines.

.EXAMPLE
Clean-WSUS -ScheduledRun
Description: Run the recommended routines on a schedule having the script take care of all timetables.

.EXAMPLE
Clean-WSUS -RemoveWSUSDriversSQL -SaveReport TXT
Description: Only Remove WSUS Drivers by way of SQL and save the output as TXT to the script's folder named with the date and time of execution.

.EXAMPLE
Clean-WSUS -RemoveWSUSDriversPS -MailReport HTML
Description: Only Remove WSUS Drivers by way of PowerShell and email the output as HTML to the configured parties.

.EXAMPLE
Clean-WSUS -RemoveDeclinedWSUSUpdates -CleanUpWSUSSynchronizationLogs -WSUSDBMaintenance -WSUSServerCleanupWizard -SaveReport HTML -MailReport TXT
Description: Remove Declined WSUS Updates, Clean Up WSUS Synchronization Logs based on the configuration variables, Run the SQL Maintenance, and run the Server Cleanup Wizard (SCW) and output to an HTML file in the scripts folder named with the date and time of execution, and then email the report in plain text to the configured parties.

.EXAMPLE
Clean-WSUS -DeclineMultipleTypesOfUpdates -ComputerObjectCleanup -SaveReport TXT -MailReport HTML
Description: Decline superseded updates, computer object cleanup, save the output as TXT to the script's folder, and email the output as HTML to the configured parties.

.EXAMPLE
Clean-WSUS -RemoveObsoleteUpdates -CompressUpdateRevisions -DeclineMultipleTypesOfUpdates -SaveReport TXT -MailReport HTML
Description: Remove Obsolte Updates, Compress Update Revisions, Decline superseded updates, save the output as TXT to the script's folder, and email the output as HTML to the configured parties.

.LINK
http://www.adamj.org
http://community.spiceworks.com/scripts/show/2998-adamj-wsus-cleanup
http://www.adamj.org/clean-wsus/donate.html
#>

################################
#    Script Setup Parameters   #
#                              #
#  DO NOT EDIT!!! SCROLL DOWN  #
#    TO FIND THE VARIABLES     #
#           TO EDIT            #
################################
[CmdletBinding()]
param (
    # Run the routines that are recommended for running this script for the first time.
    [Switch]$FirstRun,
    # Run the troubleshooting HelpMe stream to copy and paste for getting support.
    [Switch]$HelpMe,
    # Run a check on the SUSDB Database to see if you have a bad state (a dirty database).
    [switch]$DirtyDatabaseCheck,
    # Display the Application Pool Memory Limit
    [switch]$DisplayApplicationPoolMemory,
    # Set the Application Pool Memory Limit.
    [ValidateRange(0,[int]::MaxValue)]
    [Int16]$SetApplicationPoolMemory=-1,
    # Run the recommended daily routines.
    [Switch]$DailyRun,
    # Run the recommended monthly routines.
    [Switch]$MonthlyRun,
    # Run the recommended quarterly routines.
    [Switch]$QuarterlyRun,
    # Run the recommended routines on a schedule having the script take care of all timetables.
    [Switch]$ScheduledRun,
    # Remove WSUS Drivers by way of SQL.
    [Switch]$RemoveWSUSDriversSQL,
    # Remove WSUS Drivers by way of PowerShell.
    [Switch]$RemoveWSUSDriversPS,
    # Compress Update Revisions by way of SQL.
    [Switch]$CompressUpdateRevisions,
    # Remove Obsolete Updates by way of SQL.
    [Switch]$RemoveObsoleteUpdates,
    # Remove Declined WSUS Updates.
    [Switch]$RemoveDeclinedWSUSUpdates,
    # Decline Multiple Types of Updates.
    [Switch]$DeclineMultipleTypesOfUpdates,
    # Clean Up WSUS Synchronization Logs based on the configuration variables.
    [Switch]$CleanUpWSUSSynchronizationLogs,
    # Clean Up WSUS Synchronization Logs based on the configuration variables.
    [Switch]$ComputerObjectCleanup,
    # Run the SQL Maintenance.
    [Switch]$WSUSDBMaintenance,
    # Run the Server Cleanup Wizard (SCW) through PowerShell rather than through a GUI.
    [Switch]$WSUSServerCleanupWizard,
    # Run the Server Cleanup Wizard (SCW) through PowerShell rather than through a GUI.
    [Switch]$WSUSIndexOptimization,
    # Install the Scheduled Task for daily @ 8AM.
    [Switch]$InstallTask,
    # Save the output report to a file named the date and time of execute in the script's folder. TXT or HTML are valid output types.
    [ValidateSet("TXT","HTML")]
    [String]$SaveReport,
    # Email the output report to an email address based on the configuration variables. TXT or HTML are valid output types.
    [ValidateSet("TXT","HTML")]
    [String]$MailReport
    )
Begin {
$AdamjCurrentSystemFunctions = Get-ChildItem function:
$AdamjCurrentSystemVariables = Get-Variable
if (-not $DailyRun -and -not $FirstRun -and -not $MonthlyRun -and -not $QuarterlyRun -and -not $ScheduledRun -and -not $HelpMe -and -not $InstallTask) {
    Write-Verbose "Not using a pre-defined routine"
    if (-not ($DisplayApplicationPoolMemory -or $DirtyDatabaseCheck) -and $SetApplicationPoolMemory -eq '-1') {
        Write-Verbose "Not using a using the Application Pool commands or the InstallTask or DirtyDatabaseCheck"
        if ($SaveReport -eq '' -and $MailReport -eq '') {
            Throw "You must use -SaveReport or -MailReport if you are not going to use the pre-defined routines (-FirstRun, -DailyRun, -MonthlyRun, -QuarterlyRun, -ScheduledRun) or the individual switches -HelpMe -DisplayApplicationPoolMemory and -SetApplicationPoolMemory -DirtyDatabaseCheck."
        } else { Write-Verbose "SaveReport or MailReport have been specified. Continuing on." }
    } else { Write-Verbose "`$DisplayApplicationPoolMemory -or `$SetApplicationPoolMemory -or `$DirtyDatabaseCheck were specified."; Write-Verbose "`$SetApplicationPoolMemory is set to $SetApplicationPoolMemory" }
}
Function Test-RegistryValue {
    param(
        [Alias("PSPath")]
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path
        ,
        [Parameter(Position = 1, Mandatory = $true)]
        [String]$Name
        ,
        [Switch]$PassThru
    )
    process {
        if (Test-Path $Path) {
            $Key = Get-Item -LiteralPath $Path
            if ($Key.GetValue($Name, $null) -ne $null) {
                if ($PassThru) {
                    Get-ItemProperty $Path $Name
                } else {
                    $true
                }
            } else {
                $false
            }
        } else {
            $false
        }
    }
}
if ($HelpMe -eq $True) { $AdamjOldVerbose = $VerbosePreference; $VerbosePreference = "continue"; Start-Transcript -Path "$(get-date -f "yyyy.MM.dd-HH.mm.ss")-HelpMe.txt" }

#region Configuration Variables
################################
#    Configuration Variables   #
#     Simple Configuration     #
################################

################################
#  Mail Report Setup Variables #
################################

# From: address for email notifications (it doesn't have to be a real email address, but if you're sending through Gmail it must be
# your Gmail address). Example: 'WSUS@domain.com' or 'email@gmail.com'
[string]$AdamjMailReportEmailFromAddress = 'WSUS@domain.com'

# To: address for email notifications. Example: 'firstname.lastname@domain.com'
[string]$AdamjMailReportEmailToAddress = 'firstname.lastname@domain.com'

# Subject: of the results email
[string]$AdamjMailReportEmailSubject = 'WSUS Cleanup Results'

# Enter your SMTP server name. Example: 'mailserver.domain.local' or 'mail.domain.com' or 'smtp.gmail.com'
# Note Gmail Settings: smtp.gmail.com Port:587 SSL:Enabled User:user@gmail.com Password (if you use 2FA, make an app password).
[string]$AdamjMailReportSMTPServer = 'mail.domain.com'

# Enter your SMTP port number. Example: '25' or '465' (Usually for SSL) or '587' or '1025'
[int32]$AdamjMailReportSMTPPort = '25'

# Do you want to enable SSL communication for your SMTP Server
[boolean]$AdamjMailReportSMTPServerEnableSSL = $False

# Do you need to authenticate to the server? If not, leave blank. Note: if your password includes an apostrophe, use 2 apostrophes so that one escapes the other. eg. 'that''s how'
[string]$AdamjMailReportSMTPServerUsername = ''
[string]$AdamjMailReportSMTPServerPassword = ''

################################
#    Configuration Variables   #
#    Advanced Configuration    #
################################

################################
#  Mail Report or Save Report  #
################################

# Do you want to enable the Mail Report for every run?
[boolean]$AdamjMailReport = $True

# Do you want the mailed report to be in HTML or plain text? (Valid options are 'HTML' or 'TXT')
[string]$AdamjMailReportType = 'HTML'

# Do you want to enable the save report for every run? (-FirstRun will save the report regardless)
[boolean]$AdamjSaveReport = $False

# Do you want the saved report to be outputted in HTML or plain text? (Valid options are 'HTML' or 'TXT')
[string]$AdamjSaveReportType = 'TXT'

################################
#    Decline Multiple Types    #
#     of Updates Variables     #
################################

$AdamjDeclineMultipleTypesOfUpdatesList = @{
'Superseded' = $True #remove superseded updates.
'Expired' = $True #remove updates that have been pulled by Microsoft.
'Preview' = $True #remove preview updates.
'Itanium' = $True #remove updates for Itanium computers.
'LanguagePacks' = $False #remove language packs.
'IE7' = $False #remove updates for old versions of IE (IE7).
'IE8' = $False #remove updates for old versions of IE (IE8).
'IE9' = $False #remove updates for old versions of IE (IE9).
'IE10' = $False #remove updates for old versions of IE (IE10).
'Beta' = $True #Beta products and beta updates.
'Embedded' = $False #Embedded version of Windows.
'NonEnglishUpdates' = $False #some non-English updates are not filtered by WSUS language filtering.
'ComputerUpdates32bit' = $False #remove updates for 32-bit computers.
'WinXP' = $False #remove Windows XP updates.
}

################################
#   Computer Object Cleanup    #
#          Variables           #
################################

# Do you want to remove the computer objects from WSUS that have not synchronized in days?
# This is good to keep your WSUS clean of previously removed computers.
[boolean]$AdamjComputerObjectCleanup = $True

# If the above is set to $True, how many days of no synchronization do you want to remove
# computer objects from the WSUS Server? Set this to 0 to remove all computer objects.
[int]$AdamjComputerObjectCleanupSearchDays = '30'

################################
#  WSUS Server Cleanup Wizard  #
#          Parameters          #
#    Set to $True or $False    #
################################

# Decline updates that have not been approved for 30 days or more, are not currently needed by any clients, and are superseded by an approved update.
[boolean]$AdamjSCWSupersededUpdatesDeclined = $True

# Decline updates that aren't approved and have been expired my Microsoft.
[boolean]$AdamjSCWExpiredUpdatesDeclined = $True

# Delete updates that are expired and have not been approved for 30 days or more.
[boolean]$AdamjSCWObsoleteUpdatesDeleted = $True

# Delete older update revisions that have not been approved for 30 days or more.
[boolean]$AdamjSCWUpdatesCompressed = $True

# Delete computers that have not contacted the server in 30 days or more. Default: $False
# This is taken care of by the Computer Object Cleanup Stream
[boolean]$AdamjSCWObsoleteComputersDeleted = $False

# Delete update files that aren't needed by updates or downstream servers.
[boolean]$AdamjSCWUnneededContentFiles = $True

################################
#   Scheduled Run Variables    #
################################

# On what day do you wish to run the MonthlyRun and QuarterlyRun Stream? I recommend on the 1st-7th of the month.
# This will give enough time for you to approve (if you approve manually) and your computers to receive the
# superseding updates after patch Tuesday (second Tuesday of the month).
# (Valid days are 1-31. February, April, June, September, and November have logic to set to the last day
# of the month if this is set to a number greater than the amount of days in that month, including leap years.)
[int]$AdamjScheduledRunStreamsDay = '1'

# What months would you like to run the QuarterlyRun Stream?
# (Valid months are 1-12, comma separated for multiple months)
[string]$AdamjScheduledRunQuarterlyMonths = '1,4,7,10'

# What time daily do you want to run the script using the scheduled task?
[string]$AdamjScheduledTaskTime = '8:00am'

################################
#        Clean Up WSUS         #
#     Synchronization Logs     #
#           Variables          #
################################

# Clean up the synchronization logs older than a consistency.

# (Valid consistency number are whole numbers.)
[int]$AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber = '14'

# Valid consistency time are 'Day' or 'Month'
[String]$AdamjCleanUpWSUSSynchronizationLogsConsistencyTime = 'Day'

# Or remove all synchronization logs each time
[boolean]$AdamjCleanUpWSUSSynchronizationLogsAll = $False

################################
#     Remove WSUS Drivers      #
#          Variables           #
################################

# Remove WSUS Drivers on -FirstRun
[boolean]$AdamjRemoveWSUSDriversInFirstRun = $True

# Remove WSUS Drivers on -ScheduledRun or -QuaterlyRun
[boolean]$AdamjRemoveWSUSDriversInRoutines = $True


################################
#     SQL Server Variable      #
################################

# The SQL Server Variable is detected automatically whether you are using the Windows Internal Database, a SQL
# Express instance on the same server or remote server, or a full SQL version on the same server or remote server.

# If you are using a Remote SQL connection, you will need to set the Scheduled Task to use the NETWORK SERVICE
# account as the user that runs the script. This will run the script with the computer object's security context
# when accessing resources over the network. As such, the SQL Server will need the computer account added (in
# the format of: DOMAIN\COMPUTER$) with the appropriate permissions (db_dlladmin or db_owner) for the SUSDB
# database. This is the recommended way of doing it.

# An alternative way of doing it would be to run the Scheduled Task as a user account that already has the
# appropriate permissions, saving credentials so that it can pass them through to the SQL Server.

# ONLY uncomment and fill out if you've received explicit instructions from me for support.
#[string]$AdamjSQLServer = 'THIS LINE SHOULD ONLY BE CHANGED WITH EXPLICIT INSTRUCTIONS FROM SUPPORT!'

################################
#     WSUS Setup Variables     #
#  This section auto-detects   #
#      and shouldn't need      #
#        to be modified        #
################################

# FQDN of the WSUS server. Example: 'server.domain.local'
# WSUS does not play well with Aliases or CNAMEs and requires using the FQDN or the HostName
[string]$AdamjWSUSServer = "$((Get-WmiObject win32_computersystem).DNSHostName)" + $(if ((Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain -eq 'True') { ".$((Get-WmiObject win32_computersystem).Domain)" } )

# Use secure connection: $True or $False
[boolean]$AdamjWSUSServerUseSecureConnection = if ($(Test-RegistryValue "HKLM:\Software\Microsoft\Update Services\Server\Setup" "UsingSSL") -eq $True) { if ((Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Update Services\Server\Setup' -Name 'UsingSSL' | Select-Object -ExpandProperty 'UsingSSL') -eq '1') { $True } else { $False } } else { $False }

# What port number are you using for WSUS? Example: '80' or '443' if on Server 2008 or '8530' or '8531' if on Server 2012+
[int32]$AdamjWSUSServerPortNumber = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Update Services\Server\Setup' -Name 'PortNumber' | Select-Object -ExpandProperty 'PortNumber'

################################
#  Install the Scheduled Task  #
#  This section should be left #
#            alone.            #
################################

<#
This script is meant to be run daily. It is not just an ad-hock WSUS cleaning tool but rather
it's a daily maintenance tool. -FirstRun does NOT run all the routines on purpose, and uses certain
switches that SHOULD NOT be used consistently. If you choose to ignore this and switch the
$AdamjInstallScheduledTask variable to $False, please know that you can encounter problems with
WSUS in the future that you can't explain. One should not blame Microsoft for messing up WSUS or not
being able to make a product that works (like so many others have done), but rather blame themselves
for not running the appropriate WSUS Maintenance routines (declining superseded updates, running the
WSUS maintenance SQL script, running the server cleanup wizard, etc), to keep WSUS running smoothly.

For those enterprise environments or environments where you want more control over when this script
runs its streams, I've included the different switches (DailyRun, MonthlyRun, and QuarterlyRun) to be
used on the appropriate schedules. Do not mistake these options as assuming this script should be run
only when you feel it is necessary. For these environments, please set the $AdamjInstallScheduledTask
variable to $False and then manually create at least 3 scheduled tasks to run the -DailyRun,
-MonthlyRun, and -QuarterlyRun switches following the template of -InstallTask's schedule.
#>

# Install the ScheduledTask to Task Scheduler. (Default: $True)
[boolean]$Script:AdamjInstallScheduledTask = $True

################################
# Do not edit below this line  #
################################
}
#endregion

Process {
$AdamjScriptTime = Get-Date
$AdamjWSUSServer = $AdamjWSUSServer.ToLower()
Write-verbose "Set the script's current working directory path"
$AdamjScriptPath = Split-Path $script:MyInvocation.MyCommand.Path
Write-Verbose "`$AdamjScriptPath = $AdamjScriptPath"

#region Test Elevation
function Test-Administrator
{
    $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $CurrentUser).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
Write-Verbose "Testing to see if you are running this from an Elevated PowerShell Prompt."
if ((Test-Administrator) -ne $True -and ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -ne 'NT AUTHORITY\SYSTEM')) {
    Throw "ERROR: You must run this from an Elevated PowerShell Prompt on each WSUS Server in your environment. If this is done through scheduled tasks, you must check the box `"Run with the highest privileges`""
}
else {
    Write-Verbose "Done. You are running this from an Elevated PowerShell Prompt"
}
#endregion Test Elevation

#region Test-IfBlocked
function Test-IfBlocked {
    if ($(Get-Item $($script:MyInvocation.MyCommand.Path) -Stream "Zone.Identifier" -ErrorAction SilentlyContinue) -eq $null) {
        Write-Verbose "Zone.Identifier not found. The file is already unblocked"
    } else {
        Write-Verbose "Zone.Identifier was found. Unblocking File"
        Unblock-File -Path $($script:MyInvocation.MyCommand.Path)
    }
}
Test-IfBlocked
#endregion Test-IfBlocked

if ($HelpMe -eq $True) {
    $Script:HelpMeHeader = @"
=============================
  Clean-WSUS HelpMe Stream
=============================

This is the HelpMe Section for troubleshooting
Please provide this information to get support



"@
    $Script:AdamjScriptVersion = "3.2"
    $Script:HelpMeHeader
    Write-Output 'Starting the connection to the SQL database and WSUS services. Please wait...'
} else {
    Write-Output 'Starting the connection to the SQL database and WSUS services. Please wait...'
}

#region Test SQLConnection
function Test-SQLConnection
{
    param (
        [parameter(Mandatory = $true)][string] $ServerInstance,
        [parameter(Mandatory = $false)][int] $TimeOut = 1
    )

    $SqlConnectionResult = $false

    try
    {
        $SqlCatalog = "SUSDB"
        $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $SqlConnection.ConnectionString = "Server = $ServerInstance; Database = $SqlCatalog; Integrated Security = True; Connection Timeout=$TimeOut"
        $TimeOutVerbage = if ($TimeOut -gt "1") { "seconds" } else { "second" }
        Write-Verbose "Initiating SQL Connection Testing to `'$ServerInstance'` with a timeout of $TimeOut $TimeOutVerbage"
        $SqlConnection.Open()
        Write-Verbose "Connected. Setting `$SqlConnectionResult to $($SqlConnection.State -eq "Open")"
        $SqlConnectionResult = $SqlConnection.State -eq "Open"
    }

    catch
    {
        Write-Output "Connection Failed."
    }

    finally
    {
        $SqlConnection.Close()
    }

    return $SqlConnectionResult
}

if ([string]::isnullorempty($AdamJSQLServer)) {
    Write-Verbose '$AdamjSQLServer has not been specified. Starting autodetection for SQL Instance'
    [string]$AdamjWID2008 = 'np:\\.\pipe\MSSQL$MICROSOFT##SSEE\sql\query'
    [string]$AdamjWID2012Plus = 'np:\\.\pipe\MICROSOFT##WID\tsql\query'
    $AdamjSQLServerName = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Update Services\Server\Setup" -Name "SqlServerName" | Select-Object -ExpandProperty "SqlServerName"
    #$AdamjSQLServerName = "$((Get-WmiObject win32_computersystem).DNSHostName)\MICROSOFT##SSEE" #2008 Testing
    #$AdamjSQLServerName = "$((Get-WmiObject win32_computersystem).DNSHostName)\SQLEXPRESS" #SQLEXPRESS instance Testing
    #$AdamjSQLServerName = "$((Get-WmiObject win32_computersystem).DNSHostName)" #SQL Standard default instance testing
    #$AdamjSQLServerName = "$((Get-WmiObject win32_computersystem).DNSHostName)\NamedWSUSInstance" #SQL Other Named Instance testing
    #$AdamjSQLServerName = "REMOTESERVER" #SQL Remote Server testing
    Write-Verbose "Autodetected `$AdamjSQLServerName as $AdamjSQLServerName"
    if ($AdamjSQLServerName -eq 'MICROSOFT##WID') {
        Write-Verbose 'Setting $AdamjSQLServer for Server 2012+ Windows Internal Database.'
        $AdamjSQLServer = $AdamjWID2012Plus
    } elseif ($AdamjSQLServerName -eq "$((Get-WmiObject win32_computersystem).DNSHostName)\MICROSOFT##SSEE") {
        Write-Verbose 'Setting $AdamjSQLServer for Server 2008 & 2008 R2 Windows Internal Database.'
        $AdamjSQLServer = $AdamjWID2008
    } elseif ($AdamjSQLServerName -eq "$((Get-WmiObject win32_computersystem).DNSHostName)\SQLEXPRESS") {
        Write-Verbose "Setting `$AdamjSQLServer for SQLEXPRESS Instance on the local server - `'$AdamjSQLServerName'."
        $AdamjSQLServer = $AdamjSQLServerName
    } elseif ($AdamjSQLServerName -eq "$((Get-WmiObject win32_computersystem).DNSHostName)") {
        Write-Verbose "Setting `$AdamjSQLServer for SQL Default Instance on the local server - `'$AdamjSQLServerName`'."
        $AdamjSQLServer = $AdamjSQLServerName
    } else {
        Write-Verbose "Setting `$AdamjSQLServer to the remote SQL Instance of: `'$AdamjSQLServerName`'."
        $AdamjSQLServer = $AdamjSQLServerName
        $AdamjSQLServerIsRemote = $True
    }
} else {
    Write-Verbose "You've specified the `$AdamjSQLServer variable as `'$AdamjSQLServer`'."
}
Write-Verbose "Now test that there is a SUSDB database on `'$AdamjSQLServer`' and that we can connect to it."
if ((Test-SQLConnection $AdamjSQLServer 60) -eq $true) {
    Write-Verbose "SQL Server test succeeded. Continuing on."
} else {
    if ($HelpMe -ne $True) {
        #Terminate the script erroring out with a reason.
        #Throw "I've tested the server `'$AdamjSQLServer`' from the configuration but can't connect to that SQL Server Instance. Please check the spelling again. Don't forget to specify the SQL Instance if there is one."
    }
    else {
        Write-Output "I can't connect to the SQL server `'$AdamjSQLServer`', and you've asked for help. Connecting to the WSUS Server to get troubleshooting information."
    }
}
#Create the connection command variable.
$AdamjSQLConnectCommand = "sqlcmd -S $AdamjSQLServer"
#endregion Test SQLConnection

#region Connect to the WSUS Server
function Connect-WSUSServer {
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory = $True)]
        [Alias("Server")]
        [string]$WSUSServer,

        [Parameter(Position=1, Mandatory = $True)]
        [Alias("Port")]
        [int]$WSUSPort,

        [Parameter(Position=2, Mandatory = $True)]
        [Alias("SSL")]
        [boolean]$WSUSEnableSSL
    )
    Write-Verbose "Load .NET assembly"
    [void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration");

    Write-Verbose "Connect to WSUS Server: $WSUSServer"
    $Script:WSUSAdminProxy     = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($WSUSServer,$WSUSEnableSSL,$WSUSPort);
    If ($? -eq $False) {
        if ($HelpMe -ne $True) {
            Throw "ERROR Connecting to the WSUS Server: $WSUSServer. Please check your settings and try again."
        }
        else {
            Write-Output "ERROR Connecting to the WSUS Server: $WSUSServer and you've asked for help. Getting troubleshooting information."
        }
    } else {
            $Script:AdamjConnectedTime = Get-Date
            $Script:AdamjConnectedTXT = "Connected to the WSUS server $AdamjWSUSServer @ $($AdamjConnectedTime.ToString(`"yyyy.MM.dd hh:mm:ss tt zzz`"))`r`n`r`n"
            $Script:AdamjConnectedHTML = "<i>Connected to the WSUS server $AdamjWSUSServer @ $($AdamjConnectedTime.ToString(`"yyyy.MM.dd hh:mm:ss tt zzz`"))</i>`r`n`r`n"
    	    Write-Output "Connected to the WSUS server $AdamjWSUSServer"
    }
}
Write-Verbose 'Do we really need to connect to the WSUS Server? If we do, connect.'
if ((($InstallTask -or $DisplayApplicationPoolMemory -or $WSUSIndexOptimization) -eq $False) -and $SetApplicationPoolMemory -eq '-1') {
    Write-Verbose 'We have a reason to connect. Connecting...'
    Connect-WSUSServer -Server $AdamjWSUSServer -Port $AdamjWSUSServerPortNumber -SSL $AdamjWSUSServerUseSecureConnection
    $AdamjWSUSServerAdminProxy = $Script:WSUSAdminProxy
}
else {
    Write-Verbose 'We do not have a reason to connect. Continuing on without connecting to the WSUS API'
    Write-Verbose "`$SetApplicationPoolMemory is set to $SetApplicationPoolMemory"
}
#endregion Connect to the WSUS Server

#region Get-DiskFree Function
################################
#         Get-DiskFree         #
################################

function Get-DiskFree
# Taken from http://binarynature.blogspot.ca/2010/04/powershell-version-of-df-command.html
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('hostname')]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Position=1,
                   Mandatory=$false)]
        [Alias('runas')]
        [System.Management.Automation.Credential()]$Credential =
        [System.Management.Automation.PSCredential]::Empty,

        [Parameter(Position=2)]
        [switch]$Format
    )

    BEGIN
    {
        function Format-HumanReadable
        {
            param ($size)
            switch ($size)
            {
                {$_ -ge 1PB}{"{0:#.#'P'}" -f ($size / 1PB); break}
                {$_ -ge 1TB}{"{0:#.#'T'}" -f ($size / 1TB); break}
                {$_ -ge 1GB}{"{0:#.#'G'}" -f ($size / 1GB); break}
                {$_ -ge 1MB}{"{0:#.#'M'}" -f ($size / 1MB); break}
                {$_ -ge 1KB}{"{0:#'K'}" -f ($size / 1KB); break}
                default {"{0}" -f ($size) + "B"}
            }
        }
        $wmiq = 'SELECT * FROM Win32_LogicalDisk WHERE Size != Null AND DriveType >= 2'
    }

    PROCESS
    {
        foreach ($computer in $ComputerName)
        {
            try
            {
                if ($computer -eq $env:COMPUTERNAME)
                {
                    $disks = Get-WmiObject -Query $wmiq `
                             -ComputerName $computer -ErrorAction Stop
                }
                else
                {
                    $disks = Get-WmiObject -Query $wmiq `
                             -ComputerName $computer -Credential $Credential `
                             -ErrorAction Stop
                }

                if ($Format)
                {
                    # Create array for $disk objects and then populate
                    $diskarray = @()
                    $disks | ForEach-Object { $diskarray += $_ }

                    $diskarray | Select-Object @{n='Name';e={$_.SystemName}},
                        @{n='Vol';e={$_.DeviceID}},
                        @{n='Size';e={Format-HumanReadable $_.Size}},
                        @{n='Used';e={Format-HumanReadable `
                        (($_.Size)-($_.FreeSpace))}},
                        @{n='Avail';e={Format-HumanReadable $_.FreeSpace}},
                        @{n='Use%';e={[int](((($_.Size)-($_.FreeSpace))`
                        /($_.Size) * 100))}},
                        @{n='FS';e={$_.FileSystem}},
                        @{n='Type';e={$_.Description}}
                }
                else
                {
                    foreach ($disk in $disks)
                    {
                        $diskprops = @{'Volume'=$disk.DeviceID;
                                   'Size'=$disk.Size;
                                   'Used'=($disk.Size - $disk.FreeSpace);
                                   'Available'=$disk.FreeSpace;
                                   'FileSystem'=$disk.FileSystem;
                                   'Type'=$disk.Description
                                   'Computer'=$disk.SystemName;}

                        # Create custom PS object and apply type
                        $diskobj = New-Object -TypeName PSObject `
                                   -Property $diskprops
                        $diskobj.PSObject.TypeNames.Insert(0,'BinaryNature.DiskFree')

                        Write-Output $diskobj
                    }
                }
            }
            catch
            {
                # Check for common DCOM errors and display "friendly" output
                switch ($_)
                {
                    { $_.Exception.ErrorCode -eq 0x800706ba } `
                        { $err = 'Unavailable (Host Offline or Firewall)';
                            break; }
                    { $_.CategoryInfo.Reason -eq 'UnauthorizedAccessException' } `
                        { $err = 'Access denied (Check User Permissions)';
                            break; }
                    default { $err = $_.Exception.Message }
                }
                Write-Warning "$computer - $err"
            }
        }
    }

    END {}
}
#endregion Get-DiskFree Function

#region Setup The Header
################################
#       Setup the Header       #
################################

function CreateAdamjHeader {
$Script:AdamjBodyHeaderTXT = @"
################################
#                              #
#       Adamj Clean-WSUS       #
#         Version 3.2          #
#                              #
#   The last WSUS Script you   #
#        will ever need!       #
#                              #
################################


"@
$Script:AdamjBodyHeaderHTML = @"
    <table style="height: 0px; width: 0px;" border="0">
	    <tbody>
		    <tr>
			    <td colspan="3">
				    <span
						    style="font-family: tahoma,arial,helvetica,sans-serif;">################################</span>
			    </td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td style="text-align: center;">&nbsp;</td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">Adamj Clean-WSUS</span></td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">Version 3.2</span></td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td>&nbsp;</td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">The last WSUS Script you</span></td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">will ever need!</span></td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td style="text-align: left;">#</td>
			    <td>&nbsp;</td>
			    <td style="text-align: right;">#</td>
		    </tr>
		    <tr>
			    <td colspan="3"><span style="font-family: tahoma,arial,helvetica,sans-serif;">################################</span></td>
		    </tr>
	    </tbody>
    </table>
"@
}
#endregion Setup The Header

#region Setup The Footer
################################
#       Setup the Footer       #
################################

function CreateAdamjFooter {
$Script:AdamjBodyFooterTXT = @"

################################
#    End of the WSUS Cleanup   #
################################
#                              #
#         Adam Marshall        #
#     http://www.adamj.org     #
#      Donations Accepted      #
#                              #
#   Latest version available   #
#        from Spiceworks       #
#                              #
################################

http://community.spiceworks.com/scripts/show/2998-adamj-clean-wsus
Donations Accepted: http://www.adamj.org/clean-wsus/donate.html
"@
$Script:AdamjBodyFooterHTML = @"
    <table style="height: 0px; width: 0px;" border="0">
      <tbody>
        <tr>
          <td colspan="3"><span style="font-family: tahoma,arial,helvetica,sans-serif;">################################</span></td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">End of the WSUS Cleanup</span></td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td colspan="3" rowspan="1"><span style="font-family: tahoma,arial,helvetica,sans-serif;">################################</span></td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;">&nbsp;</td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">Adam Marshall</span></td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">http://www.adamj.org</span></td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;"><a href="http://www.adamj.org/clean-wsus/donate.html"><span style="font-family: tahoma,arial,helvetica,sans-serif;">Donations Accepted</span></a></td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td>&nbsp;</td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;"><span style="font-family: tahoma,arial,helvetica,sans-serif;">Latest version available</span></td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td style="text-align: center;"><a href="http://community.spiceworks.com/scripts/show/2998-adamj-clean-wsus"><span style="font-family: tahoma,arial,helvetica,sans-serif;">from Spiceworks</span></a></td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td style="text-align: left;">#</td>
          <td>&nbsp;</td>
          <td style="text-align: right;">#</td>
        </tr>
        <tr>
          <td colspan="3"><span style="font-family: tahoma,arial,helvetica,sans-serif;">################################</span></td>
        </tr>
      </tbody>
    </table>
"@
}
#endregion Setup The Footer

#region Show-My Functions
################################
#   Show-My Functions Stream   #
################################

function Show-MyFunctions { Get-ChildItem function: | Where-Object { $AdamjCurrentSystemFunctions -notcontains $_ } | Format-Table -AutoSize -Property CommandType,Name }
function Show-MyVariables { Get-Variable | Where-Object { $AdamjCurrentSystemVariables -notcontains $_ } | Format-Table }
#endregion Show-My Functions

#region Install-Task Function
################################
#  Install-Task Configuration  #
################################

Function Install-Task {
    Write-Verbose "Enter Install-Task Function"
    $DateNow = Get-Date
    Write-Verbose "`$DateNow is $DateNow"
    if ($Script:AdamjInstallScheduledTask -eq $True -or $InstallTask -eq $True) {
        $PowerShellMajorVersion = $($PSVersionTable.PSVersion.Major)
        $Version = @{}
        $Version.Add("Major", ((Get-CimInstance Win32_OperatingSystem).Version).Split(".")[0])
        $Version.Add("Minor", ((Get-CimInstance Win32_OperatingSystem).Version).Split(".")[1])
        #$Version.Add("Major", "5") # Comment above 2 lines and then uncomment for testing
        #$Version.Add("Minor", "3") # Uncomment for testing
        if ([int]$Version.Get_Item("Major") -ge "7" -or ([int]$Version.Get_Item("Major") -ge "6" -and [int]$Version.Get_Item("Minor") -ge "2")) {
            Write-Verbose "YES - OS Version $([int]$Version.Get_Item("Major")).$([int]$Version.Get_Item("Minor"))"
            $Windows = [PSCustomObject]@{
                Caption = (Get-WmiObject -Class Win32_OperatingSystem).Caption
                Version = [Environment]::OSVersion.Version
            }
            if ($Windows.Version.Major -gt "6") { Write-Verbose "$($Windows.Caption) - Use Win8 Compatibility"; $Compatibility = "Win8" }
            if ($Windows.Version.Major -ge "6" -and $Windows.Version.Minor -ge "2" ) { Write-Verbose "$($Windows.Caption) - Use Win8 Compatibility"; $Compatibility = "Win8" }
            if ($Windows.Version.Major -ge "6" -and $Windows.Version.Minor -eq "1" ) { Write-Verbose "$($Windows.Caption) - Use Win7 Compatibility"; $Compatibility = "Win7" }
            if ($Windows.Version.Major -ge "6" -and $Windows.Version.Minor -eq "0" ) { Write-Verbose "$($Windows.Caption) - Use Vista Compatibility"; $Compatibility = "Vista" }

            $Trigger = New-ScheduledTaskTrigger -At $AdamjScheduledTaskTime -Daily #Trigger the task daily at $AdamjScheduledTaskTime
            $User = "$env:USERDOMAIN\$env:USERNAME"
            if ($AdamjSQLServerIsRemote -eq $True) { $Principal = New-ScheduledTaskPrincipal -UserID 'NT AUTHORITY\SYSTEM' -LogonType ServiceAccount -RunLevel Highest } else { $Principal = New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType S4U -RunLevel Highest }
            $TaskName = "Adamj Clean-WSUS"
            $Description = "This task will run the Adamj Clean-WSUS script with the -ScheduledRun parameter which takes care of everything for you according to my recommendations."
            if ($Script:MyInvocation.MyCommand.Path.Contains(" ") -eq $True) {
                $Action = New-ScheduledTaskAction -Execute "$((Get-Command powershell.exe).Definition)" -Argument "-ExecutionPolicy Bypass -Command `"& `"`"$($script:MyInvocation.MyCommand.Path)`"`"`" -ScheduledRun"
            } else {
                $Action = New-ScheduledTaskAction -Execute "$((Get-Command powershell.exe).Definition)" -Argument "-ExecutionPolicy Bypass `"$($script:MyInvocation.MyCommand.Path) -ScheduledRun`""
            }
            $Settings = New-ScheduledTaskSettingsSet -Compatibility $Compatibility
            Write-Verbose "Register the Scheduled task."
            $Script:AdamjInstallTaskOutput = Register-ScheduledTask -TaskName $TaskName -Description $Description -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal -Force
            if ($AdamjSQLServerIsRemote -eq $True) {
                Write-Verbose "As the SQL Server is remote, we need to give the computer name account db_owner access into SQL"
                $AdamjSQLServerIsRemoteALERT = @"
!!! SECURITY AWARENESS ALERT !!! Your SQL Server is a REMOTE SQL server. In order to run a scheduled task on a remote SQL Server,
the computer object's active directory account [$([Environment]::UserDomainName)\$([Environment]::MachineName)`$] needs to have the db_owner permission on the SUSDB
database on $AdamJSQLServer. Since WSUS is already installed and running, this account is already setup in the SQL Server and already
granted rights inside of the SUSDB database, so all we need to do is add the account to the db_owner role. Unfortunately it
must be db_owner and not the db_ddladmin role.
"@
                $AdamjSQLServerIsRemoteScript = @"
USE [SUSDB]
GO
ALTER ROLE [db_owner] ADD MEMBER [$([Environment]::UserDomainName)\$([Environment]::MachineName)`$];
PRINT 'Successfully added [$([Environment]::UserDomainName)\$([Environment]::MachineName)`$] to the db_owner role of the SUSDB database on $AdamJSQLServer.'
"@
                Write-Verbose "Create a file with the content of the SQLServerIsRemote Script above in the same working directory as this PowerShell script is running."
                $AdamjSQLServerIsRemoteScriptFile = "$AdamjScriptPath\AdamjSQLServerIsRemoteScript.sql"
                $AdamjSQLServerIsRemoteScript | Out-File "$AdamjSQLServerIsRemoteScriptFile"

                # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
                $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
                Write-Verbose "Execute the SQL Script and store the results in a variable."
                $AdamjSQLServerIsRemoteScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjSQLServerIsRemoteScriptFile`" -I")
                Write-Verbose "`$AdamjSQLServerIsRemoteScriptJob = $AdamjSQLServerIsRemoteScriptJobCommand"
                $AdamjSQLServerIsRemoteScriptJob = Start-Job -ScriptBlock $AdamjSQLServerIsRemoteScriptJobCommand
                Wait-Job $AdamjSQLServerIsRemoteScriptJob
                $AdamjSQLServerIsRemoteScriptJobOutput = Receive-Job $AdamjSQLServerIsRemoteScriptJob
                Remove-Job $AdamjSQLServerIsRemoteScriptJob
                Write-Verbose "Remove the SQL Script file."
                Remove-Item "$AdamjSQLServerIsRemoteScriptFile"
                # Setup variables to store the output to be added at the very end of the script for logging purposes.
                $Script:AdamjSQLServerIsRemoteScriptOutputTXT = $AdamjSQLServerIsRemoteALERT -creplace "$","`r`n`r`n"
                $Script:AdamjSQLServerIsRemoteScriptOutputTXT += $AdamjSQLServerIsRemoteScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
            }
        } else {
            Write-Verbose "NO - OS Version $([int]$Version.Get_Item("Major")).$([int]$Version.Get_Item("Minor"))"
            $AdamjManuallyCreateTaskInstructions = @"
You are not using Windows Server 2012 or higher. You will have to manually create the Scheduled Task

To Create a Scheduled Task:

1. Open Task Scheduler and Create a new task (not a basic task)
2. Go to the General Tab:
3. Name: "Adamj Clean-WSUS"
4. Under the section "Security Options" put the dot in "Run whether the user is logged on or not"
5. Check "Do not store password. The task will only have access to local computer resources"
6. Check "Run with highest privileges."
7. Under the section "Configure for" - Choose the OS of the Server (e.g. Server 2012 R2)
8. Go to the Triggers Tab:
9. Click New at the bottom left.
10. Under the section "Settings"
11. Choose Daily. Choose $AdamjScheduledTaskTime
12. Confirm Enabled is checked, Press OK.
13. Go to the Actions Tab:
14. Click New at the bottom left.
15. Action should be "Start a program"
16. The "Program/script" should be set to

        $((Get-Command powershell.exe).Definition)

17. The arguments line should be set to


        $(if ($Script:MyInvocation.MyCommand.Path.Contains(" ") -eq $True) {
                "-ExecutionPolicy Bypass -Command `"& `"`"$($script:MyInvocation.MyCommand.Path)`"`"`" -ScheduledRun"
            } else {
                "-ExecutionPolicy Bypass `"$($script:MyInvocation.MyCommand.Path) -ScheduledRun`""
            })

18. Go to the Settings Tab:
19. Check "Allow task to be run on demand"
20. Click OK
"@
            $AdamjInstallTaskOutput = $AdamjManuallyCreateTaskInstructions
        }
    } else {
        $AdamjInstallTaskOutput = @"
WARNING!!! WARNING!!! WARNING!!! WARNING!!! WARNING!!! WARNING!!!

You've chosen to not install the scheduled task that runs -ScheduledRun daily. THIS SCRIPT
IS MEANT TO BE RUN DAILY as it performs daily tasks that should be performed to keep WSUS
running in tip-top running condition. Since you've chosen not to install the scheduled task,
be sure to schedule manually the -DailyRun, -MonthlyRun, and -QuarterlyRun on an appropriate
schedule. Continuously running -FirstRun manually will NOT keep your WSUS maintained
properly as there are specific differences with -FirstRun. -FirstRun also does NOT run
everything on purpose, and does run streams that should NOT be used consistently.
"@
    }
    $FinishedRunning = Get-Date
    Write-Verbose "`$FinishedRunning is $FinishedRunning"
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    $Duration = "{0:00}:{1:00}:{2:00}:{3:00}:{4:00}" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds, $_.Milliseconds})
    Write-Verbose "Adamj Clean-WSUS Scheduled Task Installation Stream Duration: $Duration"
    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    $Script:AdamjInstallTaskOutputTXT += "Adamj Clean-WSUS Scheduled Task Installation:`r`n`r`n"
    if ($AdamjInstallTaskOutput.GetType().Name -eq "String") {
        $Script:AdamjInstallTaskOutputTXT += $($AdamjInstallTaskOutput.Trim() -creplace '$?',"" -creplace "$","`r`n`r`n")
        $Script:AdamjInstallTaskOutputTXT += $Script:AdamjSQLServerIsRemoteScriptOutputTXT
        Write-Output ""; Write-Output $AdamjInstallTaskOutput
    } else {
        $Script:AdamjInstallTaskOutputTXT += $($AdamjInstallTaskOutput | Select-Object -Property TaskName,State | Format-List | Out-String).Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
        $Script:AdamjInstallTaskOutputTXT += $Script:AdamjSQLServerIsRemoteScriptOutputTXT
        Write-Output $($AdamjInstallTaskOutput | Select-Object -Property TaskName,State | Format-List | Out-String).Trim()
        Write-Output $Script:AdamjSQLServerIsRemoteScriptOutputTXT
    }
    #$Script:AdamjInstallTaskOutputTXT += "`r`nAdamj Clean-WSUS Scheduled Task Installation: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjInstallTaskOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Clean-WSUS Scheduled Task Installation:</span></p>`r`n"
    if ($AdamjInstallTaskOutput.GetType().Name -eq "String") {
    #if ($Script:AdamjInstallScheduledTask -eq $False) { $AdamjInstallTaskOutput = $AdamjInstallTaskOutput -creplace '\r\n', " " } (Not sure if I want to use this or not)
        $Script:AdamjInstallTaskOutputHTML += $AdamjInstallTaskOutput -creplace '\r\n', "<br>`r`n" -creplace '^',"<p>" -creplace '$', "</p>`r`n"
    } else {
        $Script:AdamjInstallTaskOutputHTML += $($AdamjInstallTaskOutput| Select-Object TaskName,State | ConvertTo-Html -Fragment -PreContent "<div id='gridtable'>`r`n" -PostContent "</div>`r`n") #.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
    }
    #$Script:AdamjInstallTaskOutputHTML += $AdamjInstallTaskOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"
    #$Script:AdamjInstallTaskOutputHTML += "`r`n<p>Adamj Clean-WSUS Scheduled Task Installation: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjInstallTaskOutputTXT
    # $AdamjInstallTaskOutputHTML
}
#endregion Install-Task Function

#region DeclineMultipleTypesOfUpdates Function
################################
#    Decline Multiple Types    #
#      of Updates Stream       #
################################

Write-Verbose "Setup the array variables from the user configuration"

$Superseded = New-Object System.Object
$Superseded | Add-Member -type NoteProperty -name Name -Value "Superseded"
$Superseded | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.Superseded)
$Superseded | Add-Member -type NoteProperty -name Syntax -Value '$_.IsSuperseded -eq $True'

$Expired = New-Object System.Object
$Expired | Add-Member -type NoteProperty -name Name -Value "Expired"
$Expired | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.Expired)
$Expired | Add-Member -type NoteProperty -name Syntax -Value '$_.PublicationState -eq "Expired"'

$Preview = New-Object System.Object
$Preview | Add-Member -type NoteProperty -name Name -Value "Preview"
$Preview | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.Preview)
$Preview | Add-Member -type NoteProperty -name Syntax -Value '$_.Title -match "Preview"'

$Itanium = New-Object System.Object
$Itanium | Add-Member -type NoteProperty -name Name -Value "Itanium"
$Itanium | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.Itanium)
$Itanium | Add-Member -type NoteProperty -name Syntax -Value '$_.LegacyName -match "ia64|itanium"'

$LanguagePacks = New-Object System.Object
$LanguagePacks | Add-Member -type NoteProperty -name Name -Value "LanguagePacks"
$LanguagePacks | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.LanguagePacks)
$LanguagePacks | Add-Member -type NoteProperty -name Syntax -Value '$_.Title -match "language\s"'

$IE7 = New-Object System.Object
$IE7 | Add-Member -type NoteProperty -name Name -Value "IE7"
$IE7 | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.IE7)
$IE7 | Add-Member -type NoteProperty -name Syntax -Value '$_.title -match "Internet Explorer 7"'

$IE8 = New-Object System.Object
$IE8 | Add-Member -type NoteProperty -name Name -Value "IE8"
$IE8 | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.IE8)
$IE8 | Add-Member -type NoteProperty -name Syntax -Value '$_.title -match "Internet Explorer 8"'

$IE9 = New-Object System.Object
$IE9 | Add-Member -type NoteProperty -name Name -Value "IE9"
$IE9 | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.IE9)
$IE9 | Add-Member -type NoteProperty -name Syntax -Value '$_.title -match "Internet Explorer 9"'

$IE10 = New-Object System.Object
$IE10 | Add-Member -type NoteProperty -name Name -Value "IE10"
$IE10 | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.IE10)
$IE10 | Add-Member -type NoteProperty -name Syntax -Value '$_.title -match "Internet Explorer 10"'

$Beta = New-Object System.Object
$Beta | Add-Member -type NoteProperty -name Name -Value "Beta"
$Beta | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.Beta)
$Beta | Add-Member -type NoteProperty -name Syntax -Value '$_.Title -match "Beta"'

$Embedded = New-Object System.Object
$Embedded | Add-Member -type NoteProperty -name Name -Value "Embedded"
$Embedded | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.Embedded)
$Embedded | Add-Member -type NoteProperty -name Syntax -Value '$_.title -match "Windows Embedded"'

$NonEnglishUpdates = New-Object System.Object
$NonEnglishUpdates | Add-Member -type NoteProperty -name Name -Value "NonEnglishUpdates"
$NonEnglishUpdates | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.NonEnglishUpdates)
$NonEnglishUpdates | Add-Member -type NoteProperty -name Syntax -Value '$_.title -match "Japanese" -or $_.title -match "Korean" -or $_.title -match "Taiwan"'

$ComputerUpdates32bit = New-Object System.Object
$ComputerUpdates32bit | Add-Member -type NoteProperty -name Name -Value "ComputerUpdates32bit"
$ComputerUpdates32bit | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.ComputerUpdates32bit)
$ComputerUpdates32bit | Add-Member -type NoteProperty -name Syntax -Value '$_.LegacyName -match "x86"'

$WinXP = New-Object System.Object
$WinXP | Add-Member -type NoteProperty -name Name -Value "WinXP"
$WinXP | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.WinXP)
$WinXP | Add-Member -type NoteProperty -name Syntax -Value '$_.LegacyName -match "XP" -or $_.producttitles -match "XP"'

$SharepointUpdates = New-Object System.Object
$SharepointUpdates | Add-Member -type NoteProperty -name Name -Value "SharepointUpdates"
$SharepointUpdates | Add-Member -type NoteProperty -name Decline -Value $($AdamjDeclineMultipleTypesOfUpdatesList.SharepointUpdates)
$SharepointUpdates | Add-Member -type NoteProperty -name Syntax -Value '$_.IsApproved -and $_.Title -match "SharePoint"'

Write-Verbose "Create the array from all of the objects"
$TypesList = @()
$TypesList += $Superseded,$Expired, $Preview, $Itanium, $LanguagePacks, $IE7, $IE8, $IE9, $IE10, $Beta, $Embedded, $NonEnglishUpdates, $ComputerUpdates32bit, $WinXP

function DeclineMultipleTypesOfUpdates {
    param (
    [Switch]$Force
    )
    # Log the date first
    $DateNow = Get-Date
    Write-Output "Adamj Decline Multiple Types of Updates Stream"
    Write-Output ""
    Write-Verbose "Create an update scope"
    $UpdateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
    #$UpdateScope.ApprovedStates = "Any"
    Write-Verbose "Let's grab all the updates on the server and stick them into a variable so we don't have to keep querying the database."
    $AllUpdatesList = $AdamjWSUSServerAdminProxy.GetUpdates($UpdateScope)
    $AdamjScheduledRunStreamsDayEnglish = $(
        if ($AdamjScheduledRunStreamsDay -eq $DateNow.Day -or $FirstRun -eq $True) { "today" }
        else {
            if ($AdamjScheduledRunStreamsDay -eq '1') {
                "on the $AdamjScheduledRunStreamsDay" + "st"
            } elseif ($AdamjScheduledRunStreamsDay -eq '2') {
                "on the $AdamjScheduledRunStreamsDay" + "nd"
            } elseif ($AdamjScheduledRunStreamsDay -eq '3') {
                "on the $AdamjScheduledRunStreamsDay" + "rd"
            } else {
                "on the $AdamjScheduledRunStreamsDay" + "th"
            }
        }
    )
    Write-Output "There are $($AllUpdatesList.Count) updates in this server's database."
    $AdamjDeclineMultipleTypesOfUpdatesOutputTXT = "There are $($AllUpdatesList.Count) updates in this server's database.`r`n"
    $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "<p>There are $($AllUpdatesList.Count) updates in this server's database.<br />`r`n"
    Write-Output "There are $($TypesList.Count) types of updates that we're going to deal with $($AdamjScheduledRunStreamsDayEnglish):"
    $AdamjDeclineMultipleTypesOfUpdatesOutputTXT = "There are $($TypesList.Count) types of updates that we're going to deal with $($AdamjScheduledRunStreamsDayEnglish):`r`n`r`n"
    $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "There are $($TypesList.Count) types of updates that we're going to deal with $($AdamjScheduledRunStreamsDayEnglish):</p>`r`n`r`n"
    $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "<ol>`r`n"
    Write-Output ""
    $TypesList | ForEach-Object -Begin { $I=0 } -Process {
        $I = $I+1
        Write-Progress -Id 1 -Activity "Running through Decline Multiple Types Of Updates Stream" -Status "Currently Counting" -CurrentOperation "$($_.Name) updates" -PercentComplete ($I/$TypesList.count*100) -ParentId -1
        $TypesList_ = $_
        if ($_.Decline -eq $True) {
            Write-Verbose "On this iteration We are going to deal with: $($_.Name)."
            Write-Verbose "Let's query the `$AllUpdatesList which has the scope of `"$($UpdateScope.ApprovedStates)`" and store the results into a variable that we are going to work with."
            $TargetListConditions = "`$_.IsDeclined -eq `$False -and $($_.Syntax)"
            $TargetList = $AllUpdatesList | Where-Object { Invoke-Expression $TargetListConditions }
            if ($Force -eq $True -or $AdamjScheduledRunStreamsDay -eq $DateNow.Day) {
                Write-Output "$($I). $($_.Name): Displaying the titles of the $($_.Name) updates that have been declined:"
                $AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "$($I). $($_.Name): Displaying the titles of the $($_.Name) updates that have been declined:`r`n"
                $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t<li>$($_.Name): Displaying the titles of the $($_.Name) updates that have been declined:</li>`r`n"
                if ($TargetList.Count -ne 0) {
                $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t<ol>`r`n"
                    $Count=0
                    $TargetList | ForEach-Object -Begin { $J=0 } -Process {
                        $J = $J+1
                        Write-Progress -Id 2 -Activity "Declining $($TypesList_.Name) updates" -Status "Progress" -PercentComplete ($J/$TargetList.Count*100) -ParentId 1
                        $Count++
                        Write-Output "`t$($Count). $($_.Title) - https://support.microsoft.com/en-us/kb/$($_.KnowledgebaseArticles)"
                        $AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "`t$($Count). $($_.Title) - https://support.microsoft.com/en-us/kb/$($_.KnowledgebaseArticles)`r`n"
                        $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t`t<li><a href=`"https://support.microsoft.com/en-us/kb$($_.KnowledgebaseArticles)`">$($_.Title)</a></li>`r`n"
                        $_.Decline()
                    }
                    Write-Progress -Id 2 -Activity "Declining $($TypesList_.Name) updates" -Completed
                } else {
                    Write-Output "`t$($_.Name) has no updates to decline."
                    $AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "`t$($_.Name) has no updates to decline.`r`n"
                    $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t<ol>`r`n`t`t<li>$($_.Name) has no updates to decline.</li>`r`n"
                    }
                $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t</ol>`r`n"
                Write-Progress -Id 2 -Activity "Declining $($TypesList_.Name) updates" -Completed
            } else {
                Write-Verbose "It is NOT THE streams day - Just Count it."
                Write-Output "$($I). $($_.Name): $($TargetList.Count)"
                $AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "$($I). $($_.Name): $($TargetList.Count)`r`n"
                $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t<li>$($_.Name): $($TargetList.Count)</li>`r`n"
                #Write-Output "There are currently updates to decline for."
            }
        } else {
            Write-Output "$($I). $($_.Name): Skipped"
            $AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "$($I). $($_.Name): Skipped`r`n"
            $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "`t<li>$($_.Name): Skipped</li>`r`n"
        }
        Write-Progress -Id 1 -Activity "Running through Decline Multiple Types Of Updates Stream" -Completed -ParentId -1
    }
    $AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "</ol>`r`n`r`n"
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    Write-Output ""
    $Output = "Decline Multiple Types of Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Output
    $Script:AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "Adamj Decline Multiple Types of Updates Stream:`r`n`r`n"
    $Script:AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Decline Multiple Types of Updates Stream:</span></p>`r`n`r`n"
    $Script:AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "$AdamjDeclineMultipleTypesOfUpdatesOutputTXT`r`n"
    $Script:AdamjDeclineMultipleTypesOfUpdatesOutputHTML += $AdamjDeclineMultipleTypesOfUpdatesOutputHTML
    $Script:AdamjDeclineMultipleTypesOfUpdatesOutputTXT += "Decline Multiple Types of Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjDeclineMultipleTypesOfUpdatesOutputHTML += "<p>Decline Multiple Types of Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
}
#endregion DeclineMultipleTypesOfUpdates Function

#region ApplicationPoolMemory Function
################################
#   Application Pool Memory    #
#     Configuration Stream     #
################################
function ApplicationPoolMemory {
    Param(
    [ValidateRange(0,[int]::MaxValue)]
    [Int]$Set=-1
    )
    Write-Verbose "`$Set is set to $Set"
    $DateNow = Get-Date
    Import-Module WebAdministration
    $applicationPoolsPath = "/system.applicationHost/applicationPools"
    $applicationPools = Get-WebConfiguration $applicationPoolsPath
    foreach ($appPool in $applicationPools.Collection) {
	    if ($appPool.name -eq 'WsusPool') {
		    $appPoolPath = "$applicationPoolsPath/add[@name='$($appPool.Name)']"
		    $CurrentPrivateMemory = (Get-WebConfiguration "$appPoolPath/recycling/periodicRestart/@privateMemory").Value
            Write-Output "Current Private Memory Limit for $($appPool.name) is: $($CurrentPrivateMemory/1000) MB"
            if ($set -ne '-1') {
                Write-Verbose "Setting the private memory limit to $Set MB"
                $Set=$Set * 1000
                Write-Verbose "Setting the primary memory limit to $Set Bytes"
                $NewPrivateMemory = $Set
                Write-Output "New Private Memory Limit for $($appPool.name) is: $($NewPrivateMemory/1000) MB"
                Set-WebConfiguration "$appPoolPath/recycling/periodicRestart/@privateMemory" -Value $NewPrivateMemory
                Write-Verbose "Restart the $($appPool.name) Application Pool to make the new settings take effect"
                Restart-WebAppPool -Name $($appPool.name)
            }
	    }
    }
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    $Duration = "{0:00}:{1:00}:{2:00}:{3:00}:{4:00}" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds, $_.Milliseconds})
    Write-Verbose "Application Pool Memory Stream Duration: $Duration"
}
#endregion ApplicationPoolMemory Function

#region RemoveWSUSDrivers Function
################################
#   Adamj Remove WSUS Drivers  #
#           Stream             #
################################

function RemoveWSUSDrivers {
    param (
        [Parameter()]
        [Switch] $SQL
    )
    function RemoveWSUSDriversSQL {
        $AdamjRemoveWSUSDriversSQLScript = @"
/*
################################
#   Adamj WSUS Delete Drivers  #
#         SQL Script           #
#       Version 1.0            #
#  Taken from various sources  #
#      from the Internet.      #
#                              #
#  Modified By: Adam Marshall  #
#     http://www.adamj.org     #
################################

-- Originally taken from http://www.flexecom.com/how-to-delete-driver-updates-from-wsus-3-0/
-- Modified to be dynamic and more of a nice output
*/
USE SUSDB;
GO

SET NOCOUNT ON;
DECLARE @tbrevisionlanguage nvarchar(255)
DECLARE @tbProperty nvarchar(255)
DECLARE @tbLocalizedPropertyForRevision nvarchar(255)
DECLARE @tbFileForRevision nvarchar(255)
DECLARE @tbInstalledUpdateSufficientForPrerequisite nvarchar(255)
DECLARE @tbPreRequisite nvarchar(255)
DECLARE @tbDeployment nvarchar(255)
DECLARE @tbXml nvarchar(255)
DECLARE @tbPreComputedLocalizedProperty nvarchar(255)
DECLARE @tbDriver nvarchar(255)
DECLARE @tbFlattenedRevisionInCategory nvarchar(255)
DECLARE @tbRevisionInCategory nvarchar(255)
DECLARE @tbMoreInfoURLForRevision nvarchar(255)
DECLARE @tbRevision nvarchar(255)
DECLARE @tbUpdateSummaryForAllComputers nvarchar(255)
DECLARE @tbUpdate nvarchar(255)
DECLARE @var1 nvarchar(255)

/*
This query gives you the GUID that you will need to substitute in all subsequent queries. In my case, it is
D2CB599A-FA9F-4AE9-B346-94AD54EE0629. I saw this GUID in several WSUS databases so I think it does not change;
at least not between WSUS 3.0 SP2 servers. Either way, we are setting a variable for this so this will
dynamically reference the correct GUID.
*/

SELECT @var1 = UpdateTypeID FROM tbUpdateType WHERE Name = 'Driver'

/*
The bad news is that WSUS database has over 100 tables. The good news is that SQL allows to enforce referential
integrity in data model designs, which in this case can be used to essentially reverse engineer a procedure,
that as far as I know isn't documented anywhere.

The trick is to delete all driver type records from tbUpdate table - but FIRST we have to delete all records in
all other tables (revisions, languages, dependencies, files, reports...), which refer to driver rows in tbUpdate.

Here's how this is done, in 16 tables/queries.
*/

delete from tbrevisionlanguage where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbrevisionlanguage = @@ROWCOUNT
PRINT 'Delete records from tbrevisionlanguage: ' + @tbrevisionlanguage

delete from tbProperty where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbProperty = @@ROWCOUNT
PRINT 'Delete records from tbProperty: ' + @tbProperty

delete from tbLocalizedPropertyForRevision where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbLocalizedPropertyForRevision = @@ROWCOUNT
PRINT 'Delete records from tbLocalizedPropertyForRevision: ' + @tbLocalizedPropertyForRevision

delete from tbFileForRevision where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbFileForRevision = @@ROWCOUNT
PRINT 'Delete records from tbFileForRevision: ' + @tbFileForRevision

delete from tbInstalledUpdateSufficientForPrerequisite where prerequisiteid in (select Prerequisiteid from tbPreRequisite where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1)))
SELECT @tbInstalledUpdateSufficientForPrerequisite = @@ROWCOUNT
PRINT 'Delete records from tbInstalledUpdateSufficientForPrerequisite: ' + @tbInstalledUpdateSufficientForPrerequisite

delete from tbPreRequisite where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbPreRequisite = @@ROWCOUNT
PRINT 'Delete records from tbPreRequisite: ' + @tbPreRequisite

delete from tbDeployment where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbDeployment = @@ROWCOUNT
PRINT 'Delete records from tbDeployment: ' + @tbDeployment

delete from tbXml where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbXml = @@ROWCOUNT
PRINT 'Delete records from tbXml: ' + @tbXml

delete from tbPreComputedLocalizedProperty where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbPreComputedLocalizedProperty = @@ROWCOUNT
PRINT 'Delete records from tbPreComputedLocalizedProperty: ' + @tbPreComputedLocalizedProperty

delete from tbDriver where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbDriver = @@ROWCOUNT
PRINT 'Delete records from tbDriver: ' + @tbDriver

delete from tbFlattenedRevisionInCategory where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbFlattenedRevisionInCategory = @@ROWCOUNT
PRINT 'Delete records from tbFlattenedRevisionInCategory: ' + @tbFlattenedRevisionInCategory

delete from tbRevisionInCategory where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbRevisionInCategory = @@ROWCOUNT
PRINT 'Delete records from tbRevisionInCategory: ' + @tbRevisionInCategory

delete from tbMoreInfoURLForRevision where revisionid in (select revisionid from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1))
SELECT @tbMoreInfoURLForRevision = @@ROWCOUNT
PRINT 'Delete records from tbMoreInfoURLForRevision: ' + @tbMoreInfoURLForRevision

delete from tbRevision where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1)
SELECT @tbRevision = @@ROWCOUNT
PRINT 'Delete records from tbRevision: ' + @tbRevision

delete from tbUpdateSummaryForAllComputers where LocalUpdateId in (select LocalUpdateId from tbUpdate where UpdateTypeID = @var1)
SELECT @tbUpdateSummaryForAllComputers = @@ROWCOUNT
PRINT 'Delete records from tbUpdateSummaryForAllComputers: ' + @tbUpdateSummaryForAllComputers

PRINT CHAR(13)+CHAR(10) + 'This is the last query and this is really what we came here for.'

delete from tbUpdate where UpdateTypeID = @var1
SELECT @tbUpdate = @@ROWCOUNT
PRINT 'Delete records from tbUpdate: ' + @tbUpdate

/*
If at this point you get an error saying something about foreign key constraint, that will be most likely
due to the difference between which reports I ran in my WSUS installation and which reports were ran against
your particular installation. Fortunately, the error gives you exact location (table) where this constraint
is violated, so you can adjust one of the queries in the batch above to delete references in any other tables.
*/
"@
        Write-Verbose "Create a file with the content of the RemoveWSUSDrivers Script above in the same working directory as this PowerShell script is running."
        $AdamjRemoveWSUSDriversSQLScriptFile = "$AdamjScriptPath\AdamjRemoveWSUSDrivers.sql"
        $AdamjRemoveWSUSDriversSQLScript | Out-File "$AdamjRemoveWSUSDriversSQLScriptFile"
        # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
        $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
        Write-Verbose "Execute the SQL Script and store the results in a variable."
        $AdamjRemoveWSUSDriversSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjRemoveWSUSDriversSQLScriptFile`" -I")
        Write-Verbose "`$AdamjRemoveWSUSDriversSQLScriptJobCommand = $AdamjRemoveWSUSDriversSQLScriptJobCommand"
        $AdamjRemoveWSUSDriversSQLScriptJob = Start-Job -ScriptBlock $AdamjRemoveWSUSDriversSQLScriptJobCommand
        Wait-Job $AdamjRemoveWSUSDriversSQLScriptJob
        $AdamjRemoveWSUSDriversSQLScriptJobOutput = Receive-Job $AdamjRemoveWSUSDriversSQLScriptJob
        Remove-Job $AdamjRemoveWSUSDriversSQLScriptJob
        Write-Verbose "Remove the SQL Script file."
        Remove-Item "$AdamjRemoveWSUSDriversSQLScriptFile"
        $Script:AdamjRemoveWSUSDriversSQLOutputTXT = $AdamjRemoveWSUSDriversSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n`r`n"
        $Script:AdamjRemoveWSUSDriversSQLOutputHTML = $AdamjRemoveWSUSDriversSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"

        # Variables Output
        # $AdamjRemoveWSUSDriversSQLOutputTXT
        # $AdamjRemoveWSUSDriversSQLOutputHTML

    }
    function RemoveWSUSDriversPS {
        $Count = 0
        $AdamjWSUSServerAdminProxy.GetUpdates() | Where-Object { $_.IsDeclined -eq $true -and $_.UpdateClassificationTitle -eq "Drivers" } | ForEach-Object {
            # Delete these updates
            $AdamjWSUSServerAdminProxy.DeleteUpdate($_.Id.UpdateId.ToString())
            $DeleteDeclinedDriverTitle = $_.Title
            $Count++
            $AdamjRemoveWSUSDriversPSDeleteOutputTXT += "$($Count). $($DeleteDeclinedDriverTitle)`n`n"
            $AdamjRemoveWSUSDriversPSDeleteOutputHTML += "<li>$DeleteDeclinedDriverTitle</li>`n"
        }
        $AdamjRemoveWSUSDriversPSDeleteOutputTXT += "`n`n"
        $AdamjRemoveWSUSDriversPSDeleteOutputHTML += "</ol>`n"

        $Script:AdamjRemoveWSUSDriversPSOutputTXT += "`n`n"
        $Script:AdamjRemoveWSUSDriversPSOutputHTML += "<ol>`n"
        $Script:AdamjRemoveWSUSDriversPSOutputTXT += $AdamjRemoveWSUSDriversPSDeleteOutputTXT
        $Script:AdamjRemoveWSUSDriversPSOutputHTML += $AdamjRemoveWSUSDriversPSDeleteOutputHTML

        # Variables Output
        # $AdamjRemoveWSUSDriversPSOutputTXT
        # $AdamjRemoveWSUSDriversPSOutputHTML
    }
    # Process the appropriate internal function
    $DateNow = Get-Date
    if ($SQL -eq $True) { RemoveWSUSDriversSQL } else { RemoveWSUSDriversPS }
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    # Create the output for the RemoveWSUSDrivers function
    $Script:AdamjRemoveWSUSDriversOutputTXT += "Adamj Remove WSUS Drivers:`n`n"
    $Script:AdamjRemoveWSUSDriversOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Remove WSUS Drivers:</span></p>`n"
    if ($SQL -eq $True) {
        $Script:AdamjRemoveWSUSDriversOutputTXT += $AdamjRemoveWSUSDriversSQLOutputTXT
        $Script:AdamjRemoveWSUSDriversOutputHTML += $AdamjRemoveWSUSDriversSQLOutputHTML
    } else {
        $Script:AdamjRemoveWSUSDriversOutputTXT += $AdamjRemoveWSUSDriversPSOutputTXT
        $Script:AdamjRemoveWSUSDriversOutputHTML += $AdamjRemoveWSUSDriversPSOutputHTML
    }
    $Script:AdamjRemoveWSUSDriversOutputTXT += "Remove WSUS Drivers Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjRemoveWSUSDriversOutputHTML += "<p>Remove WSUS Drivers Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjRemoveWSUSDriversOutputTXT
    # $AdamjRemoveWSUSDriversOutputHTML
}
#endregion RemoveWSUSDrivers Function

#region WSUSIndexOptimization Function
################################
#       Adamj WSUS Index       #
#     Optimization Stream      #
################################

function WSUSIndexOptimization {
    Param (
    )
  $DateNow = Get-Date
  $AdamjWSUSIndexOptimizationSQLScript = @"
USE [SUSDB]
GO
/****** Object:  Index [Adamj_IX_TargetGroupTypeID_LastChangeNumber_UpdateType]    Script Date: 2017-06-05 17:22:17 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_TargetGroupTypeID_LastChangeNumber_UpdateType' AND object_id = OBJECT_ID('[dbo].[tbDeadDeployment]'))
    BEGIN
        PRINT 'Adamj_IX_TargetGroupTypeID_LastChangeNumber_UpdateType on [dbo].[tbDeadDeployment] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_TargetGroupTypeID_LastChangeNumber_UpdateType] ON [dbo].[tbDeadDeployment]
        (
	        [TargetGroupTypeID] ASC,
	        [LastChangeNumber] ASC,
	        [UpdateType] ASC
        )
        INCLUDE ( 	[TargetGroupID],
	        [UpdateID],
	        [RevisionNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_TargetGroupTypeID_LastChangeNumber_UpdateType on [dbo].[tbDeadDeployment] already created. No changes made.'
	END
/****** Object:  Index [Adamj_IX_RevisionID_ActionID_DeploymentStatus___UpdateType]    Script Date: 2017-06-05 17:22:40 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_RevisionID_ActionID_DeploymentStatus___UpdateType' AND object_id = OBJECT_ID('[dbo].[tbDeployment]'))
    BEGIN
        PRINT 'Adamj_IX_RevisionID_ActionID_DeploymentStatus___UpdateType on [dbo].[tbDeployment] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_RevisionID_ActionID_DeploymentStatus___UpdateType] ON [dbo].[tbDeployment]
        (
	        [RevisionID] ASC,
	        [ActionID] ASC,
	        [DeploymentStatus] ASC
        )
        INCLUDE ( 	[UpdateType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_RevisionID_ActionID_DeploymentStatus___UpdateType on [dbo].[tbDeployment] already created. No changes made.'
	END
/****** Object:  Index [Adamj_IX_ActualState]    Script Date: 2017-06-05 17:27:34 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_ActualState' AND object_id = OBJECT_ID('[dbo].[tbFileOnServer]'))
    BEGIN
        PRINT 'Adamj_IX_ActualState on [dbo].[tbFileOnServer] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_ActualState] ON [dbo].[tbFileOnServer]
        (
	        [ActualState] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_ActualState on [dbo].[tbFileOnServer] already created. No changes made.'
	END
/****** Object:  Index [Adamj_IX_LocalizedPropertyID]    Script Date: 2017-06-05 17:28:14 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_LocalizedPropertyID' AND object_id = OBJECT_ID('[dbo].[tbLocalizedProperty]'))
    BEGIN
        PRINT 'Adamj_IX_LocalizedPropertyID on [dbo].[tbLocalizedProperty] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_LocalizedPropertyID] ON [dbo].[tbLocalizedProperty]
        (
	        [LocalizedPropertyID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_LocalizedPropertyID on [dbo].[tbLocalizedProperty] already created. No changes made.'
	END
/****** Object:  Index [Adamj_IX_LocalizedPropertyID]    Script Date: 2017-06-05 17:28:38 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_LocalizedPropertyID' AND object_id = OBJECT_ID('[dbo].[tbLocalizedPropertyForRevision]'))
    BEGIN
        PRINT 'Adamj_IX_LocalizedPropertyID on [dbo].[tbLocalizedPropertyForRevision] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_LocalizedPropertyID] ON [dbo].[tbLocalizedPropertyForRevision]
        (
	        [LocalizedPropertyID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_LocalizedPropertyID on [dbo].[tbLocalizedPropertyForRevision] already created. No changes made.'
	END
/****** Object:  Index [Adamj_IX_RowID_RevisionID]    Script Date: 2017-06-05 17:29:12 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_RowID_RevisionID' AND object_id = OBJECT_ID('[dbo].[tbRevision]'))
    BEGIN
        PRINT 'Adamj_IX_RowID_RevisionID on [dbo].[tbRevision] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_RowID_RevisionID] ON [dbo].[tbRevision]
        (
	        [RowID] ASC,
	        [RevisionID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_RowID_RevisionID on [dbo].[tbRevision] already created. No changes made.'
	END
/****** Object:  Index [Adamj_IX_SupersededUpdateID]    Script Date: 2017-06-05 17:29:42 ******/
IF NOT EXISTS(SELECT * FROM sys.indexes WHERE name = 'Adamj_IX_SupersededUpdateID' AND object_id = OBJECT_ID('[dbo].[tbRevisionSupersedesUpdate]'))
    BEGIN
        PRINT 'Adamj_IX_SupersededUpdateID on [dbo].[tbRevisionSupersedesUpdate] doesn''t exist. Creating...'
        CREATE NONCLUSTERED INDEX [Adamj_IX_SupersededUpdateID] ON [dbo].[tbRevisionSupersedesUpdate]
        (
	        [SupersededUpdateID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
        PRINT 'Done.'
    END
ELSE
	BEGIN
		PRINT 'Adamj_IX_SupersededUpdateID on [dbo].[tbRevisionSupersedesUpdate] already created. No changes made.'
	END
"@
    Write-Verbose "Create a file with the content of the WSUSIndexOptimization Script above in the same working directory as this PowerShell script is running."
    $AdamjWSUSIndexOptimizationSQLScriptFile = "$AdamjScriptPath\AdamjWSUSIndexOptimization.sql"
    $AdamjWSUSIndexOptimizationSQLScript | Out-File "$AdamjWSUSIndexOptimizationSQLScriptFile"

    # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
    $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
    Write-Verbose "Execute the SQL Script and store the results in a variable."
    $AdamjWSUSIndexOptimizationSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjWSUSIndexOptimizationSQLScriptFile`" -I")
    Write-Verbose "`$AdamjWSUSIndexOptimizationSQLScriptJob = $AdamjWSUSIndexOptimizationSQLScriptJobCommand"
    $AdamjWSUSIndexOptimizationSQLScriptJob = Start-Job -ScriptBlock $AdamjWSUSIndexOptimizationSQLScriptJobCommand
    Wait-Job $AdamjWSUSIndexOptimizationSQLScriptJob
    $AdamjWSUSIndexOptimizationSQLScriptJobOutput = Receive-Job $AdamjWSUSIndexOptimizationSQLScriptJob
    Remove-Job $AdamjWSUSIndexOptimizationSQLScriptJob
    Write-Verbose "Remove the SQL Script file."
    Remove-Item "$AdamjWSUSIndexOptimizationSQLScriptFile"
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    $Script:AdamjWSUSIndexOptimizationOutputTXT += "Adamj WSUS Index Optimization:`r`n`r`n"
    $Script:AdamjWSUSIndexOptimizationOutputTXT += $AdamjWSUSIndexOptimizationSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
    $Script:AdamjWSUSIndexOptimizationOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj WSUS Index Optimization:</span></p>`n`n"
    $Script:AdamjWSUSIndexOptimizationOutputHTML += $AdamjWSUSIndexOptimizationSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"
    $Script:AdamjWSUSIndexOptimizationOutputTXT += "Adamj WSUS Index Optimization Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjWSUSIndexOptimizationOutputHTML += "<p>Adamj WSUS Index Optimization Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjWSUSIndexOptimizationOutputTXT
    # $AdamjWSUSIndexOptimizationOutputHTML
}
#endregion WSUSIndexOptimization Function

#region RemoveDeclinedWSUSUpdates Function
################################
#  Adamj Remove Declined WSUS  #
#       Updates Stream         #
################################

function RemoveDeclinedWSUSUpdates {
    param (
    [Switch]$Display,
    [Switch]$Proceed
    )
    # Log the date first
    $DateNow = Get-Date
    Write-Verbose "Create an update scope"
    $UpdateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
    Write-Verbose "By default the update scope is created for any approval states"
    $UpdateScope.ApprovedStates = "Any"
    Write-Verbose "Get all updates that are Declined"
    $AdamjRemoveDeclinedWSUSUpdatesUpdates = $AdamjWSUSServerAdminProxy.GetUpdates($UpdateScope) | Where { ($_.isDeclined) }
    function RemoveDeclinedWSUSUpdatesCountUpdates {
        Write-Verbose "First count how many updates will be removed that are already declined updates - just for fun. I like fun :)"
        $Script:AdamjRemoveDeclinedWSUSUpdatesCountUpdatesCount = "{0:N0}" -f $AdamjRemoveDeclinedWSUSUpdatesUpdates.Count
        $Script:AdamjRemoveDeclinedWSUSUpdatesCountUpdatesOutputTXT += "The number of declined updates that would be removed from the database are: $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesCount.`r`n`r`n"
        $Script:AdamjRemoveDeclinedWSUSUpdatesCountUpdatesOutputHTML += "<p>The number of declined updates that would be removed from the database are: $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesCount.</p>`n"

         # Variables Output
         # $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesOutputTXT
         # $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesOutputHTML
    }

    function RemoveDeclinedWSUSUpdatesDisplayUpdates {
        Write-Verbose "Display the titles of the declined updates that will be removed from the database - just for fun. I like fun :)"
        $Script:AdamjRemoveDeclinedWSUSUpdatesDisplayOutputHTML += "<ol>`n"
        $Count=0
        ForEach ($update in $AdamjRemoveDeclinedWSUSUpdatesUpdates) {
            $Count++
            $Script:AdamjRemoveDeclinedWSUSUpdatesDisplayOutputTXT += "$($Count). $($update.title) - https://support.microsoft.com/en-us/kb/$($update.KnowledgebaseArticles)`r`n"
            $Script:AdamjRemoveDeclinedWSUSUpdatesDisplayOutputHTML += "<li><a href=`"https://support.microsoft.com/en-us/kb/$($update.KnowledgebaseArticles)`">$($update.title)</a></li>`n"
        }
        $Script:AdamjRemoveDeclinedWSUSUpdatesDisplayOutputTXT += "`r`n"
        $Script:AdamjRemoveDeclinedWSUSUpdatesDisplayOutputHTML += "</ol>`n"

        # Variables Output
        # $AdamjRemoveDeclinedWSUSUpdatesDisplayOutputTXT
        # $AdamjRemoveDeclinedWSUSUpdatesDisplayOutputHTML
    }

    function RemoveDeclinedWSUSUpdatesProceed {
        Write-Output "You've chosen to remove declined updates from the database. Removing $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesCount declined updates."
        Write-Output ""
        Write-Output "Please be patient, this may take a while."
        Write-Output ""
        Write-Output "It is not abnormal for this process to take minutes or hours. It varies per install and per execution."
        Write-Output ""
        Write-Output "Any errors received are due to updates that are shared between systems. Eg. A Windows 7 update may share itself also with a Server 2008 update."
        Write-Output ""
        Write-Output "If you cancel this process (CTRL-C/Close the window), you will lose the documentation/log of what has happened thusfar, but it will resume where it left off when you run it again."
        $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputTXT += "You've chosen to remove declined updates from the database. Removing $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesCount declined updates.`r`n`r`n"
        $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputHTML += "<p>You've chosen to remove declined updates from the database. <strong>Removing $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesCount declined updates.</strong></p>`n"
        # Remove these updates
        $AdamjRemoveDeclinedWSUSUpdatesUpdates | ForEach-Object {
            $DeleteID = $_.Id.UpdateId.ToString()
            Try {
                $AdamjRemoveDeclinedWSUSUpdatesUpdateTitle = $($_.Title)
                Write-Output "Deleting" $AdamjRemoveDeclinedWSUSUpdatesUpdateTitle
                $AdamjWSUSServerAdminProxy.DeleteUpdate($DeleteId)
            }
            Catch {
                $ExceptionError = $_.Exception
                if ([string]::isnullorempty($AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsTXT)) { $AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsTXT = "" }
                if ([string]::isnullorempty($AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsHTML)) { $AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsHTML = "" }
                $AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsTXT += "Error: $AdamjRemoveDeclinedWSUSUpdatesUpdateTitle`r`n`r`n$ExceptionError.InnerException`r`n`r`n"
                $AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsHTML += "<li><p>$AdamjRemoveDeclinedWSUSUpdatesUpdateTitle</p>$ExceptionError.InnerException</li>"
            }
            Finally {
                if ($ExceptionError) {
                    Write-Output "Errors:" $ExceptionError.Message
                    Remove-Variable ExceptionError
                } else {
                    Write-Verbose "Successful"
                }
            }
        }
        if (-not [string]::isnullorempty($AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsTXT)) {
            $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputTXT += "*** Errors Removing Declined WSUS Updates ***`r`n"
            $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputTXT += $AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsTXT
            $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputTXT += "`r`n`r`n"
        }
        if (-not [string]::isnullorempty($AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsHTML)) {
            $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputHTML += "<div class='error'><h1>Errors Removing Declined WSUS Updates</h1><ol start='1'>"
            $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputHTML += $AdamjRemoveDeclinedWSUSUpdatesProceedExceptionsHTML
            $Script:AdamjRemoveDeclinedWSUSUpdatesProceedOutputHTML += "</ol></div>"
        }

        # Variables Output
        # $AdamjRemoveDeclinedWSUSUpdatesProceedOutputTXT
        # $AdamjRemoveDeclinedWSUSUpdatesProceedOutputHTML
    }

    RemoveDeclinedWSUSUpdatesCountUpdates
    if ($Display -ne $False) { RemoveDeclinedWSUSUpdatesDisplayUpdates }
    if ($Proceed -ne $False) { RemoveDeclinedWSUSUpdatesProceed }
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning

    $Script:AdamjRemoveDeclinedWSUSUpdatesOutputTXT += "Adamj Remove Declined WSUS Updates:`r`n`r`n"
    $Script:AdamjRemoveDeclinedWSUSUpdatesOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Remove Declined WSUS Updates:</span></p>`n<ol>`n"
    $Script:AdamjRemoveDeclinedWSUSUpdatesOutputTXT += $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesOutputTXT
    $Script:AdamjRemoveDeclinedWSUSUpdatesOutputHTML += $AdamjRemoveDeclinedWSUSUpdatesCountUpdatesOutputHTML
    if ($Display -ne $False) {
        $Script:AdamjRemoveDeclinedWSUSUpdatesOutputTXT += $AdamjRemoveDeclinedWSUSUpdatesDisplayOutputTXT
        $Script:AdamjRemoveDeclinedWSUSUpdatesOutputHTML += $AdamjRemoveDeclinedWSUSUpdatesDisplayOutputHTML
    }
    if ($Proceed -ne $False) {
        $Script:AdamjRemoveDeclinedWSUSUpdatesOutputTXT += $AdamjRemoveDeclinedWSUSUpdatesProceedOutputTXT
        $Script:AdamjRemoveDeclinedWSUSUpdatesOutputHTML += $AdamjRemoveDeclinedWSUSUpdatesProceedOutputHTML
    }
    $Script:AdamjRemoveDeclinedWSUSUpdatesOutputTXT += "Remove Declined WSUS Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjRemoveDeclinedWSUSUpdatesOutputHTML += "<p>Remove Declined WSUS Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjRemoveDeclinedWSUSUpdatesOutputTXT
    # $AdamjRemoveDeclinedWSUSUpdatesOutputHTML
}
#endregion RemoveDeclinedWSUSUpdates Function

#region CompressUpdateRevisions Function
################################
#    Adamj Compress Update     #
#       Revisions Stream       #
################################

function CompressUpdateRevisions {
    Param (
    )
  $DateNow = Get-Date
  $AdamjCompressUpdateRevisionsSQLScript = @"
USE SUSDB;
GO
-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
SET NOCOUNT ON

DECLARE @var1 INT, @curitem INT, @totaltocompress INT
DECLARE @msg nvarchar(200)

IF EXISTS (
    SELECT * FROM tempdb.dbo.sysobjects o
    WHERE o.xtype IN ('U')
	AND o.id = object_id(N'tempdb..#results')
)
DROP TABLE #results
CREATE TABLE #results (Col1 INT)

-- Compress Update Revisions
INSERT INTO #results(Col1) EXEC spGetUpdatesToCompress
SET @totaltocompress = (SELECT COUNT(*) FROM #results)
SELECT @curitem=1
DECLARE WC Cursor FOR SELECT Col1 FROM #results;
OPEN WC
FETCH NEXT FROM WC INTO @var1 WHILE (@@FETCH_STATUS > -1)
BEGIN
	SET @msg = cast(@curitem as varchar(5)) + '/' + cast(@totaltocompress as varchar(5)) + ': Compressing ' + CONVERT(varchar(10), @var1) + ' ' + cast(getdate() as varchar(30))
	RAISERROR(@msg,0,1) WITH NOWAIT
	EXEC spCompressUpdate @localUpdateID=@var1
	SET @curitem = @curitem +1
	FETCH NEXT FROM WC INTO @var1
END
CLOSE WC
DEALLOCATE WC
DROP TABLE #results
"@
    Write-Verbose "Create a file with the content of the CompressUpdateRevisions Script above in the same working directory as this PowerShell script is running."
    $AdamjCompressUpdateRevisionsSQLScriptFile = "$AdamjScriptPath\AdamjCompressUpdateRevisions.sql"
    $AdamjCompressUpdateRevisionsSQLScript | Out-File "$AdamjCompressUpdateRevisionsSQLScriptFile"

    # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
    $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
    Write-Verbose "Execute the SQL Script and store the results in a variable."
    $AdamjCompressUpdateRevisionsSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjCompressUpdateRevisionsSQLScriptFile`" -I")
    Write-Verbose "`$AdamjCompressUpdateRevisionsSQLScriptJob = $AdamjCompressUpdateRevisionsSQLScriptJobCommand"
    $AdamjCompressUpdateRevisionsSQLScriptJob = Start-Job -ScriptBlock $AdamjCompressUpdateRevisionsSQLScriptJobCommand
    Wait-Job $AdamjCompressUpdateRevisionsSQLScriptJob
    $AdamjCompressUpdateRevisionsSQLScriptJobOutput = Receive-Job $AdamjCompressUpdateRevisionsSQLScriptJob
    Remove-Job $AdamjCompressUpdateRevisionsSQLScriptJob
    Write-Verbose "Remove the SQL Script file."
    Remove-Item "$AdamjCompressUpdateRevisionsSQLScriptFile"
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    $Script:AdamjCompressUpdateRevisionsOutputTXT += "Adamj Compress Update Revisions:`r`n`r`n"
    $Script:AdamjCompressUpdateRevisionsOutputTXT += $AdamjCompressUpdateRevisionsSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
    $Script:AdamjCompressUpdateRevisionsOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Compress Update Revisions:</span></p>`n`n"
    $Script:AdamjCompressUpdateRevisionsOutputHTML += $AdamjCompressUpdateRevisionsSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"
    $Script:AdamjCompressUpdateRevisionsOutputTXT += "Adamj Compress Update Revisions Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjCompressUpdateRevisionsOutputHTML += "<p>Adamj Compress Update Revisions Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjCompressUpdateRevisionsOutputTXT
    # $AdamjCompressUpdateRevisionsOutputHTML
}
#endregion CompressUpdateRevisions Function

#region RemoveObsoleteUpdates Function
################################
#    Adamj Remove Obsolete     #
#        Updates Stream        #
################################

function RemoveObsoleteUpdates {
    Param (
    )
  $DateNow = Get-Date
  $AdamjRemoveObsoleteUpdatesSQLScript = @"
USE SUSDB;
GO
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON

DECLARE @var1 INT, @curitem INT, @totaltoremove INT
DECLARE @msg nvarchar(200)

IF EXISTS (
    SELECT * FROM tempdb.dbo.sysobjects o
    WHERE o.xtype IN ('U')
	AND o.id = object_id(N'tempdb..#results')
)
DROP TABLE #results
CREATE TABLE #results (Col1 INT)

-- Remove Obsolete Updates
INSERT INTO #results(Col1) EXEC spGetObsoleteUpdatesToCleanup
SET @totaltoremove = (SELECT COUNT(*) FROM #results)
SELECT @curitem=1
DECLARE WC Cursor FOR SELECT Col1 FROM #results
OPEN WC
FETCH NEXT FROM WC INTO @var1 WHILE (@@FETCH_STATUS > -1)
BEGIN
	SET @msg = cast(@curitem as varchar(5)) + '/' + cast(@totaltoremove as varchar(5)) + ': Deleting ' + CONVERT(varchar(10), @var1) + ' ' + cast(getdate() as varchar(30))
	RAISERROR(@msg,0,1) WITH NOWAIT
	EXEC spDeleteUpdate @localUpdateID=@var1
	SET @curitem = @curitem +1
	FETCH NEXT FROM WC INTO @var1
END
CLOSE WC
DEALLOCATE WC
DROP TABLE #results
"@
    Write-Output ""
    Write-Output "Please be patient, this may take a while."
    Write-Output ""
    Write-Output "It is not abnormal for this process to take minutes or hours. It varies per install and per execution."
    Write-Output ""
    Write-Output "If you cancel this process (CTRL-C/Close the window), you will lose the documentation/log of what has happened thusfar, but it will resume where it left off when you run it again."
    Write-Verbose "Create a file with the content of the RemoveObsoleteUpdates Script above in the same working directory as this PowerShell script is running."
    $AdamjRemoveObsoleteUpdatesSQLScriptFile = "$AdamjScriptPath\AdamjRemoveObsoleteUpdates.sql"
    $AdamjRemoveObsoleteUpdatesSQLScript | Out-File "$AdamjRemoveObsoleteUpdatesSQLScriptFile"
    Write-Debug "Just wrote to script file"
    # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
    $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
    Write-Verbose "Execute the SQL Script and store the results in a variable."
    $AdamjRemoveObsoleteUpdatesSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjRemoveObsoleteUpdatesSQLScriptFile`" -I")
    Write-Verbose "`$AdamjRemoveObsoleteUpdatesSQLScriptJobCommand = $AdamjRemoveObsoleteUpdatesSQLScriptJobCommand"
    $AdamjRemoveObsoleteUpdatesSQLScriptJob = Start-Job -ScriptBlock $AdamjRemoveObsoleteUpdatesSQLScriptJobCommand
    Wait-Job $AdamjRemoveObsoleteUpdatesSQLScriptJob
    $AdamjRemoveObsoleteUpdatesSQLScriptJobOutput = Receive-Job $AdamjRemoveObsoleteUpdatesSQLScriptJob
    Write-Debug "Just finished - check AdamjRemoveObsoleteUpdatesSQLScriptJobOutput"
    Remove-Job $AdamjRemoveObsoleteUpdatesSQLScriptJob
    Write-Verbose "Remove the SQL Script file."
    Remove-Item "$AdamjRemoveObsoleteUpdatesSQLScriptFile"
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    $Script:AdamjRemoveObsoleteUpdatesOutputTXT += "Adamj Remove Obsolete Updates:`r`n`r`n"
    $Script:AdamjRemoveObsoleteUpdatesOutputTXT += $AdamjRemoveObsoleteUpdatesSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
    $Script:AdamjRemoveObsoleteUpdatesOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Remove Obsolete Updates:</span></p>`n`n"
    $Script:AdamjRemoveObsoleteUpdatesOutputHTML += $AdamjRemoveObsoleteUpdatesSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"
    $Script:AdamjRemoveObsoleteUpdatesOutputTXT += "Adamj Remove Obsolete Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjRemoveObsoleteUpdatesOutputHTML += "<p>Adamj Remove Obsolete Updates Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjRemoveObsoleteUpdatesOutputTXT
    # $AdamjRemoveObsoleteUpdatesOutputHTML
}
#endregion RemoveObsoleteUpdates Function

#region WSUSDBMaintenance Function
################################
#  Adamj WSUS DB Maintenance   #
#            Stream            #
################################

function WSUSDBMaintenance {
    Param (
    [Switch]$NoOutput
    )
  $DateNow = Get-Date
  $AdamjWSUSDBMaintenanceSQLScript = @"
/*
################################
#   Adamj WSUSDBMaintenance    #
#         SQL Script           #
#       Version 1.0            #
#      Taken from TechNet      #
#      referenced below.       #
#                              #
#        Adam Marshall         #
#     http://www.adamj.org     #
################################
*/
-- Taken from https://gallery.technet.microsoft.com/scriptcenter/6f8cde49-5c52-4abd-9820-f1d270ddea61

/******************************************************************************
This sample T-SQL script performs basic maintenance tasks on SUSDB
1. Identifies indexes that are fragmented and defragments them. For certain
   tables, a fill-factor is set in order to improve insert performance.
   Based on MSDN sample at http://msdn2.microsoft.com/en-us/library/ms188917.aspx
   and tailored for SUSDB requirements
2. Updates potentially out-of-date table statistics.
******************************************************************************/

USE SUSDB;
GO
SET NOCOUNT ON;

-- Rebuild or reorganize indexes based on their fragmentation levels
DECLARE @work_to_do TABLE (
    objectid int
    , indexid int
    , pagedensity float
    , fragmentation float
    , numrows int
)

DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @schemaname nvarchar(130);
DECLARE @objectname nvarchar(130);
DECLARE @indexname nvarchar(130);
DECLARE @numrows int
DECLARE @density float;
DECLARE @fragmentation float;
DECLARE @command nvarchar(4000);
DECLARE @fillfactorset bit
DECLARE @numpages int

-- Select indexes that need to be defragmented based on the following
-- * Page density is low
-- * External fragmentation is high in relation to index size
PRINT 'Estimating fragmentation: Begin. ' + convert(nvarchar, getdate(), 121)
INSERT @work_to_do
SELECT
    f.object_id
    , index_id
    , avg_page_space_used_in_percent
    , avg_fragmentation_in_percent
    , record_count
FROM
    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'SAMPLED') AS f
WHERE
    (f.avg_page_space_used_in_percent < 85.0 and f.avg_page_space_used_in_percent/100.0 * page_count < page_count - 1)
    or (f.page_count > 50 and f.avg_fragmentation_in_percent > 15.0)
    or (f.page_count > 10 and f.avg_fragmentation_in_percent > 80.0)

PRINT 'Number of indexes to rebuild: ' + cast(@@ROWCOUNT as nvarchar(20))

PRINT 'Estimating fragmentation: End. ' + convert(nvarchar, getdate(), 121)

SELECT @numpages = sum(ps.used_page_count)
FROM
    @work_to_do AS fi
    INNER JOIN sys.indexes AS i ON fi.objectid = i.object_id and fi.indexid = i.index_id
    INNER JOIN sys.dm_db_partition_stats AS ps on i.object_id = ps.object_id and i.index_id = ps.index_id

-- Declare the cursor for the list of indexes to be processed.
DECLARE curIndexes CURSOR FOR SELECT * FROM @work_to_do

-- Open the cursor.
OPEN curIndexes

-- Loop through the indexes
WHILE (1=1)
BEGIN
    FETCH NEXT FROM curIndexes
    INTO @objectid, @indexid, @density, @fragmentation, @numrows;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT
        @objectname = QUOTENAME(o.name)
        , @schemaname = QUOTENAME(s.name)
    FROM
        sys.objects AS o
        INNER JOIN sys.schemas as s ON s.schema_id = o.schema_id
    WHERE
        o.object_id = @objectid;

    SELECT
        @indexname = QUOTENAME(name)
        , @fillfactorset = CASE fill_factor WHEN 0 THEN 0 ELSE 1 END
    FROM
        sys.indexes
    WHERE
        object_id = @objectid AND index_id = @indexid;

    IF ((@density BETWEEN 75.0 AND 85.0) AND @fillfactorset = 1) OR (@fragmentation < 30.0)
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @numrows >= 5000 AND @fillfactorset = 0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD WITH (FILLFACTOR = 90)';
    ELSE
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
    PRINT convert(nvarchar, getdate(), 121) + N' Executing: ' + @command;
    EXEC (@command);
    PRINT convert(nvarchar, getdate(), 121) + N' Done.';
END

-- Close and deallocate the cursor.
CLOSE curIndexes;
DEALLOCATE curIndexes;

IF EXISTS (SELECT * FROM @work_to_do)
BEGIN
    PRINT 'Estimated number of pages in fragmented indexes: ' + cast(@numpages as nvarchar(20))
    SELECT @numpages = @numpages - sum(ps.used_page_count)
    FROM
        @work_to_do AS fi
        INNER JOIN sys.indexes AS i ON fi.objectid = i.object_id and fi.indexid = i.index_id
        INNER JOIN sys.dm_db_partition_stats AS ps on i.object_id = ps.object_id and i.index_id = ps.index_id
    PRINT 'Estimated number of pages freed: ' + cast(@numpages as nvarchar(20))
END
GO

--Update all statistics
PRINT 'Updating all statistics.' + convert(nvarchar, getdate(), 121)
EXEC sp_updatestats
PRINT 'Done updating statistics.' + convert(nvarchar, getdate(), 121)
GO
"@
    Write-Verbose "Create a file with the content of the WSUSDBMaintenance Script above in the same working directory as this PowerShell script is running."
    $AdamjWSUSDBMaintenanceSQLScriptFile = "$AdamjScriptPath\AdamjWSUSDBMaintenance.sql"
    $AdamjWSUSDBMaintenanceSQLScript | Out-File "$AdamjWSUSDBMaintenanceSQLScriptFile"

    # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
    $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
    Write-Verbose "Execute the SQL Script and store the results in a variable."
    $AdamjWSUSDBMaintenanceSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjWSUSDBMaintenanceSQLScriptFile`" -I")
    Write-Verbose "`$AdamjWSUSDBMaintenanceSQLScriptJobCommand = $AdamjWSUSDBMaintenanceSQLScriptJobCommand"
    $AdamjWSUSDBMaintenanceSQLScriptJob = Start-Job -ScriptBlock $AdamjWSUSDBMaintenanceSQLScriptJobCommand
    Wait-Job $AdamjWSUSDBMaintenanceSQLScriptJob
    $AdamjWSUSDBMaintenanceSQLScriptJobOutput = Receive-Job $AdamjWSUSDBMaintenanceSQLScriptJob
    Remove-Job $AdamjWSUSDBMaintenanceSQLScriptJob
    Write-Verbose "Remove the SQL Script file."
    Remove-Item "$AdamjWSUSDBMaintenanceSQLScriptFile"
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning
    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    if ($NoOutput -eq $False) {
        $Script:AdamjWSUSDBMaintenanceOutputTXT += "Adamj WSUS DB Maintenance:`r`n`r`n"
        $Script:AdamjWSUSDBMaintenanceOutputTXT += $AdamjWSUSDBMaintenanceSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
        $Script:AdamjWSUSDBMaintenanceOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj WSUS DB Maintenance:</span></p>`n`n"
        $Script:AdamjWSUSDBMaintenanceOutputHTML += $AdamjWSUSDBMaintenanceSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"
     } else {
        $Script:AdamjWSUSDBMaintenanceOutputTXT += "Adamj WSUS DB Maintenance:`r`n`r`n"
        $Script:AdamjWSUSDBMaintenanceOutputTXT += "The Adamj WSUS DB Maintenance Stream was run with the -NoOutput switch.`r`n"
        $Script:AdamjWSUSDBMaintenanceOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj WSUS DB Maintenance:</span></p>`n`n"
        $Script:AdamjWSUSDBMaintenanceOutputHTML += "<p>The Adamj WSUS DB Maintenance Stream was run with the -NoOutput switch.</p>`n`n"
     }
     $Script:AdamjWSUSDBMaintenanceOutputTXT += "WSUS DB Maintenance Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
     $Script:AdamjWSUSDBMaintenanceOutputHTML += "<p>WSUS DB Maintenance Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjWSUSDBMaintenanceOutputTXT
    # $AdamjWSUSDBMaintenanceOutputHTML
}
#endregion WSUSDBMaintenance Function

#region CleanUpWSUSSynchronizationLogs Function
################################
#        Clean Up WSUS         #
# Synchronization Logs Stream  #
################################

function CleanUpWSUSSynchronizationLogs {
    Param(
    [Int]$ConsistencyNumber,
    [String]$ConsistencyTime,
    [Switch]$All
    )
  $DateNow = Get-Date
  $AdamjCleanUpWSUSSynchronizationLogsSQLScript = @"
/*
################################
#  Adamj WSUS Synchronization  #
#      Cleanup SQL Script      #
#       Version 1.0            #
#  Taken from various sources  #
#      from the Internet.      #
#                              #
#  Modified By: Adam Marshall  #
#     http://www.adamj.org     #
################################
*/
$(
    if ($ConsistencyNumber -ne "0") {
    $("
USE SUSDB
GO
DELETE FROM tbEventInstance WHERE EventNamespaceID = '2' AND EVENTID IN ('381', '382', '384', '386', '387', '389') AND DATEDIFF($($ConsistencyTime), TimeAtServer, CURRENT_TIMESTAMP) >= $($ConsistencyNumber);
GO")
}
elseif ($All -ne $False) {
$("USE SUSDB
GO
DELETE FROM tbEventInstance WHERE EventNamespaceID = '2' AND EVENTID IN ('381', '382', '384', '386', '387', '389')
GO")
}
)
"@
    Write-Verbose "Create a file with the content of the AdamjCleanUpWSUSSynchronizationLogs Script above in the same working directory as this PowerShell script is running."
    $AdamjCleanUpWSUSSynchronizationLogsSQLScriptFile = "$AdamjScriptPath\AdamjCleanUpWSUSSynchronizationLogs.sql"
    $AdamjCleanUpWSUSSynchronizationLogsSQLScript | Out-File "$AdamjCleanUpWSUSSynchronizationLogsSQLScriptFile"
    # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
    $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
    Write-Verbose "Execute the SQL Script and store the results in a variable."
    $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjCleanUpWSUSSynchronizationLogsSQLScriptFile`" -I")
    Write-Verbose "`$AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobCommand = $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobCommand"
    $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJob = Start-Job -ScriptBlock $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobCommand
    Wait-Job $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJob
    $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobOutput = Receive-Job $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJob
    Remove-Job $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJob
    Write-Verbose "Remove the SQL Script file."
    Remove-Item "$AdamjCleanUpWSUSSynchronizationLogsSQLScriptFile"
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning

    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    $Script:AdamjCleanUpWSUSSynchronizationLogsSQLOutputTXT += "Adamj Clean Up WSUS Synchronization Logs:`r`n`r`n"
    $Script:AdamjCleanUpWSUSSynchronizationLogsSQLOutputTXT += $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","`r`n"
    $Script:AdamjCleanUpWSUSSynchronizationLogsSQLOutputTXT += "Clean Up WSUS Synchronization Logs Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    $Script:AdamjCleanUpWSUSSynchronizationLogsSQLOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Clean Up WSUS Synchronization Logs:</span></p>`r`n"
    $Script:AdamjCleanUpWSUSSynchronizationLogsSQLOutputHTML += $AdamjCleanUpWSUSSynchronizationLogsSQLScriptJobOutput.Trim() -creplace'(?m)^\s*\r?\n','' -creplace '$?',"" -creplace "$","<br>`r`n"
    $Script:AdamjCleanUpWSUSSynchronizationLogsSQLOutputHTML += "<p>Clean Up WSUS Synchronization Logs Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjCleanUpWSUSSynchronizationLogsSQLOutputTXT
    # $AdamjCleanUpWSUSSynchronizationLogsSQLOutputHTML
}
#endregion CleanUpWSUSSynchronizationLogs Function

#region DirtyDatabaseCheck Function
################################
#  Adamj Dirty Database Check  #
#           Stream             #
################################

function DirtyDatabaseCheck {
    param (
    )
    $DateNow = Get-Date
    $AdamjDirtyDatabaseCheckSQLScript = @"
/*
################################
#  Adamj Dirty Database Check  #
#          SQL Script          #
#          Version 1.0         #
#                              #
#       By: Adam Marshall      #
#     http://www.adamj.org     #
################################
*/
USE SUSDB
select TotalResults = Count(*)
from tbFile
where (IsEncrypted = 1 and DecryptionKey is NULL) OR ((FileName like '%.esd' and IsEncrypted = 0) and DecryptionKey is NOT NULL) OR ((FileName like '%.esd' and IsEncrypted = 0) AND (FileName not like '%10586%.esd'))
"@
    Write-Verbose "Create a file with the content of the DirtyDatabaseCheck Script above in the same working directory as this PowerShell script is running."
    $AdamjDirtyDatabaseCheckSQLScriptFile = "$AdamjScriptPath\AdamjDirtyDatabaseCheck.sql"
    $AdamjDirtyDatabaseCheckSQLScript | Out-File "$AdamjDirtyDatabaseCheckSQLScriptFile"
    # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
    $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
    Write-Verbose "Execute the SQL Script and store the results in a variable."
    $AdamjDirtyDatabaseCheckSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjDirtyDatabaseCheckSQLScriptFile`" -I")
    Write-Verbose "`$AdamjDirtyDatabaseCheckSQLScriptJobCommand = $AdamjDirtyDatabaseCheckSQLScriptJobCommand"
    $AdamjDirtyDatabaseCheckSQLScriptJob = Start-Job -ScriptBlock $AdamjDirtyDatabaseCheckSQLScriptJobCommand
    Wait-Job $AdamjDirtyDatabaseCheckSQLScriptJob
    $AdamjDirtyDatabaseCheckSQLScriptJobOutput = Receive-Job $AdamjDirtyDatabaseCheckSQLScriptJob
    Remove-Job $AdamjDirtyDatabaseCheckSQLScriptJob
    Write-Verbose "Remove the SQL Script file."
    Remove-Item "$AdamjDirtyDatabaseCheckSQLScriptFile"
    if ($AdamjDirtyDatabaseCheckSQLScriptJobOutput.Trim()[3] -eq "0") {
        Write-Output "You have a clean database."
        $AdamjDirtyDatabaseCheckOutputTXT = "You have a clean database."
    } else {
        Write-Output 'You have a dirty database. Please see: https://support.microsoft.com/en-us/help/3194588 for more information about it.'
        $AdamjDirtyDatabaseFixOutput ="You have a dirty database. Please see: https://support.microsoft.com/en-us/help/3194588 for more information about it."
        Write-Output "First we need to install the WSUS Index Optimization so that this doesn't take as long."
        $AdamjDirtyDatabaseFixOutput += "First we need to install the WSUS Index Optimization so that this doesn't take as long."
        WSUSIndexOptimization
        Write-Output $AdamjWSUSIndexOptimizationOutputTXT
        $AdamjDirtyDatabaseFixOutput += "Now we need to run the WSUS DB Maintenance on the database to make sure we're starting with an optimized database."
        Write-Output "Now we need to run the WSUS DB Maintenance on the database to make sure we're starting with an optimized database."
        WSUSDBMaintenance
        Write-Output "Done. Now let's begin cleansing your database."
        $AdamjDirtyDatabaseFixOutput += "Done. Now let's begin cleansing your database."
        Write-Output "Attempting to fix your database by the methods Microsoft recommends but augmented for future-proofing..."
        $AdamjDirtyDatabaseFixOutput += "Attempting to fix your database by the methods Microsoft recommends but augmented for future-proofing..."
        Write-Verbose "First let's disable the 'Upgrades' Classification"
        Get-WsusClassification | Where-Object -FilterScript {$_.Classification.Title -Eq "Upgrades"} | Set-WsusClassification -Disable
        Write-Verbose "Create an update scope"
        $UpdateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
        Write-Verbose "Set the update scope to 'Any' approval states"
        $UpdateScope.ApprovedStates = "Any"
        Write-Verbose "Get all updates that do not match 1511 or 1507, but do have 'Windows 10' in the title and stick them into a variable."
        $AdamjDirtyDatabaseUpdates = $AdamjWSUSServerAdminProxy.GetUpdates($UpdateScope) | Where-Object { -not($_.Title -match '1511' -or $_.Title -match '1507') -and ($_.Title -imatch 'Windows 10') }
        Write-Verbose "Let's decline them all"
        $AdamjDirtyDatabaseUpdates | foreach { $_.Decline() }
        Write-Verbose "Let's remove them from the WSUS Server"
        $AdamjDirtyDatabaseUpdates | foreach { $AdamjWSUSServerAdminProxy.DeleteUpdate($_.Id.UpdateId) }
        Write-Verbose "Now let's re-enable the 'Upgrades' Classification"
        Get-WsusClassification | Where-Object -FilterScript {$_.Classification.Title -Eq "Upgrades"} | Set-WsusClassification
        Write-Verbose "We need to run a SQL Script to remove these files from the WSUS metadata"
        $AdamjDirtyDatabaseFixSQLScript =@"
/*
################################
#   Adamj Dirty Database Fix   #
#          SQL Script          #
#          Version 1.1         #
#                              #
#       By: Adam Marshall      #
#     http://www.adamj.org     #
################################
*/
use SUSDB
declare @NotNeededFiles table (FileDigest binary(20) UNIQUE);
insert into @NotNeededFiles(FileDigest) (select FileDigest from tbFile where FileName like '%.esd' and (FileName not like '%10240%.esd' or FileName not like '%10586%.esd') except select FileDigest from tbFileForRevision);
delete from tbFileOnServer where FileDigest in (select FileDigest from @NotNeededFiles)
delete from tbFile where FileDigest in (select FileDigest from @NotNeededFiles)
"@
        $AdamjDirtyDatabaseFixSQLScriptFile = "$AdamjScriptPath\AdamjDirtyDatabaseCheck.sql"
        $AdamjDirtyDatabaseFixSQLScript | Out-File "$AdamjDirtyDatabaseFixSQLScriptFile"
        # Re-jig the $AdamjSQLConnectCommand to replace the $ with a `$ for Windows 2008 Internal Database possiblity.
        $AdamjSQLConnectCommand = $AdamjSQLConnectCommand.Replace('$','`$')
        Write-Verbose "Execute the SQL Script and store the results in a variable."
        $AdamjDirtyDatabaseFixSQLScriptJobCommand = [scriptblock]::create("$AdamjSQLConnectCommand -i `"$AdamjDirtyDatabaseFixSQLScriptFile`" -I")
        Write-Verbose "`$AdamjDirtyDatabaseFixSQLScriptJobCommand = $AdamjDirtyDatabaseFixSQLScriptJobCommand"
        $AdamjDirtyDatabaseFixSQLScriptJob = Start-Job -ScriptBlock $AdamjDirtyDatabaseFixSQLScriptJobCommand
        Wait-Job $AdamjDirtyDatabaseFixSQLScriptJob
        $AdamjDirtyDatabaseFixSQLScriptJobOutput = Receive-Job $AdamjDirtyDatabaseFixSQLScriptJob
        Remove-Job $AdamjDirtyDatabaseFixSQLScriptJob
        Write-Output $AdamjDirtyDatabaseFixSQLScriptJobOutput
        $AdamjDirtyDatabaseFixOutput += $AdamjDirtyDatabaseFixSQLScriptJobOutput
        Write-Verbose "Remove the SQL Script file."
        Remove-Item "$AdamjDirtyDatabaseFixSQLScriptFile"
        Write-Verbose "Finally, let's re-syncronize the server with Microsoft to pull down the updates again"
        $($AdamjWSUSServerAdminProxy.GetSubscription()).StartSynchronization()
        Write-Output "Your WSUS server has been fixed. A syncronization has been initialized. Please wait while it finishes. You can monitor it through the WSUS Console."
        $AdamjDirtyDatabaseFixOutput += "Your WSUS server has been fixed. A syncronization has been initialized. Please wait while it finishes. You can monitor it through the WSUS Console."
        $AdamjDirtyDatabaseFixOutputTXT = $AdamjDirtyDatabaseFixOutput
    }
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning

    $Script:AdamjDirtyDatabaseOutputTXT = "Adamj Dirty Database Check Stream:`r`n`r`n"
    $Script:AdamjDirtyDatabaseOutputTXT += if ([string]::isnullorempty($AdamjDirtyDatabaseCheckOutputTXT)) { $AdamjDirtyDatabaseFixOutputTXT + "`r`n`r`n" } else { $AdamjDirtyDatabaseCheckOutputTXT + "`r`n`r`n" }
    $Script:AdamjDirtyDatabaseOutputTXT += "Adamj Dirty Database Check Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    $Script:AdamjDirtyDatabaseOutputHTML = "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Dirty Database Check Stream:</span></p>`r`n"
    $Script:AdamjDirtyDatabaseOutputHTML += if ([string]::isnullorempty($AdamjDirtyDatabaseCheckOutputTXT)) { $AdamjDirtyDatabaseFixOutputTXT -creplace '\r\n', "<br>`r`n" -creplace '^',"<p>" -creplace '$', "</p>`r`n" } else { $AdamjDirtyDatabaseCheckOutputTXT -creplace '\r\n', "<br>`r`n" -creplace '^',"<p>" -creplace '$', "</p>`r`n" }
    $Script:AdamjDirtyDatabaseOutputHTML += "<p>Adamj Dirty Database Check Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjDirtyDatabaseOutputTXT
    # $AdamjDirtyDatabaseOutputHTML
}
#endregion DirtyDatabaseCheck Function

#region ComputerObjectCleanup Function
################################
#   Computer Object Cleanup    #
#            Stream            #
################################

function ComputerObjectCleanup {
    $DateNow = Get-Date
    Write-Verbose "Create a new timespan using `$AdamjComputerObjectCleanupSearchDays and find how many computers need to be cleaned up"
    $AdamjComputerObjectCleanupSearchTimeSpan = New-Object timespan($AdamjComputerObjectCleanupSearchDays,0,0,0)
    $AdamjComputerObjectCleanupScope = New-Object Microsoft.UpdateServices.Administration.ComputerTargetScope
    $AdamjComputerObjectCleanupScope.ToLastSyncTime = [DateTime]::UtcNow.Subtract($AdamjComputerObjectCleanupSearchTimeSpan)
    $AdamjComputerObjectCleanupSet = $AdamjWSUSServerAdminProxy.GetComputerTargets($AdamjComputerObjectCleanupScope) | Sort-Object FullDomainName
    Write-Verbose "Clean up $($AdamjComputerObjectCleanupSet.Count) computer objects"
    $AdamjWSUSServerAdminProxy.GetComputerTargets($AdamjComputerObjectCleanupScope) | ForEach-Object { $_.Delete() }

    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning

    # Setup variables to store the output to be added at the very end of the script for logging purposes.
    $Script:AdamjComputerObjectCleanupOutputTXT += "Adamj Computer Object Cleanup:`r`n`r`n"
    if ($($AdamjComputerObjectCleanupSet.Count) -gt "0") {
        $Script:AdamjComputerObjectCleanupOutputTXT += "The following $($AdamjComputerObjectCleanupSet.Count) $(if ($($AdamjComputerObjectCleanupSet.Count) -eq "1") { "computer" } else { "computers" }) have been removed."
        $Script:AdamjComputerObjectCleanupOutputTXT += $AdamjComputerObjectCleanupSet | Select-Object FullDomainName,@{Expression="   "},LastSyncTime | Format-Table -AutoSize | Out-String
    } else { $Script:AdamjComputerObjectCleanupOutputTXT += "There are no computers to clean up.`r`n" }

    $Script:AdamjComputerObjectCleanupOutputTXT += "Adamj Computer Object Cleanup Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjComputerObjectCleanupOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj Computer Object Cleanup:</span></p>`r`n"
    if ($($AdamjComputerObjectCleanupSet.Count) -gt "0") {
        $Script:AdamjComputerObjectCleanupOutputHTML += "<p>The following $($AdamjComputerObjectCleanupSet.Count) $(if ($($AdamjComputerObjectCleanupSet.Count) -eq "1") { "computer" } else { "computers" }) have been removed.</p>"
        $Script:AdamjComputerObjectCleanupOutputHTML += ($AdamjComputerObjectCleanupSet | Select-Object FullDomainName,LastSyncTime | ConvertTo-Html -Fragment) -replace "\<table\>",'<table class="gridtable">'
    } else { $Script:AdamjComputerObjectCleanupOutputHTML += "<p>There are no computers to clean up.</p>" }
    $Script:AdamjComputerObjectCleanupOutputHTML += "<p>Adamj Computer Object Cleanup Stream Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    # Variables Output
    # $AdamjComputerObjectCleanupOutputTXT
    # $AdamjComputerObjectCleanupOutputHTML
}

#endregion ComputerObjectCleanup Function

#region WSUSServerCleanupWizard Function
################################
#  WSUS Server Cleanup Wizard  #
#            Stream            #
################################

function WSUSServerCleanupWizard {
    $DateNow = Get-Date
    $WSUSServerCleanupWizardBody = "<p><span style=`"font-weight: bold; font-size: 1.2em;`">WSUS Server Cleanup Wizard:</span></p>" | Out-String
    $CleanupManager = $AdamjWSUSServerAdminProxy.GetCleanupManager();
    $CleanupScope = New-Object Microsoft.UpdateServices.Administration.CleanupScope ($AdamjSCWSupersededUpdatesDeclined,$AdamjSCWExpiredUpdatesDeclined,$AdamjSCWObsoleteUpdatesDeleted,$AdamjSCWUpdatesCompressed,$AdamjSCWObsoleteComputersDeleted,$AdamjSCWUnneededContentFiles);
    $AdamjCleanupResults = $CleanupManager.PerformCleanup($CleanupScope)
    $FinishedRunning = Get-Date
    $DifferenceInTime = New-TimeSpan -Start $DateNow -End $FinishedRunning

    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "Adamj WSUS Server Cleanup Wizard:`r`n`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "$AdamjWSUSServer`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "Version: $($AdamjWSUSServerAdminProxy.Version)`r`n"
    #$Script:AdamjWSUSServerCleanupWizardOutputTXT += "Started: $($DateNow.ToString("yyyy.MM.dd hh:mm:ss tt zzz"))`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "SupersededUpdatesDeclined: $($AdamjCleanupResults.SupersededUpdatesDeclined)`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "ExpiredUpdatesDeclined: $($AdamjCleanupResults.ExpiredUpdatesDeclined)`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "ObsoleteUpdatesDeleted: $($AdamjCleanupResults.ObsoleteUpdatesDeleted)`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "UpdatesCompressed: $($AdamjCleanupResults.UpdatesCompressed)`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "ObsoleteComputersDeleted: $($AdamjCleanupResults.ObsoleteComputersDeleted)`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "DiskSpaceFreed (MB): $([math]::round($AdamjCleanupResults.DiskSpaceFreed/1MB, 2))`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "DiskSpaceFreed (GB): $([math]::round($AdamjCleanupResults.DiskSpaceFreed/1GB, 2))`r`n"
    #$Script:AdamjWSUSServerCleanupWizardOutputTXT += "Finished: $($FinishedRunning.ToString("yyyy.MM.dd hh:mm:ss tt zzz"))`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputTXT += "WSUS Server Cleanup Wizard Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})

    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<p><span style=`"font-weight: bold; font-size: 1.2em;`">Adamj WSUS Server Cleanup Wizard:</span></p>`r`n"
    #$Script:AdamjWSUSServerCleanupWizardOutputHTML += $AdamjCSSStyling + "`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<table class=`"gridtable`">`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tbody>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><th colspan=`"2`" rowspan=`"1`">$AdamjWSUSServer</th></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>Version:</td><td>$($AdamjWSUSServerAdminProxy.Version)</td></tr>`r`n"
    #$Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>Started:</td><td>$($DateNow.ToString("yyyy.MM.dd hh:mm:ss tt zzz"))</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>SupersededUpdatesDeclined:</td><td>$($AdamjCleanupResults.SupersededUpdatesDeclined)</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>ExpiredUpdatesDeclined:</td><td>$($AdamjCleanupResults.ExpiredUpdatesDeclined)</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>ObsoleteUpdatesDeleted:</td><td>$($AdamjCleanupResults.ObsoleteUpdatesDeleted)</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>UpdatesCompressed:</td><td>$($AdamjCleanupResults.UpdatesCompressed)</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>ObsoleteComputersDeleted:</td><td>$($AdamjCleanupResults.ObsoleteComputersDeleted)</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>DiskSpaceFreed (MB):</td><td>$([math]::round($AdamjCleanupResults.DiskSpaceFreed/1MB, 2))</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>DiskSpaceFreed (GB):</td><td>$([math]::round($AdamjCleanupResults.DiskSpaceFreed/1GB, 2))</td></tr>`r`n"
    #$Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>Finished:</td><td>$($FinishedRunning.ToString("yyyy.MM.dd hh:mm:ss tt zzz"))</td></tr>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "<tr><td>WSUS Server Cleanup Wizard Duration:</td><td>{0:00}:{1:00}:{2:00}:{3:00}</td></tr>`r`n" -f ($DifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "</tbody>`r`n"
    $Script:AdamjWSUSServerCleanupWizardOutputHTML += "</table>`r`n"

    # Variables Output
    # $AdamjWSUSServerCleanupWizardOutputTXT
    # $AdamjWSUSServerCleanupWizardOutputHTML
}
#endregion WSUSServerCleanupWizard Function

#region AdamjScriptDifferenceInTime Function
function AdamjScriptDifferenceInTime {
    $AdamjScriptFinishedRunning = Get-Date
    $Script:AdamjScriptDifferenceInTime = New-TimeSpan -Start $AdamjScriptTime -End $AdamjScriptFinishedRunning
}
#endregion AdamjScriptDifferenceInTime Function

#region Create The CSS Styling
################################
#    Create the CSS Styling    #
################################

$AdamjCSSStyling =@"
<style type="text/css">
#gridtable table, table.gridtable {
    font-family: verdana,arial,sans-serif;
    font-size: 11px;
    color: #333333;
    border-width: 1px;
    border-color: #666666;
    border-collapse: collapse;
}
#gridtable table th, table.gridtable th {
    border-width: 1px;
    padding: 8px;
    border-style: solid;
    border-color: #666666;
    background-color: #dedede;
}
#gridtable table td, table.gridtable td {
    border-width: 1px;
    padding: 8px;
    border-style: solid;
    border-color: #666666;
    background-color: #ffffff;
}
.TFtable{
    border-collapse:collapse;
}
.TFtable td{
    padding:7px;
    border:#4e95f4 1px solid;
}

/* provide some minimal visual accommodation for IE8 and below */
.TFtable tr{
    background: #b8d1f3;
}
/* Define the background color for all the ODD background rows */
.TFtable tr:nth-child(odd){
    background: #b8d1f3;
}
/* Define the background color for all the EVEN background rows */
.TFtable tr:nth-child(even){
    background: #dae5f4;
}
.error {
border: 2px solid;
margin: 10px 10px;
padding: 15px 50px 15px 50px;
}
.error ol {
color: #D8000C;
}
.error ol li p {
color: #000;
background-color: transparent;
}
.error ol li {
background-color: #FFBABA;
margin: 10px 0;
}
</style>
"@
#endregion Create The CSS Styling

#region Create The Output
################################
#     Create the TXT output    #
################################

function CreateBodyTXT {
    $Script:AdamjBodyTXT = "`n"
    $Script:AdamjBodyTXT += $AdamjBodyHeaderTXT
    $Script:AdamjBodyTXT += $AdamjConnectedTXT
    $Script:AdamjBodyTXT += $AdamjWSUSIndexOptimizationOutputTXT
    $Script:AdamjBodyTXT += $AdamjRemoveObsoleteUpdatesOutputTXT
    $Script:AdamjBodyTXT += $AdamjCompressUpdateRevisionsOutputTXT
    $Script:AdamjBodyTXT += $AdamjDeclineMultipleTypesOfUpdatesOutputTXT
    $Script:AdamjBodyTXT += $AdamjCleanUpWSUSSynchronizationLogsSQLOutputTXT
    $Script:AdamjBodyTXT += $AdamjRemoveWSUSDriversOutputTXT
    $Script:AdamjBodyTXT += $AdamjRemoveDeclinedWSUSUpdatesOutputTXT
    $Script:AdamjBodyTXT += $AdamjComputerObjectCleanupOutputTXT
    $Script:AdamjBodyTXT += $AdamjWSUSDBMaintenanceOutputTXT
    $Script:AdamjBodyTXT += $AdamjWSUSServerCleanupWizardOutputTXT
    $Script:AdamjBodyTXT += $AdamjInstallTaskOutputTXT
    $Script:AdamjBodyTXT += $AdamjDirtyDatabaseOutputTXT
    $Script:AdamjBodyTXT += "`r`nClean-WSUS Script Duration: {0:00}:{1:00}:{2:00}:{3:00}`r`n`r`n" -f ($AdamjScriptDifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjBodyTXT += $AdamjBodyFooterTXT
}

################################
#    Create the HTML output    #
################################

function CreateBodyHTML {
    $Script:AdamjBodyHTML = "`n"
    $Script:AdamjBodyHTML += $AdamjCSSStyling
    $Script:AdamjBodyHTML += $AdamjBodyHeaderHTML
    $Script:AdamjBodyHTML += $AdamjConnectedHTML
    $Script:AdamjBodyHTML += $AdamjWSUSIndexOptimizationOutputHTML
    $Script:AdamjBodyHTML += $AdamjRemoveObsoleteUpdatesOutputHTML
    $Script:AdamjBodyHTML += $AdamjCompressUpdateRevisionsOutputHTML
    $Script:AdamjBodyHTML += $AdamjDeclineMultipleTypesOfUpdatesOutputHTML
    $Script:AdamjBodyHTML += $AdamjCleanUpWSUSSynchronizationLogsSQLOutputHTML
    $Script:AdamjBodyHTML += $AdamjRemoveWSUSDriversOutputHTML
    $Script:AdamjBodyHTML += $AdamjRemoveDeclinedWSUSUpdatesOutputHTML
    $Script:AdamjBodyHTML += $AdamjComputerObjectCleanupOutputHTML
    $Script:AdamjBodyHTML += $AdamjWSUSDBMaintenanceOutputHTML
    $Script:AdamjBodyHTML += $AdamjWSUSServerCleanupWizardOutputHTML
    $Script:AdamjBodyHTML += $AdamjInstallTaskOutputHTML
    $Script:AdamjBodyHTML += $AdamjDirtyDatabaseOutputHTML
    $Script:AdamjBodyHTML += "<p>Clean-WSUS Script Duration: {0:00}:{1:00}:{2:00}:{3:00}</p>`r`n" -f ($AdamjScriptDifferenceInTime | % {$_.Days, $_.Hours, $_.Minutes, $_.Seconds})
    $Script:AdamjBodyHTML += $AdamjBodyFooterHTML
}
#endregion Create The Output

#region SaveReport
################################
#       Save the Report        #
################################

function SaveReport {
    Param(
    [ValidateSet("TXT","HTML")]
    [String]$ReportType = "TXT"
    )
    if ($ReportType -eq "HTML") {
        $AdamjBodyHTML | Out-File -FilePath "$AdamjScriptPath\$(get-date -f "yyyy.MM.dd-HH.mm.ss").htm"
    } else {
        $AdamjBodyTXT | Out-File -FilePath "$AdamjScriptPath\$(get-date -f "yyyy.MM.dd-HH.mm.ss").txt"
    }
}
#endregion SaveReport

#region MailReport
################################
#       Mail the Report        #
################################

function MailReport {
    param (
        [ValidateSet("TXT","HTML")]
        [String] $MessageContentType = "HTML"
    )
    $message = New-Object System.Net.Mail.MailMessage
    $mailer = New-Object System.Net.Mail.SmtpClient ($AdamjMailReportSMTPServer, $AdamjMailReportSMTPPort)
    $mailer.EnableSSL = $AdamjMailReportSMTPServerEnableSSL
    if ($AdamjMailReportSMTPServerUsername -ne "") {
        $mailer.Credentials = New-Object System.Net.NetworkCredential($AdamjMailReportSMTPServerUsername, $AdamjMailReportSMTPServerPassword)
    }
    $message.From = $AdamjMailReportEmailFromAddress
    $message.To.Add($AdamjMailReportEmailToAddress)
    $message.Subject = $AdamjMailReportEmailSubject
    $message.Body = if ($MessageContentType -eq "HTML") { $AdamjBodyHTML } else { $AdamjBodyTXT }
    $message.IsBodyHtml = if ($MessageContentType -eq "HTML") { $True } else { $False }
    $mailer.send(($message))
}
#endregion MailReport

#region HelpMe
################################
#           Help Me            #
################################

function HelpMe {
    ((Get-CimInstance Win32_OperatingSystem) | Format-List @{Name="OS Name";Expression={$_.Caption}}, @{Name="OS Architecture";Expression={$_.OSArchitecture}}, @{Name="Version";Expression={$_.Version}}, @{Name="ServicePackMajorVersion";Expression={$_.ServicePackMajorVersion}}, @{Name="ServicePackMinorVersion";Expression={$_.ServicePackMinorVersion}} | Out-String).Trim()
    Write-Output "PowerShell Version: $($PSVersionTable.PSVersion.ToString())"
    Write-Output "WSUS Version: $($AdamjWSUSServerAdminProxy.Version)"
    Write-Output "Replica Server: $($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer)"
    Write-Output "The path to the WSUS Content folder is: $($AdamjWSUSServerAdminProxy.GetConfiguration().LocalContentCachePath)"
    Write-Output "Free Space on the WSUS Content folder Volume is: $((Get-DiskFree -Format | ? { $_.Type -like '*fixed*' } | Where-Object { ($_.Vol -eq ($AdamjWSUSServerAdminProxy.GetConfiguration().LocalContentCachePath).split("\")[0]) }).Avail)"
    Write-Output "All Volumes on the WSUS Server:"
    (Get-DiskFree -Format | Out-String).Trim()
    Write-Output ".NET Installed Versions"
    (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name Version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Format-Table PSChildName, Version -AutoSize | Out-String).Trim()
    Write-Output "============================="
    Write-Output "All My Functions"
    Write-Output "============================="
    Show-MyFunctions
    Write-Output "============================="
    Write-Output "All My Variables"
    Write-Output "============================="
    Show-MyVariables
    Write-Output "============================="
    Write-Output " End of HelpMe Stream"
    Write-Output "============================="

}
#endregion HelpMe

#region Process The Functions
################################
#    Process the Functions     #
################################

if ($FirstRun -eq $True) {
    CreateAdamjHeader
    Write-Output "Executing WSUSIndexOptimization"; WSUSIndexOptimization
    if ($AdamjRemoveWSUSDriversInFirstRun -eq $True) { Write-Output "Executing RemoveWSUSDrivers"; RemoveWSUSDrivers -SQL }
    Write-Output "Executing RemoveObsoleteUpdates"; RemoveObsoleteUpdates
    Write-Output "Executing CompressUpdateRevisions"; CompressUpdateRevisions
    Write-Output "Executing DeclineMultipleTypesOfUpdates"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { DeclineMultipleTypesOfUpdates -Force } else { Write-Output "This WSUS Server is a Replica Server. You can't decline updates from a replica server. Skipping this stream." }
    Write-Output "Executing CleanUpWSUSSynchronizationLogs"; if ($AdamjCleanUpWSUSSynchronizationLogsAll -eq $True) { CleanUpWSUSSynchronizationLogs -All } else { CleanUpWSUSSynchronizationLogs -ConsistencyNumber $AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber -ConsistencyTime $AdamjCleanUpWSUSSynchronizationLogsConsistencyTime }
    if ($AdamjComputerObjectCleanup -eq $True) { Write-Output "Executing ComputerObjectCleanup"; ComputerObjectCleanup }
    Write-Output "Executing WSUSDBMaintenance"; WSUSDBMaintenance
    Write-Output "Executing WSUSServerCleanupWizard"; WSUSServerCleanupWizard
    Write-Output "Executing Install-Task"; Install-Task;
    CreateAdamjFooter
    AdamjScriptDifferenceInTime
    CreateBodyTXT
    CreateBodyHTML
    if ($AdamjMailReport -eq $True) { MailReport $AdamjMailReportType }
    SaveReport

}
if ($MonthlyRun -eq $True) {
    CreateAdamjHeader
    Write-Output "Executing RemoveObsoleteUpdates"; RemoveObsoleteUpdates
    Write-Output "Executing CompressUpdateRevisions"; CompressUpdateRevisions
    Write-Output "Executing DeclineMultipleTypesOfUpdates"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { DeclineMultipleTypesOfUpdates -Force } else { Write-Output "This WSUS Server is a Replica Server. You can't decline updates from a replica server. Skipping this stream." }
    Write-Output "Executing CleanUpWSUSSynchronizationLogs"; if ($AdamjCleanUpWSUSSynchronizationLogsAll -eq $True) { CleanUpWSUSSynchronizationLogs -All } else { CleanUpWSUSSynchronizationLogs -ConsistencyNumber $AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber -ConsistencyTime $AdamjCleanUpWSUSSynchronizationLogsConsistencyTime }
    if ($AdamjComputerObjectCleanup -eq $True) { Write-Output "Executing ComputerObjectCleanup"; ComputerObjectCleanup }
    Write-Output "Executing WSUSDBMaintenance"; WSUSDBMaintenance
    Write-Output "Executing WSUSServerCleanupWizard"; WSUSServerCleanupWizard
    CreateAdamjFooter
    AdamjScriptDifferenceInTime
    CreateBodyTXT
    CreateBodyHTML
    if ($AdamjMailReport -eq $True) { MailReport $AdamjMailReportType }
    if ($AdamjSaveReport -eq $True) { SaveReport $AdamjSaveReportType }
}
if ($QuarterlyRun -eq $True) {
    CreateAdamjHeader
    Write-Output "Executing RemoveObsoleteUpdates"; RemoveObsoleteUpdates
    Write-Output "Executing CompressUpdateRevisions"; CompressUpdateRevisions
    Write-Output "Executing DeclineMultipleTypesOfUpdates"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { DeclineMultipleTypesOfUpdates -Force } else { Write-Output "This WSUS Server is a Replica Server. You can't decline updates from a replica server. Skipping this stream." }
    Write-Output "Executing CleanUpWSUSSynchronizationLogs"; if ($AdamjCleanUpWSUSSynchronizationLogsAll -eq $True) { CleanUpWSUSSynchronizationLogs -All } else { CleanUpWSUSSynchronizationLogs -ConsistencyNumber $AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber -ConsistencyTime $AdamjCleanUpWSUSSynchronizationLogsConsistencyTime }
    if ($AdamjRemoveWSUSDriversInRoutines -eq $True) { Write-Output "Executing RemoveWSUSDrivers"; RemoveWSUSDrivers }
    Write-Output "Executing RemoveDeclinedWSUSUpdates"; RemoveDeclinedWSUSUpdates -Display -Proceed
    if ($AdamjComputerObjectCleanup -eq $True) { Write-Output "Executing ComputerObjectCleanup"; ComputerObjectCleanup }
    Write-Output "Executing WSUSDBMaintenance"; WSUSDBMaintenance
    Write-Output "Executing WSUSServerCleanupWizard"; WSUSServerCleanupWizard
    CreateAdamjFooter
    AdamjScriptDifferenceInTime
    CreateBodyTXT
    CreateBodyHTML
    if ($AdamjMailReport -eq $True) { MailReport $AdamjMailReportType }
    if ($AdamjSaveReport -eq $True) { SaveReport $AdamjSaveReportType }
}
if ($ScheduledRun -eq $True) {
    $DateNow = Get-Date
    CreateAdamjHeader
    if ($AdamjScheduledRunStreamsDay -gt 31 -or $AdamjScheduledRunStreamsDay -eq 0) { Write-Output 'You failed to set a valid value for $AdamjScheduledRunStreamsDay. Setting to 31'; $AdamjScheduledRunStreamsDay = 31 }
    if ($AdamjScheduledRunStreamsDay -eq $DateNow.Day) { Write-Output "Executing RemoveObsoleteUpdates"; RemoveObsoleteUpdates }
    if ($AdamjScheduledRunStreamsDay -eq $DateNow.Day) { Write-Output "Executing CompressUpdateRevisions"; CompressUpdateRevisions }
    Write-Output "Executing DeclineMultipleTypesOfUpdates"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { DeclineMultipleTypesOfUpdates } else { Write-Output "This WSUS Server is a Replica Server. You can't decline superseded updates from a replica server. Skipping this stream."}
    Write-Output "Executing CleanUpWSUSSynchronizationLogs"; if ($AdamjCleanUpWSUSSynchronizationLogsAll -eq $True) { CleanUpWSUSSynchronizationLogs -All } else { CleanUpWSUSSynchronizationLogs -ConsistencyNumber $AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber -ConsistencyTime $AdamjCleanUpWSUSSynchronizationLogsConsistencyTime }
    $AdamjScheduledRunQuarterlyMonths.Split(",") | ForEach-Object {
	    if ($_ -eq $DateNow.Month) {
		    if ($_ -eq 2) {
                if ($AdamjScheduledRunStreamsDay -gt 28 -and [System.DateTime]::isleapyear($DateNow.Year) -eq $True) { $AdamjScheduledRunStreamsDay = 29 }
                else { $AdamjScheduledRunStreamsDay = 28 }
		    }
		    if (4,6,9,11 -contains $_ -and $AdamjScheduledRunStreamsDay -gt 30) { $AdamjScheduledRunStreamsDay = 30 }
            if ($AdamjScheduledRunStreamsDay -eq $DateNow.Day) {
			    if ($AdamjRemoveWSUSDriversInRoutines -eq $True) { Write-Output "Executing RemoveWSUSDrivers"; RemoveWSUSDrivers }
			    Write-Output "Executing RemoveDeclinedWSUSUpdates"; RemoveDeclinedWSUSUpdates -Display -Proceed
		    }
	    }
    }
    if ($AdamjComputerObjectCleanup -eq $True) { Write-Output "Executing ComputerObjectCleanup"; ComputerObjectCleanup }
    Write-Output "Executing WSUSDBMaintenance"; if ($AdamjScheduledRunStreamsDay -eq $DateNow.Day) { WSUSDBMaintenance } else { WSUSDBMaintenance -NoOutput }
    Write-Output "Executing WSUSServerCleanupWizard"; WSUSServerCleanupWizard
    CreateAdamjFooter
    AdamjScriptDifferenceInTime
    CreateBodyTXT
    CreateBodyHTML
    if ($AdamjMailReport -eq $True) { MailReport $AdamjMailReportType }
    if ($AdamjSaveReport -eq $True) { SaveReport $AdamjSaveReportType }
}
if ($DailyRun -eq $True) {
    CreateAdamjHeader
    Write-Output "Executing DeclineMultipleTypesOfUpdates"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { DeclineMultipleTypesOfUpdates } else { Write-Output "This WSUS Server is a Replica Server. You can't decline updates from a replica server. Skipping this stream." }
    Write-Output "Executing CleanUpWSUSSynchronizationLogs"; if ($AdamjCleanUpWSUSSynchronizationLogsAll -eq $True) { CleanUpWSUSSynchronizationLogs -All } else { CleanUpWSUSSynchronizationLogs -ConsistencyNumber $AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber -ConsistencyTime $AdamjCleanUpWSUSSynchronizationLogsConsistencyTime }
    if ($AdamjComputerObjectCleanup -eq $True) { Write-Output "Executing ComputerObjectCleanup"; ComputerObjectCleanup }
    Write-Output "Executing WSUSDBMaintenance"; WSUSDBMaintenance
    Write-Output "Executing WSUSServerCleanupWizard"; WSUSServerCleanupWizard
    CreateAdamjFooter
    AdamjScriptDifferenceInTime
    CreateBodyTXT
    CreateBodyHTML
    if ($AdamjMailReport -eq $True) { MailReport $AdamjMailReportType }
    if ($AdamjSaveReport -eq $True) { SaveReport $AdamjSaveReportType }
}
if (-not $FirstRun -and -not $MonthlyRun -and -not $QuarterlyRun -and -not $ScheduledRun -and -not $DailyRun) {
    Write-Verbose "All pre-defined routines (-FirstRun, -DailyRun, -MonthlyRun, -QuarterlyRun, -ScheduledRun) were not specified"
    CreateAdamjHeader
    if ($WSUSIndexOptimization -eq $True) { Write-Output "Executing WSUSIndexOptimization"; WSUSIndexOptimization }
    if ($RemoveWSUSDriversSQL -eq $True) { Write-Output "Executing RemoveWSUSDrivers using SQL"; RemoveWSUSDrivers -SQL }
    if ($RemoveWSUSDriversPS -eq $True) { Write-Output "Executing RemoveWSUSDrivers using PowerShell"; RemoveWSUSDrivers }
    if ($RemoveObsoleteUpdates -eq $True) { Write-Output "Executing RemoveObsoleteUpdates using SQL"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { RemoveObsoleteUpdates } else { Write-Output "This WSUS Server is a Replica Server. You can't remove obsolete updates from a replica server. Skipping this stream." } }
    if ($CompressUpdateRevisions -eq $True) { Write-Output "Executing CompressUpdateRevisions using SQL"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { CompressUpdateRevisions } else { Write-Output "This WSUS Server is a Replica Server. You can't compress update revisions from a replica server. Skipping this stream." } }
    if ($DeclineMultipleTypesOfUpdates -eq $True) { Write-Output "Executing DeclineMultipleTypesOfUpdates"; if ($AdamjWSUSServerAdminProxy.GetConfiguration().IsReplicaServer -eq $False) { DeclineMultipleTypesOfUpdates -Force } else { Write-Output "This WSUS Server is a Replica Server. You can't decline updates from a replica server. Skipping this stream." } }
    if ($CleanUpWSUSSynchronizationLogs -eq $True) { Write-Output "Executing CleanUpWSUSSynchronizationLogs"; if ($AdamjCleanUpWSUSSynchronizationLogsAll -eq $True) { CleanUpWSUSSynchronizationLogs -All } else { CleanUpWSUSSynchronizationLogs -ConsistencyNumber $AdamjCleanUpWSUSSynchronizationLogsConsistencyNumber -ConsistencyTime $AdamjCleanUpWSUSSynchronizationLogsConsistencyTime } }
    if ($RemoveDeclinedWSUSUpdates -eq $True) { Write-Output "Executing RemoveDeclinedWSUSUpdates"; RemoveDeclinedWSUSUpdates -Display -Proceed }
    if ($ComputerObjectCleanup -eq $True -and $AdamjComputerObjectCleanup -eq $True) { Write-Output "Executing ComputerObjectCleanup"; ComputerObjectCleanup }
    if ($WSUSDBMaintenance -eq $True) { Write-Output "Executing WSUSDBMaintenance"; WSUSDBMaintenance }
    if ($DirtyDatabaseCheck) { Write-Output "Executing DirtyDatabaseCheck"; DirtyDatabaseCheck }
    if ($WSUSServerCleanupWizard -eq $True) { Write-Output "Executing WSUSServerCleanupWizard"; WSUSServerCleanupWizard }
    CreateAdamjFooter
    AdamjScriptDifferenceInTime
    CreateBodyTXT
    CreateBodyHTML
    if ($SaveReport -eq "TXT") { SaveReport }
    if ($SaveReport -eq "HTML") { SaveReport -ReportType "HTML" }
    if ($MailReport -eq "HTML") { MailReport }
    if ($MailReport -eq "TXT") { MailReport -MessageContentType "TXT" }
}

if ($HelpMe -eq $True) {
    HelpMe
}
if ($DisplayApplicationPoolMemory -eq $True) {
    ApplicationPoolMemory
}
Write-Verbose "Just before setting the application memory `$SetApplicationPoolMemory is $SetApplicationPoolMemory"
if ($SetApplicationPoolMemory -ne '-1') {
    ApplicationPoolMemory -Set $SetApplicationPoolMemory
}

if ($InstallTask -eq $True) {
    Install-Task
}
#endregion ProcessTheFunctions
}

End {
    if ($HelpMe -eq $True) { $VerbosePreference = $AdamjOldVerbose; Stop-Transcript }
    Write-Verbose "End Of Code"
}
################################
#         End Of Code          #
################################
#EOF