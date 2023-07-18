
# This script will query all mailboxes on the server name you supply. It returns 
# the Display Name, Total Mailbox size in MBs, Item count (number of messages in the mailbox),
# and the Storage Limit Status (has the user met the limit or not) sorted by the mailbox size.
# The script writes all this info to the mailbox_size.csv in the directory you input.
#
# Tested on Windows Server 2K8 running Exchange 2010 SP2.  


$dir = read-host "Directory to save the CSV file"
$server = read-host "Exchange Server Name"

add-pssnapin Microsoft.Exchange.Management.PowerShell.E2010

get-mailboxstatistics -server $server | where {$_.ObjectClass -eq "Mailbox"} | 
Select DisplayName,TotalItemSize,ItemCount,StorageLimitStatus | 
Sort-Object TotalItemSize -Desc |
export-csv "$dir\mailbox_size.csv"