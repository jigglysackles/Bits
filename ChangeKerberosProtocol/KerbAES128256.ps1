$ADUserList = Get-ADUser -SearchBase "OU=DIERKS,dc=bbisd,dc=org" -Filter *

foreach ($ADUser in $ADUserList) {

   Set-ADUser -Identity $ADUser -KerberosEncryptionType "AES128, AES256"

}

## END OF SCRIPT
