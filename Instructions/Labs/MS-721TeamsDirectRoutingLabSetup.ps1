cls
Write-Host "This script will configure the lab environment for the MS-721 Teams Direct Routing lab." -ForegroundColor Yellow
Write-Host "`nEnter your Microsoft 365 Administrator credentials to connect to Microsoft Graph PowerShell and check the box to give consent to Graph." -ForegroundColor Yellow

Connect-MgGraph -Scopes "User.ReadWrite.All", "Organization.Read.All", "Domain.ReadWrite.All" -NoWelcome

Write-Host "`nSuccessfully connected to Microsfot Graph PowerShell."

do {
    #Hardcode lab variables
    $labNumber = Read-Host -Prompt "`nEnter your O365Ready.com 5-digit lab code"
    $labDomain = "lab" + $labNumber + ".o365ready.com"
    $labDomainIP = (Resolve-DnsName -Name myip.opendns.com -Server resolver1.opendns.com).IPAddress

    Write-Host "`nLab Number: $labNumber"
    Write-Host "Lab Domain: $labDomain"
    Write-Host "IP Address: $labDomainIP"

    $DataValidated = Read-Host "`n`nAre these values correct (y/n)?"

} while ($DataValidated -ieq 'n' -or $DataValidated -ieq 'no')

# Hardcode RRAS variables
$RRAS = "MS720-RRAS01"
Write-Host "`n`nEnter the password for the local Administrator account on MS721-RRAS01." -ForegroundColor Yellow

# Create Lab Domain Zone
$localCred = Get-Credential -Credential Administrator
$Cimsession = New-CimSession -Name $RRAS -ComputerName $RRAS -Credential $localCred -Authentication Negotiate
$PublicDNSZone = (Get-DnsServerZone -ComputerName $RRAS -CimSession $Cimsession).ZoneName

Write-Host "`n`nConnected to MS721-RRAS01 successfully.  Creating DNS records for $labDomain and adding to Microsoft 365." -ForegroundColor Green

If ($PublicDNSZone -notcontains $labDomain) { 
    Add-DnsServerPrimaryZone -ComputerName $RRAS -CimSession $Cimsession -Name $labDomain -ZoneFile "$labDomain.dns"
    Start-Sleep -s 5

    # Create new hosts in the lab domain DNS zones

    $OldSOARecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType SOA
    $NewSOARecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType SOA
    $NewSOARecord.RecordData.PrimaryServer = "$labDomain."

    Set-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -NewInputObject $NewSOARecord -OldInputObject $OldSOARecord -ZoneName $labDomain
    Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -NS -Name $labDomain -NameServer $labDomain
    Remove-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType NS -RecordData $RRAS -Name "@" -Force

    # Add lab domain to Microsoft 365 tenant if it doesn't already exist
    $existingDomains = Get-MgDomain
    $domainExists = $existingDomains | Where-Object { $_.Id -eq $labDomain }

    if ($domainExists) {
        Write-Host "`n`n$labDomain already exists in the Microsoft 365 tenant. Skipping domain creation." -ForegroundColor Yellow
    }
    else {
        $domainParams = @{
            id        = $labDomain;
            IsDefault = "True"
        }
        $domainAdded = New-MgDomain -BodyParameter $domainParams

        # Get the verification code for the domain
        $labDomainVerificationCode = (Get-MgDomainVerificationDnsRecord -DomainId "$labDomain" | Where-Object { $_.RecordType -eq "Txt" }).AdditionalProperties.text
        Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "@" -Txt -DescriptiveText "$labDomainVerificationCode"
        Write-Host "`tTXT Verification record created successfully for $labDomain." -ForegroundColor Green

        Add-DnsServerResourceRecordA -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $labDomain -IPv4Address $labDomainIP
        Write-Host "`tDNS A record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecordMX -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "." -MailExchange "$($labDomain.Split(".") -join "-").mail.protection.outlook.com" -Preference 5
        Write-Host "`tDNS MX record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "@" -Txt -DescriptiveText "v=spf1 include:spf.protection.outlook.com -all"
        Write-Host "`tTXT SPF record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "autodiscover" -HostNameAlias "autodiscover.outlook.com"
        Write-Host "`tCNAME autodiscover record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "sip" -HostNameAlias "sipdir.online.lync.com"
        Write-Host "`tCNAME sip record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "lyncdiscover" -HostNameAlias "webdir.online.lync.com"
        Write-Host "`tCNAME lyncdiscover record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "enterpriseregistration" -HostNameAlias "enterpriseregistration.windows.net"
        Write-Host "`tCNAME enterpriseregistration record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "enterpriseenrollment" -HostNameAlias "enterpriseenrollment.manage.microsoft.com"
        Write-Host "`tCNAME enterpriseenrollment record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Srv -Name "_sip._tls" -DomainName "sipdir.online.lync.com" -Priority 100 -Weight 1 -Port 443
        Write-Host "`tSRV _sip._tls record created successfully for $labDomain." -ForegroundColor Green
        
        Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Srv -Name "_sipfederationtls._tcp" -DomainName "sipfed.online.lync.com" -Priority 100 -Weight 1 -Port 5061
        Write-Host "`tSRV _sipfederationtls._tcp record created successfully for $labDomain." -ForegroundColor Green
        
        Set-DnsServerRecursion -ComputerName $RRAS -CimSession $Cimsession -Enable $False

        Start-Sleep -s 10
        $domainVerified = Confirm-MgDomain -DomainId "$labDomain"
        if ($domainVerified) { 
            Write-Host "`t$labDomain successfully verified in the Microsoft 365 tenant." -ForegroundColor Green }
        else { Write-Host "`t$labDomain failed to verify in the Microsoft 365 tenant." -ForegroundColor Red }

        Write-Host "`n`nSuccessfully created and verified $labDomain in the Microsoft 365 tenant." -ForegroundColor Green
    }
}
Else {
    Write-Host "`n`n$labDomain already exists in DNS. Skipping DNS zone creation." -ForegroundColor Yellow
}

# Remove any existing certificate requests in case of previous failure
Get-ChildItem "Cert:\localmachine\request" | where { $_.Subject -eq "CN=sbc01.$labDomain" } | Remove-Item
Get-ChildItem | Where-Object { $_.Subject -like "CN=sbc01.$LabDomain" } | Remove-Item

# Create the certreq.exe INF file structure
$CertRequestSig = '$Windows NT$' # Used to avoid escaping the $ character in $infContent
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
if (Test-Path $certReqFilePath) {
    Remove-Item $certReqFilePath
}
$certRequestCommand = "CertReq -New $infFilePath $certReqFilePath"
$requestResults = Invoke-Expression -Command $certRequestCommand

# Output the contents of the certificate request
$certReqFileContent = Get-Content -Path $certReqFilePath
Write-Host "`nCSR generated successfully:`n`n" -ForegroundColor Green
Write-Output $certReqFileContent

# Update SBC ini file
#Write-Output "Updating SBC ini file"
#$sbcinifile = "Lab" + $labNumber + "-SBC01-Config.ini"
#Copy-Item "C:\Scripts\Backup\Lab-sbc01-Config.ini" "C:\LabFiles\$sbcinifile" -Force
#(Get-Content "C:\LabFiles\$sbcinifile") | ForEach-Object { $_ -replace "XXXXX", "$labNumber" } | Set-Content "C:\LabFiles\$sbcinifile"

# Confirm completion
Write-Host "`nLab setup complete. Copy your CSR from the output above and submit it to your certificate authority.`n" -ForegroundColor Green