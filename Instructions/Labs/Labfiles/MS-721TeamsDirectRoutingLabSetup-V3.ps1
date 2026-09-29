<#
.SYNOPSIS
Resumable MS-721 Lab 3 setup, without deploying or connecting to an SBC.
.DESCRIPTION
Run without arguments to choose a phase from a menu. Supply -LabNumber to run
the guided sequence, or use -Phase to run one independent phase.
The Dns phase configures MS720-RRAS01; Domain verifies Microsoft 365 ownership;
Csr creates a local machine certificate request; Sbc prepares a local INI file.
Existing mismatched records and files are reported, not deleted.
.EXAMPLE
.\MS-721TeamsDirectRoutingLabSetup-V3.ps1
.EXAMPLE
.\MS-721TeamsDirectRoutingLabSetup-V3.ps1 -LabNumber 12345
.EXAMPLE
.\MS-721TeamsDirectRoutingLabSetup-V3.ps1 -Phase Domain -LabNumber 12345
#>
[CmdletBinding()]
param(
    [ValidateSet('Guided', 'Dns', 'Domain', 'Csr', 'Sbc')]
    [string]$Phase = 'Guided',

    [ValidatePattern('^\d{5}$')]
    [string]$LabNumber,

    [string]$PublicIp
)

$RrasHost = 'MS720-RRAS01'

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Get-PhaseDescription {
    param([string]$Name)
    switch ($Name) {
        'Guided' { return 'Run Dns, Domain, Csr, and Sbc in order.' }
        'Dns'    { return 'Configure RRAS DNS. Requires the public IPv4 address and RRAS Administrator password.' }
        'Domain' { return 'Verify the lab domain. Requires completed DNS, Microsoft Graph sign-in, and RRAS Administrator password.' }
        'Csr'    { return 'Create or reuse the local certificate request. No SBC is needed.' }
        'Sbc'    { return 'Prepare the local SBC INI file. No SBC is deployed or configured.' }
    }
}

function Read-SetupPhase {
    Write-Host ''
    Write-Host 'Choose what to run:'
    foreach ($entry in @(
        @('1', 'Guided'), @('2', 'Dns'), @('3', 'Domain'), @('4', 'Csr'), @('5', 'Sbc')
    )) {
        Write-Host ("  {0}. {1} - {2}" -f $entry[0], $entry[1], (Get-PhaseDescription $entry[1]))
    }
    Write-Host '  Q. Exit without changes.'
    while ($true) {
        $choice = ([string](Read-Host 'Select 1-5 or Q')).Trim().ToUpperInvariant()
        switch ($choice) {
            '1' { return 'Guided' }
            '2' { return 'Dns' }
            '3' { return 'Domain' }
            '4' { return 'Csr' }
            '5' { return 'Sbc' }
            'Q' { Write-Host 'No changes made.'; return $null }
            default { Write-Host 'Enter a number from 1 through 5, or Q to exit.' }
        }
    }
}

function Read-LabNumber {
    while ($true) {
        $number = ([string](Read-Host 'Enter your five-digit lab number (or Q to exit)')).Trim()
        if ($number -ieq 'Q') { Write-Host 'No changes made.'; return $null }
        if ($number -match '^\d{5}$') { return $number }
        Write-Host 'Enter exactly five digits, for example 12345.'
    }
}

function Test-PublicIPv4Address {
    param([string]$Address)
    $parsed = $null
    return ([ipaddress]::TryParse($Address, [ref]$parsed) -and
        $parsed.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork -and
        -not [ipaddress]::IsLoopback($parsed) -and
        $Address -notmatch '^(0|10|127|169\.254|172\.(1[6-9]|2\d|3[01])|192\.168)\.')
}

function Read-PublicIp {
    while ($true) {
        $address = ([string](Read-Host "Enter the lab's public IPv4 address from Task 1 (or Q to exit)")).Trim()
        if ($address -ieq 'Q') { Write-Host 'No changes made.'; return $null }
        if (Test-PublicIPv4Address $address) { return $address }
        Write-Host 'Enter the public IPv4 address from Task 1, not a private or local address.'
    }
}

function Get-DnsRecords {
    param($Session, [string]$Zone)
    @(Get-DnsServerResourceRecord -CimSession $Session -ZoneName $Zone -ErrorAction Stop)
}

function Get-RecordValue {
    param($Record)
    switch ($Record.RecordType) {
        'A'     { return [string]$Record.RecordData.IPv4Address }
        'CNAME' { return ([string]$Record.RecordData.HostNameAlias).TrimEnd('.').ToLowerInvariant() }
        'TXT'   { return [string]::Join('', [string[]]$Record.RecordData.DescriptiveText) }
        'MX'    { return ('{0}:{1}' -f $Record.RecordData.Preference, ([string]$Record.RecordData.MailExchange).TrimEnd('.').ToLowerInvariant()) }
        'SRV'   { return ('{0}:{1}:{2}:{3}' -f ([string]$Record.RecordData.DomainName).TrimEnd('.').ToLowerInvariant(), $Record.RecordData.Port, $Record.RecordData.Priority, $Record.RecordData.Weight) }
        'NS'    { return ([string]$Record.RecordData.NameServer).TrimEnd('.').ToLowerInvariant() }
        default { throw "Unsupported DNS record type: $($Record.RecordType)" }
    }
}

function Test-DnsRecordName {
    param([string]$HostName, [string]$Name, [string]$Zone)
    if ($Name -ne '@') { return $HostName -eq $Name }
    return $HostName -in @('@', '.', '') -or $HostName.TrimEnd('.') -eq $Zone
}

function Ensure-DnsRecord {
    param($Session, [string]$Zone, [string]$Name, [string]$Type,
          [string]$Expected, [scriptblock]$Create, [switch]$UpdateAddress)

    $records = @(Get-DnsRecords -Session $Session -Zone $Zone |
        Where-Object {
            (Test-DnsRecordName -HostName $_.HostName -Name $Name -Zone $Zone) -and
            $_.RecordType -eq $Type
        })
    $matches = @($records | Where-Object { (Get-RecordValue $_) -eq $Expected })
    $conflicts = @($records | Where-Object { (Get-RecordValue $_) -ne $Expected })
    if ($Type -eq 'TXT') {
        $conflicts = @($conflicts | Where-Object {
            if ($Expected -like 'v=spf1*') { (Get-RecordValue $_) -like 'v=spf1*' }
            else { (Get-RecordValue $_) -like 'MS=*' }
        })
    }
    if ($UpdateAddress -and $records.Count -eq 1) { $conflicts = @() }
    Assert-True ($matches.Count -le 1 -and $conflicts.Count -eq 0) "Conflicting $Type record for $Name in $Zone. Inspect the DNS zone before retrying."
    if ($Type -eq 'CNAME') {
        $other = @(Get-DnsRecords -Session $Session -Zone $Zone | Where-Object {
            $_.HostName -eq $Name -and $_.RecordType -ne 'CNAME'
        })
        Assert-True ($other.Count -eq 0) "Cannot create CNAME ${Name}: another record type already uses that name."
    }
    if ($matches.Count -eq 1) { return }
    if ($UpdateAddress -and $records.Count -eq 1) {
        $replacement = $records[0].Clone()
        $replacement.RecordData.IPv4Address = [ipaddress]$Expected
        Set-DnsServerResourceRecord -CimSession $Session -ZoneName $Zone -OldInputObject $records[0] -NewInputObject $replacement -ErrorAction Stop
    }
    else {
        & $Create
    }
    $after = @(Get-DnsRecords -Session $Session -Zone $Zone | Where-Object {
        (Test-DnsRecordName -HostName $_.HostName -Name $Name -Zone $Zone) -and
        $_.RecordType -eq $Type -and (Get-RecordValue $_) -eq $Expected
    })
    Assert-True ($after.Count -eq 1) "DNS did not retain the expected $Type record for $Name in $Zone."
    Write-Host "Verified $Type $Name in $Zone"
}

function Invoke-DnsPhase {
    param([string]$Zone, [string]$Address)
    Assert-True (Test-PublicIPv4Address $Address) "Supply the lab's public IPv4 address with -PublicIp."
    Assert-True ([bool](Get-Command New-CimSession, Get-DnsServerZone, Get-DnsServerResourceRecord, Add-DnsServerPrimaryZone -ErrorAction Stop)) 'DNS Server and CIM commands are required.'
    $session = $null
    try {
        $credential = Get-Credential -UserName Administrator -Message "Local Administrator credentials for $RrasHost"
        Assert-True ($null -ne $credential) 'RRAS credentials were not supplied.'
        $session = New-CimSession -ComputerName $RrasHost -Credential $credential -Authentication Negotiate -ErrorAction Stop
        Assert-True ($null -ne $session) "Could not open a CIM session to $RrasHost."
        $zoneInfo = @(Get-DnsServerZone -CimSession $session -ErrorAction Stop | Where-Object ZoneName -eq $Zone)
        Assert-True ($zoneInfo.Count -le 1) "Multiple DNS zones matched $Zone."
        if ($zoneInfo.Count -eq 0) {
            Add-DnsServerPrimaryZone -CimSession $session -Name $Zone -ZoneFile "$Zone.dns" -ErrorAction Stop
            $zoneInfo = @(Get-DnsServerZone -CimSession $session -ErrorAction Stop | Where-Object ZoneName -eq $Zone)
        }
        Assert-True ($zoneInfo.Count -eq 1 -and $zoneInfo[0].ZoneType -eq 'Primary') "Expected a primary DNS zone named $Zone on $RrasHost."

        $soa = @(Get-DnsRecords -Session $session -Zone $Zone | Where-Object RecordType -eq SOA)
        Assert-True ($soa.Count -eq 1) "Expected exactly one SOA record for $Zone."
        $ns = @(Get-DnsRecords -Session $session -Zone $Zone | Where-Object RecordType -eq NS)
        Assert-True ($ns.Count -le 1) "Multiple NS records exist for $Zone; inspect them before continuing."
        if ($ns.Count -eq 1 -and (Get-RecordValue $ns[0]) -ne $Zone) {
            Assert-True ((Get-RecordValue $ns[0]) -like "$($RrasHost.ToLowerInvariant())*") "Unexpected NS record for $Zone; inspect it before continuing."
        }
        if (([string]$soa[0].RecordData.PrimaryServer).TrimEnd('.') -ne $Zone) {
            Assert-True (([string]$soa[0].RecordData.PrimaryServer).ToLowerInvariant() -like "$($RrasHost.ToLowerInvariant())*") "Unexpected SOA primary server for $Zone; inspect it before continuing."
            $replacement = $soa[0].Clone()
            $replacement.RecordData.PrimaryServer = "$Zone."
            Set-DnsServerResourceRecord -CimSession $session -ZoneName $Zone -OldInputObject $soa[0] -NewInputObject $replacement -ErrorAction Stop
        }
        $soa = @(Get-DnsRecords -Session $session -Zone $Zone | Where-Object RecordType -eq SOA)
        Assert-True ($soa.Count -eq 1 -and ([string]$soa[0].RecordData.PrimaryServer).TrimEnd('.') -eq $Zone) "SOA update failed for $Zone."

        if ($ns.Count -eq 1 -and (Get-RecordValue $ns[0]) -ne $Zone) {
            $replacement = $ns[0].Clone()
            $replacement.RecordData.NameServer = "$Zone."
            Set-DnsServerResourceRecord -CimSession $session -ZoneName $Zone -OldInputObject $ns[0] -NewInputObject $replacement -ErrorAction Stop
        }
        elseif ($ns.Count -eq 0) {
            Add-DnsServerResourceRecord -CimSession $session -ZoneName $Zone -NS -Name '@' -NameServer "$Zone." -ErrorAction Stop
        }
        $ns = @(Get-DnsRecords -Session $session -Zone $Zone | Where-Object RecordType -eq NS)
        Assert-True ($ns.Count -eq 1 -and (Get-RecordValue $ns[0]) -eq $Zone) "Expected a single NS record for $Zone pointing to $Zone."

        $mx = "$($Zone.Replace('.', '-')).mail.protection.outlook.com"
        Ensure-DnsRecord $session $Zone '@' 'A' $Address {
            Add-DnsServerResourceRecordA -CimSession $session -ZoneName $Zone -Name '@' -IPv4Address $Address -ErrorAction Stop
        } -UpdateAddress
        Ensure-DnsRecord $session $Zone '@' 'MX' "5:$mx" {
            Add-DnsServerResourceRecordMX -CimSession $session -ZoneName $Zone -Name '.' -MailExchange $mx -Preference 5 -ErrorAction Stop
        }
        Ensure-DnsRecord $session $Zone '@' 'TXT' 'v=spf1 include:spf.protection.outlook.com -all' {
            Add-DnsServerResourceRecord -CimSession $session -ZoneName $Zone -Name '@' -Txt -DescriptiveText 'v=spf1 include:spf.protection.outlook.com -all' -ErrorAction Stop
        }
        foreach ($entry in @(
            @('autodiscover', 'autodiscover.outlook.com'),
            @('sip', 'sipdir.online.lync.com'),
            @('lyncdiscover', 'webdir.online.lync.com'),
            @('enterpriseregistration', 'enterpriseregistration.windows.net'),
            @('enterpriseenrollment', 'enterpriseenrollment.manage.microsoft.com')
        )) {
            $name, $alias = $entry
            Ensure-DnsRecord $session $Zone $name 'CNAME' $alias {
                Add-DnsServerResourceRecordCName -CimSession $session -ZoneName $Zone -Name $name -HostNameAlias $alias -ErrorAction Stop
            }
        }
        foreach ($entry in @(
            @('_sip._tls', 'sipdir.online.lync.com', 443),
            @('_sipfederationtls._tcp', 'sipfed.online.lync.com', 5061)
        )) {
            $name, $target, $port = $entry
            Ensure-DnsRecord $session $Zone $name 'SRV' ("{0}:{1}:100:1" -f $target, $port) {
                Add-DnsServerResourceRecord -CimSession $session -ZoneName $Zone -Srv -Name $name -DomainName $target -Port $port -Priority 100 -Weight 1 -ErrorAction Stop
            }
        }
        Write-Host "DNS phase complete for $Zone on $RrasHost."
    }
    finally {
        if ($null -ne $session) { Remove-CimSession -CimSession $session -ErrorAction Stop }
    }
}

function Invoke-DomainPhase {
    param([string]$Zone)
    foreach ($module in @('Microsoft.Graph.Authentication', 'Microsoft.Graph.Identity.DirectoryManagement')) {
        Assert-True ([bool](Get-Module -ListAvailable -Name $module)) "Install $module before running Domain."
    }
    Import-Module Microsoft.Graph.Authentication, Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop
    $session = $null
    $connected = $false
    try {
        Connect-MgGraph -Scopes 'Domain.ReadWrite.All' -ContextScope Process -NoWelcome -ErrorAction Stop
        $connected = $true
        $context = Get-MgContext -ErrorAction Stop
        Assert-True ($null -ne $context -and $context.Scopes -contains 'Domain.ReadWrite.All') 'The Graph session lacks Domain.ReadWrite.All.'
        Write-Host "Graph tenant: $($context.TenantId); account: $($context.Account)"
        $approval = Read-Host "Confirm this is your lab tenant for $Zone (type YES to continue)"
        Assert-True ($approval -ceq 'YES') 'Domain phase cancelled before changing tenant or DNS records.'
        $credential = Get-Credential -UserName Administrator -Message "Local Administrator credentials for $RrasHost"
        Assert-True ($null -ne $credential) 'RRAS credentials were not supplied.'
        $session = New-CimSession -ComputerName $RrasHost -Credential $credential -Authentication Negotiate -ErrorAction Stop
        Assert-True ($null -ne $session) "Could not open a CIM session to $RrasHost."
        $zones = @(Get-DnsServerZone -CimSession $session -ErrorAction Stop | Where-Object ZoneName -eq $Zone)
        Assert-True ($zones.Count -eq 1 -and $zones[0].ZoneType -eq 'Primary') "Run -Phase Dns first: primary zone $Zone is missing on $RrasHost."
        $domain = @(Get-MgDomain -All -ErrorAction Stop | Where-Object Id -eq $Zone)
        Assert-True ($domain.Count -le 1) "Multiple tenant domains matched $Zone."
        if ($domain.Count -eq 0) {
            New-MgDomain -BodyParameter @{ id = $Zone } -ErrorAction Stop | Out-Null
        }
        $domain = Get-MgDomain -DomainId $Zone -ErrorAction Stop
        Assert-True ($null -ne $domain -and $domain.Id -eq $Zone) "Domain $Zone was not found in the connected tenant."
        if (-not $domain.IsVerified) {
            $verification = @(Get-MgDomainVerificationDnsRecord -DomainId $Zone -ErrorAction Stop |
                Where-Object RecordType -eq 'Txt')
            Assert-True ($verification.Count -eq 1) "Expected exactly one Graph TXT verification record for $Zone."
            $text = [string]$verification[0].AdditionalProperties['text']
            Assert-True ($text -match '^MS=\S+$') "Graph returned no usable TXT verification value for $Zone."
            Ensure-DnsRecord $session $Zone '@' 'TXT' $text {
                Add-DnsServerResourceRecord -CimSession $session -ZoneName $Zone -Name '@' -Txt -DescriptiveText $text -ErrorAction Stop
            }
            Confirm-MgDomain -DomainId $Zone -ErrorAction Stop | Out-Null
        }
        $domain = Get-MgDomain -DomainId $Zone -ErrorAction Stop
        Assert-True ($domain.IsVerified -eq $true) "Graph has not verified $Zone. Check public DNS delegation and TXT propagation; rerun Domain after they resolve."
        Write-Host "Domain phase complete: Graph confirms $Zone is verified."
    }
    finally {
        if ($null -ne $session) { Remove-CimSession -CimSession $session -ErrorAction Stop }
        if ($connected) { Disconnect-MgGraph -ErrorAction Stop | Out-Null }
    }
}

function Assert-CsrFile {
    param([string]$Path, [string]$Zone)
    Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) "CSR file is missing: $Path."
    $csr = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
    Assert-True ($csr -match '(?s)^-----BEGIN (?:NEW )?CERTIFICATE REQUEST-----\s+[A-Za-z0-9+/\s=]+-----END (?:NEW )?CERTIFICATE REQUEST-----\s*$') "CSR at $Path is not a complete PEM request."
    $dump = & certutil.exe -dump $Path
    Assert-True ($LASTEXITCODE -eq 0) "certutil could not parse the CSR at $Path."
    Assert-True (($dump -join "`n") -match [regex]::Escape("sbc01.$Zone")) "CSR $Path does not contain the expected SBC name."
}

function Invoke-CsrPhase {
    param([string]$Zone)
    $subject = "CN=sbc01.$Zone"
    $path = "C:\LabFiles\CertReq-$Zone.txt"
    $inf = "C:\LabFiles\sbc01-$Zone.inf"
    Assert-True (Test-Path -LiteralPath 'C:\LabFiles' -PathType Container) 'C:\LabFiles is required for the CSR.'
    $principal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    Assert-True ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 'Run Windows PowerShell as Administrator for the CSR.'
    Assert-True ($null -ne (Get-Command certreq.exe -ErrorAction Stop)) 'certreq.exe is required.'
    $requests = @(Get-ChildItem 'Cert:\LocalMachine\Request' -ErrorAction Stop | Where-Object Subject -eq $subject)
    Assert-True ($requests.Count -le 1) "Multiple machine requests exist for $subject; inspect them before continuing."
    if (Test-Path -LiteralPath $path) {
        Assert-True ($requests.Count -eq 1) "Existing CSR $path has no matching machine request for $subject. Inspect both before retrying; nothing was removed."
        Assert-CsrFile -Path $path -Zone $Zone
        Write-Host "Reusing the existing CSR and matching machine request: $path"
        return
    }
    Assert-True ($requests.Count -eq 0) "A machine request already exists for $subject but $path is missing. Restore the original CSR file; nothing was removed."
    $content = @"
[Version]
Signature = "`$Windows NT`$"
[NewRequest]
FriendlyName = Lab Certificate
Subject = $subject
Exportable = TRUE
KeyLength = 2048
KeySpec = 1
KeyUsage = 0xA0
MachineKeySet = True
ProviderName = Microsoft RSA SChannel Cryptographic Provider
RequestType = PKCS10
[EnhancedKeyUsageExtension]
OID=1.3.6.1.5.5.7.3.1
OID=1.3.6.1.5.5.7.3.2
[Extensions]
2.5.29.17 = "{text}"
_continue_ = "dns=sbc01.$Zone&"
_continue_ = "dns=$Zone&"
"@
    if (Test-Path -LiteralPath $inf) {
        Assert-True ((Get-Content -LiteralPath $inf -Raw -ErrorAction Stop).TrimEnd() -ceq $content.TrimEnd()) "Existing INF $inf differs from this lab's CSR parameters."
    }
    else {
        Set-Content -LiteralPath $inf -Value $content -Encoding Ascii -ErrorAction Stop
    }
    $null = & certreq.exe -q -new $inf $path
    Assert-True ($LASTEXITCODE -eq 0) "certreq failed (exit $LASTEXITCODE). Inspect $inf, $path, and the request store before retrying."
    Assert-CsrFile -Path $path -Zone $Zone
    $requests = @(Get-ChildItem 'Cert:\LocalMachine\Request' -ErrorAction Stop | Where-Object Subject -eq $subject)
    Assert-True ($requests.Count -eq 1) "CSR file exists but the machine request store does not contain exactly one $subject request."
    Write-Host "CSR phase complete. Reuse $path for the certificate request."
}

function Write-SbcIniFile {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.Encoding]::ASCII)
}

function Invoke-SbcPhase {
    param([string]$Number)
    $source = 'C:\Scripts\Backup\Lab-sbc01-Config.ini'
    $destination = "C:\LabFiles\Lab$Number-SBC01-Config.ini"
    Assert-True (Test-Path -LiteralPath $source -PathType Leaf) "SBC INI template is missing: $source."
    Assert-True (Test-Path -LiteralPath 'C:\LabFiles' -PathType Container) 'C:\LabFiles is required for the SBC INI.'
    $template = Get-Content -LiteralPath $source -Raw -ErrorAction Stop
    Assert-True ($template.Contains('XXXXX')) "The SBC INI template has no XXXXX lab-number placeholder."
    $expected = $template.Replace('XXXXX', $Number)
    if (Test-Path -LiteralPath $destination) {
        $actual = Get-Content -LiteralPath $destination -Raw -ErrorAction Stop
        Assert-True ($actual -ceq $expected) "Existing SBC INI differs from the template: $destination. Review it; nothing was overwritten."
    }
    else {
        Write-SbcIniFile -Path $destination -Content $expected
    }
    Assert-True ((Get-Content -LiteralPath $destination -Raw -ErrorAction Stop) -ceq $expected) "SBC INI output did not match the expected template."
    Write-Host "SBC INI phase complete: $destination (no SBC or cloud configuration was performed)."
}

# Dot-source to load the functions for offline checks without accessing the lab.
if ($MyInvocation.InvocationName -eq '.') { return }

$ErrorActionPreference = 'Stop'
$current = $null
try {
    Write-Host "`nMS-721 Lab 3 setup (no SBC or Cloud Slice deployment)"
    if ($PSBoundParameters.Count -eq 0) {
        $selectedPhase = Read-SetupPhase
        if (-not $selectedPhase) { return }
        $Phase = $selectedPhase
    }
    if (-not $LabNumber) {
        $selectedNumber = Read-LabNumber
        if (-not $selectedNumber) { return }
        $LabNumber = $selectedNumber
    }
    Assert-True ($LabNumber -match '^\d{5}$') 'The lab number must have exactly five digits.'
    $zone = "lab$LabNumber.o365ready.com"
    [string[]]$phases = if ($Phase -eq 'Guided') { @('Dns', 'Domain', 'Csr', 'Sbc') } else { @($Phase) }
    Write-Host "Lab domain: $zone"
    Write-Host "Selected: $Phase - $(Get-PhaseDescription $Phase)"
    Write-Host 'Existing matching records and files are reused; conflicts stop the run without deleting them.'
    foreach ($current in $phases) {
        Write-Host "`n[$([array]::IndexOf($phases, $current) + 1)/$($phases.Count)] $current - $(Get-PhaseDescription $current)"
        switch ($current) {
            'Dns' {
                if (-not $PublicIp) {
                    $PublicIp = Read-PublicIp
                    if (-not $PublicIp) { return }
                }
                Invoke-DnsPhase -Zone $zone -Address $PublicIp
            }
            'Domain' { Invoke-DomainPhase -Zone $zone }
            'Csr'    { Invoke-CsrPhase -Zone $zone }
            'Sbc'    { Invoke-SbcPhase -Number $LabNumber }
        }
        Write-Host "Finished $current."
    }
    Write-Host "`nSelected Lab 3 setup phases complete. Continue with the lab instructions."
}
catch {
    $retry = if ($current) {
        $ipHint = if ($current -eq 'Dns') { ' -PublicIp <public IPv4 address>' } else { '' }
        "After correcting the issue, rerun: .\MS-721TeamsDirectRoutingLabSetup-V3.ps1 -Phase $current -LabNumber $LabNumber$ipHint"
    }
    else { 'Correct the input and run the script again.' }
    Write-Error "Lab 3 setup stopped: $($_.Exception.Message) $retry" -ErrorAction Continue
    exit 1
}
