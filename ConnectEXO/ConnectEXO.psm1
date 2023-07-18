# to install go to directory and type ". .\mod.ConnectEXO.ps1" Yes with the extra dot, and no, no quotes. Or add to %windir%\System32\WindowsPowerShell\v1.0\Modules\FolderwithSameNameAsFile\File.psm1
Function Connect-EXO {
Set-ExecutionPolicy RemoteSigned

$UserCredential = Get-Credential

Connect-ExchangeOnline -Credential $UserCredential

ping 127.0.0.1 -n 5 >$null

Connect-MsolService –Credential $UserCredential

ping 127.0.0.1 -n 5 >$null

Connect-AzureAD –Credential $UserCredential

ping 127.0.0.1 -n 5 >$null
}


#old method - $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Authentication Basic -AllowRedirection -Credential $UserCredential
#old method - Import-PSSession $session
