# Prompt the user for their Microsoft 365 admin username
$adminUsername = Read-Host "Enter Microsoft 365 administrator email"

# Prompt the user for their Microsoft 365 admin password
$adminPassword = Read-Host -AsSecureString "Enter Microsoft 365 administrator password"

# Convert the secure string password to plain text
# $adminPasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminPassword))

# Connect to Microsoft 365 Graph PowerShell using the provided credentials
$credential = New-Object System.Management.Automation.PSCredential($adminUsername, $adminPassword)
Connect-MgGraph -Credential $credential -Scopes User.ReadWrite.All, Organization.Read.All, Domain.ReadWrite.All

Write-Host "Successfully connected to Microsfot Graph PowerShell."

do
{
	#Hardcode lab variables
	$labNumber = Read-Host -Prompt "Enter your O365Ready.com 5-digit lab code"
	$labDomain = "lab" + $labNumber + ".o365ready.com"
	$labDomainIP = (Resolve-DnsName -Name $labDomain).IPAddress

	Write-Host "`nLab Number: $labNumber"
	Write-Host "Lab Domain: $labDomain"
	Write-Host "IP Address: $labDomainIP"

	$DataValidated = Read-Host "`n`nAre these values correct (y/n)?"

} while ($DataValidated -ieq 'n' -or $DataValidated -ieq 'no')

# Hardcode RRAS variables
$RRAS = "MS720-RRAS01"

# Create Lab Domain Zone
$SecureLocalPassword = $LocalAdminPass | ConvertTo-SecureString -AsPlainText -Force
$localCred = Get-Credential -Credential Administrator
$Cimsession = New-CimSession -Name $RRAS -ComputerName $RRAS -Credential $localCred -Authentication Negotiate
$PublicDNSZone = (Get-DnsServerZone -ComputerName $RRAS -CimSession $Cimsession).ZoneName

If ($PublicDNSZone -notcontains $labDomain)
{ 
	Add-DnsServerPrimaryZone -ComputerName $RRAS -CimSession $Cimsession -Name $labDomain -ZoneFile "$labDomain.dns"
	Start-Sleep -s 5
}

# Create new hosts in the lab domain DNS zones

$OldSOARecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType SOA
$NewSOARecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType SOA
$NewSOARecord.RecordData.PrimaryServer = "$labDomain."

Set-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -NewInputObject $NewSOARecord -OldInputObject $OldSOARecord -ZoneName $labDomain
Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -NS -Name $labDomain -NameServer $labDomain
Remove-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType NS -RecordData $RRAS -Name "@" -Force

Add-DnsServerResourceRecordA -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $labDomain -IPv4Address $labDomainIP
#Add-DnsServerResourceRecordA -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name sbc01 -IPv4Address $labDomainIP
Add-DnsServerResourceRecordMX -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "." -MailExchange "$($labDomain.Split(".") -join "-").mail.protection.outlook.com" -Preference 5
Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "@" -Txt -DescriptiveText "v=spf1 include:spf.protection.outlook.com -all"
Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "autodiscover" -HostNameAlias "autodiscover.outlook.com"
Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "sip" -HostNameAlias "sipdir.online.lync.com"
Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "lyncdiscover" -HostNameAlias "webdir.online.lync.com"
Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "enterpriseregistration" -HostNameAlias "enterpriseregistration.windows.net"
Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "enterpriseenrollment" -HostNameAlias "enterpriseenrollment.manage.microsoft.com"
Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Srv -Name "_sip._tls" -DomainName "sipdir.online.lync.com" -Priority 100 -Weight 1 -Port 443
Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Srv -Name "_sipfederationtls._tcp" -DomainName "sipfed.online.lync.com" -Priority 100 -Weight 1 -Port 5061
Set-DnsServerRecursion -ComputerName $RRAS -CimSession $Cimsession -Enable $False

# Add lab domain to Microsoft 365 tenant
$domainParams = @{
    id = $labDomain;
    IsDefault = "True"
}
New-MgDomain -BodyParameter $domainParams

# Remove any existing certificate requests in case of previous failure
Get-ChildItem "Cert:\localmachine\request" | where { $_.Subject -eq "CN=sbc01.$labDomain" } | Remove-Item
Get-ChildItem "C:\LabFiles\CertReq-$labDomain.txt" | Remove-Item
Get-ChildItem | Where-Object { $_.Subject -like "CN=sbc01.$LabDomain" } | Remove-Item

$CertRequestSig = '$Windows NT$' # Used to avoid escaping the $ character in $infContent

# Create the certreq.exe INF file structure
$infContent = @"
[Version]
Signature = $CertRequestSig
[NewRequest]
FriendlyName = Lab Certificate
Subject = CN=sbc01.$labDomain
Exportable = TRUE
KeyLength = 2048
KeySpec = 1
KeyUsage = 0xA0
MachineKeySet = True
ProviderName = Microsoft RSA SChannel Cryptographic Provider
RequestType = PKCS10
[EnhancedKeyUsageExtension]
OID=1.3.6.1.5.5.7.3.1 ; Server Authentication
OID=1.3.6.1.5.5.7.3.2 ; Client Authentication
[Extensions]
2.5.29.17 = "{text}"
_continue_ = "dns=sbc01.$labDomain&"
_continue_ = "dns=$labDomain&"
"@

# Save the INF file
$infFileName = "sbc01.inf"
$infFilePath = "C:\LabFiles\" + $infFileName
$infContent | Out-File -FilePath $infFilePath

# Request the certificate using certreq.exe using $infFilePath as the input
$certReqFilePath = "C:\LabFiles\CertReq-$labDomain.txt"
$certRequestCommand = "CertReq -New $infFilePath $certReqFilePath"
Invoke-Expression -Command $certRequestCommand

# Output the contents of the certificate request
# $certReqFileContent = Get-Content -Path $certReqFile
# Write-Output $certReqFileContent

# Update SBC ini file
Write-Output "Updating SBC ini file"
$sbcinifile = "Lab" + $labNumber + "-SBC01-Config.ini"
Copy-Item "C:\Scripts\Backup\Lab-sbc01-Config.ini" "C:\LabFiles\$sbcinifile" -Force
(Get-Content "C:\LabFiles\$sbcinifile") | ForEach-Object { $_ -replace "XXXXX", "$labNumber" } | Set-Content "C:\LabFiles\$sbcinifile"

# Confirm completion
Write-Output "Lab setup complete."