<#
.SYNOPSIS
This script will configure the lab environment for MS-721 Lab 3: Expand your Teams Voice Environment to use Direct Routing.

.DESCRIPTION
This script is used to automate the configuration of the lab environment for MS-721 Lab 3: Expand your Teams Voice Environment to use Direct Routing. It performs the following tasks:
- Connects to Microsoft Graph PowerShell using the provided Microsoft 365 Administrator credentials.
- Creates a DNS zone and Microsoft 365 DNS records on the MS720-RRAS01 DNS server for the lab domain.
- Checks if the lab domain already exists in the Microsoft 365 tenant and creates it if it doesn't.
- Verifies the lab domain in the Microsoft 365 tenant.
- Generates a certificate signing request (CSR) for the lab domain.

.EXAMPLE
.\MS-721TeamsDirectRoutingLabSetup.ps1
This example demonstrates how to run the script with the specified input parameter.

.NOTES
Author: Darrin Hanson (dahans@microsoft.com)
Date: 12/15/2023
Version: 2.0
#>

# Hardcode RRAS variables
$RRAS = "MS720-RRAS01"

function Add-RRASDnsRecord {
    [CmdletBinding(DefaultParameterSetName='TXT')]
    param(
        [Parameter(Mandatory=$true, ParameterSetName='TXT')]
        [string]$DescriptiveText,

        [Parameter(Mandatory=$true, ParameterSetName='CNAME')]
        [string]$RecordName,

        [Parameter(Mandatory=$true, ParameterSetName='CNAME')]
        [string]$HostNameAlias,

        [Parameter(Mandatory=$true, ParameterSetName='A')]
        [string]$IPv4Address,

        [Parameter(Mandatory=$true, ParameterSetName='MX')]
        [int]$Preference,

        [Parameter(Mandatory=$true, ParameterSetName='SRV')]
        [string]$SrvName,

        [Parameter(Mandatory=$true, ParameterSetName='SRV')]
        [string]$DomainName,

        [Parameter(Mandatory=$true, ParameterSetName='SRV')]
        [int]$Port,

        [Parameter(Mandatory=$true, ParameterSetName='NS')]
        [string]$NameServer
    )

    switch ($PSCmdlet.ParameterSetName) {
        'TXT' {
            $existingRecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "@" -ErrorAction SilentlyContinue | Where-Object { $_.DescriptiveText -eq $DescriptiveText }

            if ($existingRecord) {
                Write-Host "The TXT record already exists."
            } else {
                Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "@" -Txt -DescriptiveText $DescriptiveText
                Write-Host "`tTXT $DescriptiveText record created successfully for $labDomain." -ForegroundColor Green
            }
        }
        'CNAME' {
            $existingRecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $RecordName -ErrorAction SilentlyContinue | Where-Object { $_.HostNameAlias -eq $HostNameAlias }

            if ($existingRecord) {
                Write-Host "The CNAME record already exists."
            } else {
                Add-DnsServerResourceRecordCName -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $RecordName -HostNameAlias $HostNameAlias
                Write-Host "`tCNAME $RecordName record created successfully for $labDomain." -ForegroundColor Green
            }
        }
        'A' {
            $existingRecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $labDomain -ErrorAction SilentlyContinue | Where-Object { $_.IPv4Address -eq $IPv4Address }

            if ($existingRecord) {
                Write-Host "The A record already exists."
            } else {
                Add-DnsServerResourceRecordA -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $labDomain -IPv4Address $IPv4Address
                Write-Host "`tA $labDomain record created successfully for $labDomain." -ForegroundColor Green
            }
        }
        'MX' {
            $existingRecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "." -RRType MX -ErrorAction SilentlyContinue

            if ($existingRecord) {
                Write-Host "The MX record already exists."
            } else {
                Add-DnsServerResourceRecordMX -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name "." -MailExchange "$($labDomain.Split(".") -join "-").mail.protection.outlook.com" -Preference $Preference
                Write-Host "`tMX record created successfully for $labDomain." -ForegroundColor Green
            }
        }
        'SRV' {
            $existingRecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $SrvName -ErrorAction SilentlyContinue | Where-Object { $_.DomainName -eq $DomainName } 

            if ($existingRecord) {
                Write-Host "The SRV record already exists."
            } else {
                Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Srv -Name $SrvName -DomainName $DomainName -Priority 100 -Weight 1 -Port $Port
                Write-Host "`tSRV $SrvName record created successfully for $labDomain." -ForegroundColor Green
            }
        }
        'NS' {
            $existingRecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -Name $labDomain -ErrorAction SilentlyContinue | Where-Object { $_.NameServer -eq $NameServer }  

            if ($existingRecord) {
                Write-Host "The NS record already exists."
            } else {
                Add-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -NS -Name $labDomain -NameServer $NameServer
                Write-Host "`tNS $labDomain record created successfully for $labDomain." -ForegroundColor Green
            }
            
        }
    }
}

# BEGIN SCRIPT
# Clear the screen and display the script title
Clear-Host
Write-Host "This script will configure the lab environment for the MS-721 Teams Direct Routing lab." -ForegroundColor Yellow
Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Check for Microsoft.Graph PowerShell modules and install if not present
$modulesInstalled = Get-Module -ListAvailable -Name Microsoft.Graph.* -ErrorAction SilentlyContinue

if ($modulesInstalled) {
    Write-Host "Microsoft.Graph PowerShell modules are already installed." -ForegroundColor Green
} else {
    Write-Host "Microsoft.Graph PowerShell modules are not installed. Installing..." -ForegroundColor Yellow
    Install-Module -Name Microsoft.Graph -Force -AllowClobber
    Write-Host "Microsoft.Graph PowerShell modules installed successfully." -ForegroundColor Green
}

# Login to Microsoft Graph PowerShell with User.ReadWrite.All, Organization.Read.All, and Domain.ReadWrite.All permissions
Write-Host "`nEnter your Microsoft 365 Administrator credentials to connect to Microsoft Graph PowerShell and check the box to give consent to Graph." -ForegroundColor Yellow
Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

try {
    Connect-MgGraph -Scopes "User.ReadWrite.All", "Organization.Read.All", "Domain.ReadWrite.All" -NoWelcome
    Write-Host "`nSuccessfully connected to Microsfot Graph PowerShell."
} catch {
    Write-Host "`n`nError connecting to Microsoft Graph PowerShell.  Please check your credentials and try again." -ForegroundColor Red
    Write-Host "Error details: $_" -ForegroundColor Red
    Exit
}

Write-Host "`nConnecting to MS721-RRAS01 to create DNS zone and records." -ForegroundColor Yellow
Write-Host "`nEnter the password for the local Administrator account on MS721-RRAS01." -ForegroundColor Yellow
Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Create CIM session using local Administrator credentials on RRAS01
try {
    
    $localCred = Get-Credential -Credential Administrator
    $Cimsession = New-CimSession -Name $RRAS -ComputerName $RRAS -Credential $localCred -Authentication Negotiate
    $PublicDNSZone = (Get-DnsServerZone -ComputerName $RRAS -CimSession $Cimsession).ZoneName
    Write-Host "`n`nSuccessfully connected to MS721-RRAS01." -ForegroundColor Green
} catch {
    Write-Host "`n`nError occurred while establishing a CIM session with $RRAS. Please check the credentials and try again." -ForegroundColor Red
    Write-Host "Reminder: Enter the local Administrator account credentials for $RRAS." -ForegroundColor Yellow
    Write-Host "Error details: $_" -ForegroundColor Red
    Exit
}


# Repeat until the lab number, lab domain, and lab domain IP address are correct.
do {
    #Hardcode lab variables
    $labNumber = Read-Host -Prompt "`nEnter your O365Ready.com 5-digit lab code"
    $labDomain = "lab" + $labNumber + ".o365ready.com"
    $labDomainIP = (Resolve-DnsName -Name myip.opendns.com -Server resolver1.opendns.com).IPAddress

    Write-Host "`nLab Number: $labNumber" -ForegroundColor Yellow
    Write-Host "Lab Domain: $labDomain" -ForegroundColor Yellow
    Write-Host "IP Address: $labDomainIP" -ForegroundColor Yellow

    $DataValidated = Read-Host "`n`nAre these values correct (y/n)?"

} while ($DataValidated -ieq 'n' -or $DataValidated -ieq 'no')

# If the DNS zone already exists on the server (from a previous lab run), delete it and recreate it.
If ($PublicDNSZone -contains $labDomain) {
    Write-Host "`n$labDomain already exists in DNS. Deleting DNS Zone and recreating." -ForegroundColor Yellow
    Remove-DnsServerZone -ComputerName $RRAS -CimSession $Cimsession -Name $labDomain -Force
    Start-Sleep -s 5
}

Write-Host "`nChecking for Microsoft 365 DNS records and adding to MS721-RRA01 if not present." -ForegroundColor Yellow

# Create the DNS zone on the server
Add-DnsServerPrimaryZone -ComputerName $RRAS -CimSession $Cimsession -Name $labDomain -ZoneFile "$labDomain.dns"

# Create new hosts in the lab domain DNS zones
$OldSOARecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType SOA
$NewSOARecord = Get-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType SOA
$NewSOARecord.RecordData.PrimaryServer = "$labDomain."

# Update the SOA record
Set-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -NewInputObject $NewSOARecord -OldInputObject $OldSOARecord -ZoneName $labDomain
Add-RRASDnsRecord -NameServer $labDomain
Remove-DnsServerResourceRecord -ComputerName $RRAS -CimSession $Cimsession -ZoneName $labDomain -RRType NS -RecordData $RRAS -Name "@" -Force

# Add the individual DNS records for Microsoft 365 services
Add-RRASDnsRecord -IPv4Address $labDomainIP
Add-RRASDnsRecord -Preference 5
Add-RRASDnsRecord -DescriptiveText "v=spf1 include:spf.protection.outlook.com -all"
Add-RRASDnsRecord -RecordName "autodiscover" -HostNameAlias "autodiscover.outlook.com"
Add-RRASDnsRecord -RecordName "sip" -HostNameAlias "sipdir.online.lync.com"
Add-RRASDnsRecord -RecordName "lyncdiscover" -HostNameAlias "webdir.online.lync.com"
Add-RRASDnsRecord -RecordName "enterpriseregistration" -HostNameAlias "enterpriseregistration.windows.net"
Add-RRASDnsRecord -RecordName "enterpriseenrollment" -HostNameAlias "enterpriseenrollment.manage.microsoft.com"
Add-RRASDnsRecord -SrvName "_sip._tls" -DomainName "sipdir.online.lync.com" -Port 443
Add-RRASDnsRecord -SrvName "_sipfederationtls._tcp" -DomainName "sipfed.online.lync.com" -Port 5061

# Refresh DNS server cache
Set-DnsServerRecursion -ComputerName $RRAS -CimSession $Cimsession -Enable $False

# Check to see if the lab domain already exists in the Microsoft 365 tenant
$existingDomains = Get-MgDomain
$domainExists = $existingDomains | Where-Object { $_.Id -eq $labDomain }

if ($domainExists) {
    Write-Host "`n`n$labDomain already exists in the Microsoft 365 tenant. Skipping domain creation." -ForegroundColor Yellow
}
else {
    $domainParams = @{
        id = $labDomain;
        IsDefault = "True"
    }

    $domainAdded = New-MgDomain -BodyParameter $domainParams

    # Get the verification code for the domain
    $labDomainVerificationCode = (Get-MgDomainVerificationDnsRecord -DomainId "$labDomain" | Where-Object { $_.RecordType -eq "Txt" }).AdditionalProperties.text
    Add-RRASDnsRecord -DescriptiveText "$labDomainVerificationCode"
    
    Set-DnsServerRecursion -ComputerName $RRAS -CimSession $Cimsession -Enable $False

    Start-Sleep -s 10

    $domainVerified = Confirm-MgDomain -DomainId "$labDomain"

    if ($domainVerified) { 
        Write-Host "Your lab domain - `n$labDomain - has been added to Microsoft 365 and successfully verified." -ForegroundColor Green 
    }
    else { Write-Host "`t$labDomain failed to verify in the Microsoft 365 tenant." -ForegroundColor Red }
}

# Disconnect from Microsoft Graph
$status = Disconnect-MgGraph

Write-Host "`nGenerating certificate signing request (CSR) for $labDomain." -ForegroundColor Yellow
Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Remove any existing certificate requests in case of previous failure
Get-ChildItem "Cert:\localmachine\request" | Where-Object { $_.Subject -eq "CN=sbc01.$labDomain" } | Remove-Item
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

# Save the INF file and create CertReq command
$infFilePath = "C:\LabFiles\sbc01.inf"
$infContent | Out-File -FilePath $infFilePath
$certReqFilePath = "C:\LabFiles\CertReq-$labDomain.txt"
$certRequestCommand = "CertReq -q -New $infFilePath $certReqFilePath"

# Remove any previous certificate request files
if (Test-Path $certReqFilePath) {
    Remove-Item $certReqFilePath
}

# Request the certificate using certreq.exe using $infFilePath as the input
try {
    Invoke-Expression -Command $certRequestCommand

    # Output the contents of the certificate request
    $certReqFileContent = Get-Content -Path $certReqFilePath
    Write-Host "`nCSR generated successfully:`n" -ForegroundColor Green
    Write-Output $certReqFileContent
}
catch {
    Write-Host "`n`nError occurred while creating certificate signing request (CSR)." -ForegroundColor Red
    Write-Host "Error details: $_" -ForegroundColor Red
    Exit
}

# Confirm completion
Write-Host "`nLab setup complete. Copy your CSR from the output above or $certReqFilePath and submit it to DigiCert to obtain your signed SSL certificates for the SBC.`n" -ForegroundColor Green

<#
# Update SBC ini file
#Write-Output "Updating SBC ini file"
#$sbcinifile = "Lab" + $labNumber + "-SBC01-Config.ini"
#Copy-Item "C:\Scripts\Backup\Lab-sbc01-Config.ini" "C:\LabFiles\$sbcinifile" -Force
#(Get-Content "C:\LabFiles\$sbcinifile") | ForEach-Object { $_ -replace "XXXXX", "$labNumber" } | Set-Content "C:\LabFiles\$sbcinifile"
#>