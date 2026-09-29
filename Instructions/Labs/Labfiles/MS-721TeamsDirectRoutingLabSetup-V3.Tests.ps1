# Run with Windows PowerShell; these mocks never contact DNS, Graph, or a lab VM.
$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot 'MS-721TeamsDirectRoutingLabSetup-V3.ps1'
$tokens = $null
$errors = $null
[System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$tokens, [ref]$errors) | Out-Null
if ($errors.Count) { throw "V3 script has parser errors: $($errors.Message -join '; ')" }
. $scriptPath

function Assert-Test {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "Offline test failed: $Message" }
}

$script:zone = 'lab12345.o365ready.com'
$script:records = New-Object System.Collections.ArrayList
function Get-DnsRecords { return $script:records.ToArray() }
function New-TxtRecord {
    param([string]$Text)
    [pscustomobject]@{ HostName = '@'; RecordType = 'TXT'; RecordData = [pscustomobject]@{ DescriptiveText = @($Text) } }
}
[void]$script:records.Add((New-TxtRecord 'v=spf1 include:spf.protection.outlook.com -all'))
Ensure-DnsRecord $null $script:zone '@' 'TXT' 'MS=test123' {
    [void]$script:records.Add((New-TxtRecord 'MS=test123'))
}
Ensure-DnsRecord $null $script:zone '@' 'TXT' 'MS=test123' { throw 'Reused TXT should not be written.' }
Assert-Test ($script:records.Count -eq 2) 'Missing or duplicated verification TXT record.'
$conflicted = $false
try {
    Ensure-DnsRecord $null $script:zone '@' 'TXT' 'MS=changed' { throw 'Conflict should not be written.' }
}
catch { $conflicted = $_.Exception.Message -like '*Conflicting TXT*' }
Assert-Test $conflicted 'A mismatched verification TXT did not fail explicitly.'

[void]$script:records.Add([pscustomobject]@{
    HostName = 'sip'; RecordType = 'A'
    RecordData = [pscustomobject]@{ IPv4Address = [ipaddress]'8.8.8.8' }
})
$conflicted = $false
try {
    Ensure-DnsRecord $null $script:zone 'sip' 'CNAME' 'sipdir.online.lync.com' { throw 'Conflicting CNAME should not be written.' }
}
catch { $conflicted = $_.Exception.Message -like '*another record type*' }
Assert-Test $conflicted 'A CNAME conflicting with an A record did not fail explicitly.'

$script:records.Clear()
$address = [pscustomobject]@{
    HostName = '@'; RecordType = 'A'
    RecordData = [pscustomobject]@{ IPv4Address = [ipaddress]'8.8.8.8' }
}
$address | Add-Member ScriptMethod Clone {
    [pscustomobject]@{
        HostName = $this.HostName; RecordType = $this.RecordType
        RecordData = [pscustomobject]@{ IPv4Address = $this.RecordData.IPv4Address }
    }
}
[void]$script:records.Add($address)
function Set-DnsServerResourceRecord {
    param($CimSession, $ZoneName, $OldInputObject, $NewInputObject, $ErrorAction)
    $script:records[0] = $NewInputObject
}
Ensure-DnsRecord $null $script:zone '@' 'A' '8.8.4.4' { throw 'A update should not add another record.' } -UpdateAddress
Assert-Test ([string]$script:records[0].RecordData.IPv4Address -eq '8.8.4.4') 'A record was not updated in place.'

# Model the DNS records left by V2: mixed apex spellings and original RRAS authority.
function New-MockDnsRecord {
    param([string]$HostName, [string]$Type, [hashtable]$Data)
    $record = [pscustomobject]@{ HostName = $HostName; RecordType = $Type; RecordData = [pscustomobject]$Data }
    $record | Add-Member ScriptMethod Clone {
        $fields = @{}
        foreach ($property in $this.RecordData.PSObject.Properties) { $fields[$property.Name] = $property.Value }
        [pscustomobject]@{
            HostName = $this.HostName; RecordType = $this.RecordType
            RecordData = [pscustomobject]$fields
        }
    }
    return $record
}
foreach ($apex in @('@', '.', '', $script:zone, "$($script:zone).")) {
    Assert-Test (Test-DnsRecordName $apex '@' $script:zone) "Apex spelling '$apex' was not recognized."
}
Assert-Test (-not (Test-DnsRecordName 'other' '@' $script:zone)) 'A child name was mistaken for the zone apex.'
$mxTarget = "$($script:zone.Replace('.', '-')).mail.protection.outlook.com"
$mxData = New-MockDnsRecord '.' 'MX' @{ Preference = [uint16]5; MailExchange = "$mxTarget." }
$srvData = New-MockDnsRecord '_sip._tls' 'SRV' @{ DomainName = 'sipdir.online.lync.com.'; Port = [uint16]443; Priority = [uint16]100; Weight = [uint16]1 }
Assert-Test ((Get-RecordValue $mxData) -ceq "5:$mxTarget") 'MX RecordData fields or trailing-dot handling are incorrect.'
Assert-Test ((Get-RecordValue $srvData) -ceq 'sipdir.online.lync.com:443:100:1') 'SRV RecordData fields or trailing-dot handling are incorrect.'

$script:records.Clear()
[void]$script:records.Add((New-MockDnsRecord '@' 'SOA' @{ PrimaryServer = 'MS720-RRAS01.' }))
[void]$script:records.Add((New-MockDnsRecord '.' 'NS' @{ NameServer = 'MS720-RRAS01.' }))
[void]$script:records.Add((New-MockDnsRecord $script:zone 'A' @{ IPv4Address = [ipaddress]'8.8.8.8' }))
[void]$script:records.Add($mxData)
[void]$script:records.Add((New-TxtRecord 'v=spf1 include:spf.protection.outlook.com -all'))
foreach ($entry in @(
    @('autodiscover', 'autodiscover.outlook.com'),
    @('sip', 'sipdir.online.lync.com'),
    @('lyncdiscover', 'webdir.online.lync.com'),
    @('enterpriseregistration', 'enterpriseregistration.windows.net'),
    @('enterpriseenrollment', 'enterpriseenrollment.manage.microsoft.com')
)) {
    [void]$script:records.Add((New-MockDnsRecord $entry[0] 'CNAME' @{ HostNameAlias = "$($entry[1])." }))
}
[void]$script:records.Add($srvData)
[void]$script:records.Add((New-MockDnsRecord '_sipfederationtls._tcp' 'SRV' @{
    DomainName = 'sipfed.online.lync.com.'; Port = [uint16]5061; Priority = [uint16]100; Weight = [uint16]1
}))
$script:dnsMutations = 0
$script:dnsSessionsClosed = 0
function Get-Command { param([string[]]$Name, $ErrorAction) [pscustomobject]@{ Name = $Name } }
function Get-Credential { [pscustomobject]@{ UserName = 'offline' } }
function New-CimSession { [pscustomobject]@{ Name = 'offline' } }
function Remove-CimSession { $script:dnsSessionsClosed++ }
function Get-DnsServerZone { [pscustomobject]@{ ZoneName = $script:zone; ZoneType = 'Primary' } }
function Add-DnsServerPrimaryZone { throw 'An existing zone must not be recreated.' }
function Get-DnsServerResourceRecord { return $script:records.ToArray() }
function Set-DnsServerResourceRecord {
    param($CimSession, $ZoneName, $OldInputObject, $NewInputObject, $ErrorAction)
    for ($index = 0; $index -lt $script:records.Count; $index++) {
        if ([object]::ReferenceEquals($script:records[$index], $OldInputObject)) {
            $script:records[$index] = $NewInputObject
            $script:dnsMutations++
            return
        }
    }
    throw 'Attempted to update a record not in the zone.'
}
function Add-DnsServerResourceRecordMX {
    param($CimSession, $ZoneName, $Name, $MailExchange, $Preference, $ErrorAction)
    Assert-Test ($Name -eq '.') 'MX at the root must use the documented dot name.'
    [void]$script:records.Add((New-MockDnsRecord $Name 'MX' @{ MailExchange = $MailExchange; Preference = $Preference }))
    $script:dnsMutations++
}
function Add-DnsServerResourceRecord { throw 'Existing records must not be recreated.' }
function Add-DnsServerResourceRecordA { throw 'Existing apex A must be updated, not duplicated.' }
function Add-DnsServerResourceRecordCName { throw 'Existing CNAME must not be recreated.' }
Invoke-DnsPhase $script:zone '8.8.8.8'
Assert-Test ($script:dnsMutations -eq 2 -and $script:records.Count -eq 12) 'Existing zone changed beyond its original RRAS SOA and NS.'
Invoke-DnsPhase $script:zone '8.8.8.8'
Assert-Test ($script:dnsMutations -eq 2 -and $script:records.Count -eq 12) 'Identical DNS rerun modified or duplicated records.'
Invoke-DnsPhase $script:zone '8.8.4.4'
Assert-Test ($script:dnsMutations -eq 3 -and $script:records.Count -eq 12) 'Changing public IP did not update only the existing apex A.'
$apexA = @($script:records | Where-Object RecordType -eq A)
Assert-Test ($apexA.Count -eq 1 -and $apexA[0].HostName -eq $script:zone -and [string]$apexA[0].RecordData.IPv4Address -eq '8.8.4.4') 'V2 full-zone apex A was not updated in place.'
Assert-Test ($script:dnsSessionsClosed -eq 3) 'DNS sessions were not closed after each run.'

# Removing an MX only from the mock forces the documented dot-name creation/readback.
$oldMx = @($script:records | Where-Object RecordType -eq MX)[0]
$script:records.Remove($oldMx)
Invoke-DnsPhase $script:zone '8.8.4.4'
Assert-Test ($script:dnsMutations -eq 4 -and $script:records.Count -eq 12) 'Dot-named MX creation or postwrite verification failed.'
[void]$script:records.Add((New-MockDnsRecord '@' 'MX' @{ Preference = [uint16]8; MailExchange = 'wrong.example.' }))
$conflicted = $false
try { Invoke-DnsPhase $script:zone '8.8.4.4' }
catch { $conflicted = $_.Exception.Message -like '*Conflicting MX*' }
Assert-Test ($conflicted -and $script:dnsMutations -eq 4 -and $script:dnsSessionsClosed -eq 5) 'Conflicting apex MX failed to stop DNS rerun cleanly.'

# Replace all external commands before exercising the Domain phase.
function Get-Module { param([switch]$ListAvailable, [string]$Name) [pscustomobject]@{ Name = $Name } }
function Import-Module { param($Name, $ErrorAction) }
function Connect-MgGraph {
    param($Scopes, $ContextScope, [switch]$NoWelcome, $ErrorAction)
    Assert-Test ($ContextScope -eq 'Process') 'Graph credentials must use process scope.'
}
function Get-MgContext { [pscustomobject]@{ Scopes = @('Domain.ReadWrite.All'); TenantId = 'offline'; Account = 'mock' } }
function Read-Host { 'YES' }
function Get-Credential { [pscustomobject]@{ UserName = 'offline' } }
function New-CimSession { [pscustomobject]@{ Name = 'offline' } }
function Remove-CimSession {}
function Disconnect-MgGraph {}
function Get-DnsServerZone { [pscustomobject]@{ ZoneName = $script:zone; ZoneType = 'Primary' } }
function Get-MgDomain { param($DomainId, [switch]$All) [pscustomobject]@{ Id = $script:zone; IsVerified = $script:verified } }
function New-MgDomain { throw 'Existing domain must not be created again.' }
function Get-MgDomainVerificationDnsRecord {
    [pscustomobject]@{ RecordType = 'Txt'; AdditionalProperties = @{ text = 'MS=test123' } }
}
function Confirm-MgDomain { $script:verified = $true; $script:confirmCount++ }
function Add-DnsServerResourceRecord {
    param($CimSession, $ZoneName, $Name, [switch]$Txt, $DescriptiveText, $ErrorAction)
    [void]$script:records.Add((New-TxtRecord $DescriptiveText))
}
$script:records.Clear()
[void]$script:records.Add((New-TxtRecord 'v=spf1 include:spf.protection.outlook.com -all'))
$script:verified = $false
$script:confirmCount = 0
Invoke-DomainPhase $script:zone
function Get-MgDomainVerificationDnsRecord { throw 'A verified domain should not request another TXT challenge.' }
Invoke-DomainPhase $script:zone
Assert-Test ($script:verified -and $script:confirmCount -eq 1 -and $script:records.Count -eq 2) 'Existing unverified domain was not confirmed, or its rerun changed DNS.'

$script:records.Clear()
[void]$script:records.Add((New-TxtRecord 'v=spf1 include:spf.protection.outlook.com -all'))
Invoke-DomainPhase $script:zone
Assert-Test ($script:confirmCount -eq 1 -and $script:records.Count -eq 1) 'A verified domain incorrectly required or recreated an optional ownership TXT record.'

$script:verified = $false
function Get-MgDomainVerificationDnsRecord { return }
$failedWithoutTxt = $false
try { Invoke-DomainPhase $script:zone }
catch { $failedWithoutTxt = $_.Exception.Message -like '*exactly one Graph TXT*' }
Assert-Test ($failedWithoutTxt -and $script:confirmCount -eq 1 -and $script:records.Count -eq 1) 'An unverified domain without a Graph TXT value was silently accepted or changed.'
Assert-Test ($RrasHost -eq 'MS720-RRAS01') 'The RRAS target differs from the provisioned host.'

# Stub the SBC file boundary. No directory or file is opened outside this test process.
$script:sbcTemplate = "Account=XXXXX`r`nHost=sbc01.labXXXXX.o365ready.com`r`n"
$script:sbcActual = $null
$script:sbcWrites = 0
function Test-Path {
    param([string]$LiteralPath, $PathType)
    if ($LiteralPath -eq 'C:\Scripts\Backup\Lab-sbc01-Config.ini' -or $LiteralPath -eq 'C:\LabFiles') { return $true }
    if ($LiteralPath -eq 'C:\LabFiles\Lab12345-SBC01-Config.ini') { return $null -ne $script:sbcActual }
    throw "Unexpected test path: $LiteralPath"
}
function Get-Content {
    param([string]$LiteralPath, [switch]$Raw, $ErrorAction)
    if ($LiteralPath -eq 'C:\Scripts\Backup\Lab-sbc01-Config.ini') { return $script:sbcTemplate }
    if ($LiteralPath -eq 'C:\LabFiles\Lab12345-SBC01-Config.ini') { return $script:sbcActual }
    throw "Unexpected content path: $LiteralPath"
}
function Write-SbcIniFile {
    param([string]$Path, [string]$Content)
    Assert-Test ($Path -eq 'C:\LabFiles\Lab12345-SBC01-Config.ini') 'Unexpected SBC output location.'
    $script:sbcActual = $Content
    $script:sbcWrites++
}
Invoke-SbcPhase '12345'
Assert-Test ($script:sbcActual -ceq $script:sbcTemplate.Replace('XXXXX', '12345') -and $script:sbcWrites -eq 1) 'SBC output did not replace every lab placeholder.'
Invoke-SbcPhase '12345'
Assert-Test ($script:sbcWrites -eq 1) 'An identical SBC rerun rewrote the file.'
$script:sbcActual = $script:sbcActual.Replace('Account=12345', 'Account=OTHER')
$conflicted = $false
try { Invoke-SbcPhase '12345' }
catch { $conflicted = $_.Exception.Message -like '*Existing SBC INI differs*' }
Assert-Test ($conflicted -and $script:sbcWrites -eq 1) 'A conflicting SBC INI was overwritten or silently accepted.'
$script:sbcActual = $script:sbcTemplate.Replace('XXXXX', '12345').Replace('Account=', 'account=')
$conflicted = $false
try { Invoke-SbcPhase '12345' }
catch { $conflicted = $_.Exception.Message -like '*Existing SBC INI differs*' }
Assert-Test ($conflicted -and $script:sbcWrites -eq 1) 'A case-only SBC INI conflict was not reported before any write.'

$script:menuResponses = [System.Collections.Generic.Queue[string]]::new()
function Read-Host {
    param([string]$Prompt)
    if ($script:menuResponses.Count -eq 0) { throw 'Unexpected input prompt in offline menu test.' }
    $script:menuResponses.Dequeue()
}
$script:menuResponses.Enqueue('9')
$script:menuResponses.Enqueue('3')
Assert-Test ((Read-SetupPhase) -eq 'Domain') 'Invalid menu choice did not prompt again or select Domain.'
$script:menuResponses.Enqueue('1')
Assert-Test ((Read-SetupPhase) -eq 'Guided') 'Menu did not offer the guided sequence.'
$script:menuResponses.Enqueue('q')
Assert-Test ($null -eq (Read-SetupPhase)) 'Menu exit did not cancel before changes.'
$script:menuResponses.Enqueue('12')
$script:menuResponses.Enqueue('12345')
Assert-Test ((Read-LabNumber) -eq '12345') 'Lab number prompt accepted an incomplete number.'
$script:menuResponses.Enqueue('Q')
Assert-Test ($null -eq (Read-LabNumber)) 'Lab number prompt did not allow exit.'
$script:menuResponses.Enqueue('192.168.1.1')
$script:menuResponses.Enqueue('8.8.8.8')
Assert-Test ((Read-PublicIp) -eq '8.8.8.8') 'Public IP prompt accepted a private address.'
$script:menuResponses.Enqueue('Q')
Assert-Test ($null -eq (Read-PublicIp)) 'Public IP prompt did not allow exit.'
Assert-Test ((Get-PhaseDescription 'Sbc') -like '*No SBC is deployed*') 'Menu did not explain the SBC phase boundary.'

Write-Host 'Offline Lab 3 V3 tests passed.'
