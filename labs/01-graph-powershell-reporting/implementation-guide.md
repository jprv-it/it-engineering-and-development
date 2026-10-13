
# Lab 01 — Implementation Guide

## 1. Purpose

This guide documents the implementation of the PowerShell and Microsoft Graph user reporting lab.

It explains the laboratory prerequisites, script deployment, execution and validation workflow.

For technical design details, refer to the published PowerShell script.

## 2. Lab Environment

The reporting solution was developed and tested in a controlled Microsoft 365 learning environment.

- Tenant display name: IT Engineering Lab
- Tenant domain: `itengineeringlab.onmicrosoft.com`
- Identity platform: Microsoft Entra ID
- Reporting interface: Microsoft Graph PowerShell SDK
- Execution environment: PowerShell 7
- Development editor: Visual Studio Code
- Source repository: GitHub

The laboratory contained four specifically created user accounts and two lab groups, alongside existing tenant identities and groups.

The script queries the tenant's users rather than restricting the report to only the four lab-created accounts.

The validated run returned eight users.

## 3. Prerequisites

Before executing the reporting solution, confirm:

1. PowerShell 7 is installed.
2. Internet connectivity is available.
3. You can access the intended Microsoft Entra tenant.
4. An authorised account is available for interactive authentication.
5. Required Microsoft Graph permissions have appropriate consent.
6. The tenant's GUID identifier is available.
7. Required PowerShell modules are installed.
8. The output directory is writable.

The tenant domain name is not a substitute for the tenant GUID required by the script.

## 4. Verify PowerShell

Open PowerShell 7 and execute:

```powershell
$PSVersionTable.PSVersion
```

The major version must be 7 or later.

## 5. Install Required Microsoft Graph Modules

The script uses two Microsoft Graph modules:

- `Microsoft.Graph.Authentication`
- `Microsoft.Graph.Users`

Install them if necessary:

```powershell
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser -Repository PSGallery
Install-Module Microsoft.Graph.Users -Scope CurrentUser -Repository PSGallery
```

Verify installation:

```powershell
Get-Module Microsoft.Graph.Authentication -ListAvailable
Get-Module Microsoft.Graph.Users -ListAvailable
```

These commands should return module information.

## 6. Understand the Required Permissions

The script requests these delegated scopes:

```text
User.Read.All
GroupMember.Read.All
```

These scopes support user reporting and group membership retrieval.

The script does not perform user creation, deletion or group membership changes.

For additional details, see [Permissions](permissions.md).

## 7. Prepare the Script

The published script is located at:

```text
scripts/Get-LabUserReport.ps1
```

You may download the script directly from GitHub or use it from a local repository clone.

A local clone is not required to use the script.

Save the `.ps1` file to a suitable local directory.

Do not place secrets or real tenant credentials inside the script.

## 8. Open PowerShell and Locate the Script

Open PowerShell 7.

Navigate to the folder containing the downloaded script.

For example:

```powershell
Set-Location "<DIRECTORY-CONTAINING-SCRIPT>"
```

Confirm the file is present:

```powershell
Get-Item .\Get-LabUserReport.ps1
```

If the file exists, PowerShell returns its file information.

## 9. Execute the Script

Run:

```powershell
.\Get-LabUserReport.ps1 `
    -TenantId "<YOUR-TENANT-GUID>"
```

Replace `<YOUR-TENANT-GUID>` with the GUID of the target tenant.

PowerShell validates the supplied value against the expected GUID format.

Malformed values are rejected before the main script body executes.

## 10. Complete Authentication

The script initiates Microsoft Graph device-code authentication.

Follow the instructions displayed by the authentication process.

Sign in using an authorised account associated with the intended lab tenant.

The script requests the necessary delegated Microsoft Graph permissions.

The script subsequently checks:

1. That a Microsoft Graph authentication context exists.
2. That the connected tenant matches the supplied Tenant ID.
3. That the required permission scopes are present.

## 11. User Retrieval

After authentication, the script retrieves user information through Microsoft Graph.

The requested properties include:

- ID
- Display name
- User principal name
- Account enabled status
- User type

The script is intended to retrieve the users returned by the tenant-wide query.

If no users are returned, the script raises an error.

## 12. Group Membership Retrieval

For each retrieved user, the script requests direct group membership information.

The returned group names are processed into a report-friendly representation.

The script records:

- Direct group count
- Direct group names
- Membership query status

Group names are combined into a semicolon-separated string for the CSV.

This is direct group membership reporting, not transitive membership analysis.

## 13. Membership Query Error Handling

For each user, the script attempts the membership query within a `try/catch` block.

If the query succeeds, the status is:

```text
OK
```

If the membership query raises an error, the script:

1. Records the status as `ERROR`.
2. Writes a warning.
3. Continues processing the available report data.

This avoids representing a failed query as an unquestionably valid zero-group result.

Controlled fault-injection testing of this behaviour has not yet been recorded.

## 14. CSV Generation

The script generates a timestamped CSV report.

A typical filename follows this pattern:

```text
lab-user-report-YYYYMMDD-HHMMSSZ.csv
```

The default output location is:

```text
<DIRECTORY-CONTAINING-SCRIPT>/output/
```

An alternative path can be specified with `-OutputDirectory`.

The script creates the output directory if it does not exist.

The report includes:

- `DisplayName`
- `UserPrincipalName`
- `AccountEnabled`
- `UserType`
- `DirectGroupCount`
- `DirectGroups`
- `MembershipQueryStatus`
- `ReportGeneratedUtc`

## 15. Validate the Generated Report

After a successful run, locate the output CSV.

Import it using:

```powershell
$report = Import-Csv -Path "<FULL-PATH-TO-REPORT>"
```

Display the records:

```powershell
$report | Format-Table -AutoSize
```

Inspect column names:

```powershell
$report[0].PSObject.Properties.Name
```

Count returned records:

```powershell
$report.Count
```

The validated lab run returned eight users, including the four specifically created lab accounts.

The count should not be treated as a permanent expected value because the tenant's contents can change.

## 16. Validate Against Microsoft Entra

Open the Microsoft Entra admin centre.

Compare selected report records against the source directory.

Verify:

1. Display names.
2. User principal names.
3. Account status.
4. Direct group memberships.

During the recorded validation, some additional group memberships were initially unexpected.

Investigation established that membership of the existing organisation-wide `Modern Workplace Lab` Team accounted for the additional memberships.

The results were therefore consistent with the tenant configuration.

## 17. Negative Testing

The controlled invalid Tenant ID test was performed using a deliberately malformed GUID.

The expected outcome was a PowerShell argument validation error.

The expected error was observed.

This test confirmed input format validation but did not test tenant existence or authentication permissions.

## 18. Security and Privacy

The generated reports can contain directory identity information.

Do not upload raw CSV exports from the actual tenant to the public repository.

Do not upload:

- Passwords
- Access tokens
- Device authentication codes
- Client secrets
- Unnecessary tenant identifiers
- Unredacted sensitive directory information

See the repository's [Security Policy](../../SECURITY.md).

## 19. Clean-Up and Disconnection

The script includes a `finally` block that attempts to disconnect the Microsoft Graph session established during execution.

The script is designed for read-only reporting.

It does not delete the lab users, groups or other tenant resources.

Generated local CSV files remain in their output directory unless separately removed.

## 20. Validation Record

The following activities were completed and recorded:

- Successful script execution
- Successful Microsoft Graph authentication
- CSV report generation
- CSV import
- Report structure validation
- Comparison with Microsoft Entra
- Investigation of additional group memberships
- Invalid Tenant ID negative testing

A controlled membership-query failure test remains outstanding.

For specific results, see [Test Cases](test-cases.md).

## 21. Supporting Documentation

- [Lab README](README.md)
- [PowerShell Script](scripts/Get-LabUserReport.ps1)
- [Permissions](permissions.md)
- [Test Cases](test-cases.md)
- [Troubleshooting](troubleshooting.md)
- [Lessons Learned](lessons-learned.md)
- [Evidence](evidence/README.md)
