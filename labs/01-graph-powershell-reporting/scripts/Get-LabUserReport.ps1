#Requires -Version 7.0

<#
.SYNOPSIS
    Generates a Microsoft Entra user account and direct group-membership report.

.DESCRIPTION
    Connects interactively to Microsoft Graph using delegated read-only
    permissions, retrieves Entra user account information and direct group
    memberships, and exports the results to a timestamped CSV file.

    Designed for use in a Microsoft 365 / Entra test tenant.

.PARAMETER TenantId
    The Microsoft Entra tenant ID to query.

.PARAMETER OutputDirectory
    Directory in which the generated CSV report will be stored.
    Defaults to an "output" directory beneath the script directory.

.EXAMPLE
    .\Get-LabUserReport.ps1 `
        -TenantId "00000000-0000-0000-0000-000000000000"

.NOTES
    Portfolio/home-lab script.
    Uses delegated authentication and read-only Microsoft Graph permissions.

    Required delegated permissions:
      - User.Read.All
      - GroupMember.Read.All
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidatePattern(
    '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
    )]
    [string]$TenantId,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputDirectory = (
        Join-Path -Path $PSScriptRoot -ChildPath 'output'
    )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$requiredModules = @(
    'Microsoft.Graph.Authentication',
    'Microsoft.Graph.Users'
)

$requiredScopes = @(
    'User.Read.All',
    'GroupMember.Read.All'
)

$graphConnected = $false

try {

    Write-Host 'Checking required Microsoft Graph modules...'

    foreach ($moduleName in $requiredModules) {

        if (-not (Get-Module -ListAvailable -Name $moduleName)) {
            throw @"
        Required PowerShell module '$moduleName' is not installed.
        
        Install the required Microsoft Graph PowerShell modules with:
        
        Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Repository PSGallery
        Install-Module Microsoft.Graph.Users -Scope CurrentUser -Repository PSGallery
        "@
        }
    }

    Import-Module Microsoft.Graph.Authentication -ErrorAction Stop
    Import-Module Microsoft.Graph.Users -ErrorAction Stop

    if (-not (Test-Path -LiteralPath $OutputDirectory)) {

        Write-Host "Creating output directory: $OutputDirectory"

        New-Item `
            -ItemType Directory `
            -Path $OutputDirectory `
            -Force |
            Out-Null
    }

    Write-Host 'Connecting to Microsoft Graph...'

    Connect-MgGraph `
        -TenantId $TenantId `
        -Scopes $requiredScopes `
        -ContextScope Process `
        -UseDeviceCode `
        -NoWelcome

    $graphConnected = $true

    $context = Get-MgContext

    if ($null -eq $context) {
        throw 'Microsoft Graph authentication context could not be retrieved.'
    }

    if ($context.TenantId -ne $TenantId) {
        throw @"
Connected tenant does not match the tenant supplied to the script.

Requested tenant: $TenantId
Connected tenant: $($context.TenantId)
"@
    }

    $missingScopes = @(
        $requiredScopes |
            Where-Object {
                $_ -notin $context.Scopes
            }
    )

    if ($missingScopes.Count -gt 0) {
        throw "Required Microsoft Graph scopes are missing: $($missingScopes -join ', ')"
    }

    Write-Host "Connected account: $($context.Account)"
    Write-Host "Connected tenant:  $($context.TenantId)"
    Write-Host 'Retrieving Microsoft Entra users...'

    $users = @(
        Get-MgUser `
            -All `
            -Property @(
                'Id',
                'DisplayName',
                'UserPrincipalName',
                'AccountEnabled',
                'UserType'
            )
    )

    if ($users.Count -eq 0) {
        throw 'Microsoft Graph returned zero users.'
    }

    $generatedUtc = [DateTime]::UtcNow

    $report = foreach ($user in $users) {

        Write-Verbose "Processing user: $($user.UserPrincipalName)"

        $groupNames = @()
        $membershipQueryStatus = 'OK'

        try {

            $groups = @(
                Get-MgUserMemberOfAsGroup `
                    -UserId $user.Id `
                    -All `
                    -Property @(
                        'Id',
                        'DisplayName'
                    ) `
                    -ErrorAction Stop
            )

            $groupNames = @(
                $groups |
                    Where-Object {
                        -not [string]::IsNullOrWhiteSpace(
                            $_.DisplayName
                        )
                    } |
                    Sort-Object DisplayName |
                    Select-Object -ExpandProperty DisplayName
            )
        }
        catch {

            $membershipQueryStatus = 'ERROR'

            Write-Warning (
                "Unable to retrieve group membership for '{0}' ({1}). {2}" -f
                $user.DisplayName,
                $user.UserPrincipalName,
                $_.Exception.Message
            )
        }

        [PSCustomObject]@{
            DisplayName            = $user.DisplayName
            UserPrincipalName      = $user.UserPrincipalName
            AccountEnabled         = $user.AccountEnabled
            UserType               = $user.UserType
            DirectGroupCount       = $groupNames.Count
            DirectGroups           = ($groupNames -join '; ')
            MembershipQueryStatus  = $membershipQueryStatus
            ReportGeneratedUtc     = $generatedUtc.ToString('o')
        }
    }

    $timestamp = $generatedUtc.ToString(
        "yyyyMMdd-HHmmss'Z'"
    )

    $outputPath = Join-Path `
        -Path $OutputDirectory `
        -ChildPath "lab-user-report-$timestamp.csv"

    $report |
        Sort-Object DisplayName |
        Export-Csv `
            -Path $outputPath `
            -NoTypeInformation `
            -Encoding utf8NoBOM

    # Check whether any group-membership queries failed.

    $failedMemberships = @(
        $report | Where-Object {
            $_.MembershipQueryStatus -eq 'ERROR'
        }
    )

    if ($failedMemberships.Count -gt 0) {
        Write-Warning (
            "Report exported, but {0} user membership queries failed. Review the CSV." -f
            $failedMemberships.Count
        )
    
        $completionMessage = 'Report generation completed with membership-query warnings.'
    }
    else {
        $completionMessage = 'Report generation completed successfully.'
    }
    
    Write-Host ''
    Write-Host $completionMessage
    Write-Host "Users processed: $($report.Count)"
    Write-Host "Output file:     $outputPath"
    Write-Host ''

    $report |
        Sort-Object DisplayName |
        Format-Table `
            DisplayName,
            AccountEnabled,
            DirectGroupCount,
            MembershipQueryStatus `
            -AutoSize
}

finally {

    if ($graphConnected) {

        Disconnect-MgGraph -ErrorAction SilentlyContinue |
            Out-Null
    }
}
