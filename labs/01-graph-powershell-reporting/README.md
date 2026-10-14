# Lab 01 — PowerShell and Microsoft Graph User Reporting

## 1. Project Overview

This lab demonstrates the use of PowerShell 7 and the Microsoft Graph PowerShell SDK to retrieve Microsoft Entra ID user and direct group membership information.

The solution exports the retrieved information into a timestamped CSV report.

The lab was developed and tested in a controlled Microsoft 365 learning tenant named **IT Engineering Lab**.

## 2. Objectives

- Connect to Microsoft Graph using delegated authentication.
- Retrieve Microsoft Entra ID user information.
- Identify direct group memberships.
- Generate a structured CSV report.
- Implement parameter validation and error handling.
- Validate output against Microsoft Entra ID.
- Document troubleshooting, testing and lessons learned.

## 3. Technologies Used

| Technology | Purpose |
|---|---|
| PowerShell 7 | Script execution and automation |
| Microsoft Graph PowerShell SDK | Microsoft Graph authentication and directory queries |
| Microsoft Entra ID | Source of user and group data |
| Microsoft 365 | Supporting cloud environment |
| Visual Studio Code | Script development |
| GitHub | Source control and portfolio documentation |

## 4. Prerequisites

Before running the script, ensure that:

1. PowerShell 7 is installed.
2. The required Microsoft Graph PowerShell modules are available.
3. You have access to a Microsoft Entra tenant.
4. You have a user account authorised to perform the required directory queries.
5. The required delegated Microsoft Graph permissions can be granted or have already been consented to.
6. You have the tenant's GUID identifier.
7. You have permission to write to the selected report output directory.
8. You have a working internet connection.

The script was developed using a laboratory tenant. Production use requires separate assessment.

### Verify PowerShell Version

Open PowerShell 7 and run:

```powershell
$PSVersionTable.PSVersion
```

The installed PowerShell major version must be 7 or later.

## 5. Required PowerShell Modules

The script uses:

- `Microsoft.Graph.Authentication`
- `Microsoft.Graph.Users`

### Installation

Execute the following commands in PowerShell 7:

```powershell
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser

Install-Module Microsoft.Graph.Users -Scope CurrentUser
```

Install modules only from a trusted source and review installation prompts.

### Verification

```powershell
Get-Module Microsoft.Graph.Authentication -ListAvailable

Get-Module Microsoft.Graph.Users -ListAvailable
```

The commands should return information about the installed modules.

For this lab, the script uses Microsoft Graph delegated permissions:

- `User.Read.All`
- `GroupMember.Read.All`

Both User.Read.All and GroupMember.Read.All require administrator consent. An appropriately authorised administrator must grant consent unless the required consent has already been granted for the Microsoft Graph PowerShell application in the tenant.

## 6. Script File

The PowerShell script is located at:

```text
scripts/Get-LabUserReport.ps1
```

The script performs the following high-level operations:

1. Validates the supplied Tenant ID.
2. Checks required Microsoft Graph modules.
3. Establishes Microsoft Graph authentication.
4. Retrieves user records from Microsoft Entra ID.
5. Retrieves direct group memberships for each user.
6. Constructs structured report objects.
7. Exports the report to a timestamped CSV file.
8. Displays execution information.
9. Handles errors and disconnects the Microsoft Graph session.

## 7. Parameters

| Parameter | Required | Description |
|---|---|---|
| `-TenantId` | Yes | GUID identifying the target Microsoft Entra tenant |
| `-OutputDirectory` | No | Directory where the generated CSV report is saved |

### TenantId

The Tenant ID must follow standard GUID formatting.

Example format:

```text
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

The script checks the formatting before proceeding.

A correctly formatted GUID does not by itself guarantee that the tenant exists or that the account has access.

### OutputDirectory

The output directory is optional.

If it is not supplied, the script uses its configured default output location.

In the current implementation, this is the `output` directory associated with the script.

## 8. Example Execution

Open PowerShell 7.

Navigate to the directory containing the script:

```powershell
Set-Location "<FULL-PATH-TO-REPOSITORY>\labs\01-graph-powershell-reporting\scripts"
```

Replace `<FULL-PATH-TO-REPOSITORY>` with the location where the repository is stored on your computer.

If you have not cloned the GitHub repository, use the directory where you saved `Get-LabUserReport.ps1` instead.

Run the script using:

```powershell
.\Get-LabUserReport.ps1 `
    -TenantId "<YOUR-TENANT-GUID>"
```

Replace `<YOUR-TENANT-GUID>` with the GUID of your Microsoft Entra tenant.

The script uses Microsoft Graph device-code authentication. Follow the displayed instructions and sign in with an authorised lab account.

By default, the generated report is saved to an `output` directory beneath the directory containing the script.

To specify an alternative output location:

```powershell
.\Get-LabUserReport.ps1 `
    -TenantId "<YOUR-TENANT-GUID>" `
    -OutputDirectory ".\output"
```

When `-OutputDirectory` is supplied as a relative path, it is resolved relative to the current PowerShell working directory.

Do not include authentication codes, access tokens or other sensitive information in screenshots or public documentation.

## 9. Expected Output

The script generates a timestamped CSV file with a filename similar to:

```text
lab-user-report-20261012-190000Z.csv
```

The timestamp shown above is illustrative, not an actual report filename.

The generated CSV includes these columns:

| Column | Description |
|---|---|
| `DisplayName` | User's display name |
| `UserPrincipalName` | User principal name |
| `AccountEnabled` | Whether the account is enabled |
| `UserType` | Microsoft Entra user classification |
| `DirectGroupCount` | Number of directly associated groups returned |
| `DirectGroups` | Names of the returned direct groups |
| `MembershipQueryStatus` | Status of the group membership query |
| `ReportGeneratedUtc` | UTC timestamp associated with report generation |

A synthetic example of the eight-column report is available in [Sample CSV](sample-output/example-user-report.csv), with supporting notes in the [Sample Output README](sample-output/README.md). This example is illustrative and does not contain actual directory exports.

The report is generated from the tenant's current state.

User counts and membership counts may change as tenant configuration changes.

## 10. Testing and Validation

### Test 01 — Successful Script Execution

Run the script using a valid Tenant ID and authorised account.

**Expected result:** The script completes and generates a CSV report.

**Recorded result:** PASS

### Test 02 — CSV Structure Validation

Import the generated report:

```powershell
$report = Import-Csv -Path "<FULL-PATH-TO-GENERATED-CSV>"

$report | Format-Table -AutoSize
```

Inspect the column names:

```powershell
$report[0].PSObject.Properties.Name
```

Count the returned records:

```powershell
$report.Count
```

**Expected result:** The report contains the documented columns and the returned user records.

**Recorded result:** PASS

The validated laboratory run contained eight user records, including the four lab accounts created for the exercise.

### Test 03 — Microsoft Entra Source Verification

Compare selected report records with Microsoft Entra ID.

Verify:

- User display names
- User principal names
- Account enabled/disabled status
- Direct group memberships

**Expected result:** Reported information agrees with the source tenant.

**Recorded result:** PASS for the checked records and memberships.

### Test 04 — Invalid Tenant ID

Execute the script with an intentionally malformed Tenant ID.

**Expected result:** Parameter validation rejects the supplied value.

**Recorded result:** PASS

### Test 05 — Membership Query Failure

Test that a failed membership query is distinguishable from a successful query returning no groups.

**Expected result:** An appropriate warning or status identifies the failure.

**Recorded result:** NOT YET CONTROLLED-TESTED

The script implements membership-query status reporting, but a controlled failure-injection result has not yet been recorded.

## 11. Evidence

The Lab 01 evidence register is available here:

[Evidence Index](evidence/README.md)

Nine screenshots are stored in:

`evidence/screenshots/`

The evidence covers:

1. Initial PowerShell script invocation.
2. Microsoft Graph authentication.
3. Successful report completion.
4. PowerShell CSV import.
5. CSV report structure and results.
6. Microsoft Entra user-list validation.
7. Invalid Tenant ID rejection.
8. Group A direct membership verification.
9. Group B direct membership verification.

The two lab-group screenshots support validation of the group memberships returned by the reporting solution.

The published evidence screenshots have been reviewed and sanitised to remove authentication information, privileged account identities and unnecessary directory details.

The script's controlled membership-query failure scenario remains untested. Refer to [Test Cases](test-cases.md) for the detailed validation status.

## 12. Security and Privacy Considerations

### Authentication

The script uses delegated Microsoft Graph authentication with device-code sign-in.

The authentication context is process-scoped.

### Permissions

The requested delegated scopes are:

```text
User.Read.All
GroupMember.Read.All
```

These permissions are used for reporting and do not grant write access through these scopes.

They can nevertheless provide access to directory information that requires appropriate handling.

### Data Protection

Generated reports may contain:

- Display names
- User principal names
- Account status
- User types
- Group memberships

Reports should be stored securely and should not automatically be published to public repositories.

### Repository Security

Never commit:

- Passwords
- Authentication tokens
- Device authentication codes
- Client secrets
- Private keys
- Unredacted sensitive reports
- Confidential tenant information

The source repository should contain code, documentation and appropriately reviewed evidence.

## 13. Limitations

- The script requires Microsoft Graph connectivity.
- Appropriate permissions and consent are required.
- The report depends on the tenant state at execution time.
- Group reporting focuses on direct group memberships, not transitive membership.
- The report should not be interpreted as a complete identity governance or security audit.
- Additional controlled failure testing may be useful.
- Production deployment and automated scheduling are outside the scope of the current lab.

## 14. Troubleshooting

See [Troubleshooting](troubleshooting.md) for documented syntax errors, authentication validation, group membership interpretation and reporting tests.

## 15. Lessons Learned

See [Lessons Learned](lessons-learned.md) for the technical and operational learning outcomes.

## 16. Implementation Guide

See [Implementation Guide](implementation-guide.md) for the detailed lab implementation process.

## 17. Future Improvements

Potential improvements include:

- Automated Pester tests
- Failure-injection testing
- Additional synthetic sample reports illustrating membership-query failures and other edge cases
- Configurable reporting filters
- PowerShell static analysis
- Automated test execution through GitHub Actions
- Additional reporting and monitoring capabilities

These features are future development opportunities, not completed functionality.

## 18. Conclusion

The lab demonstrates a functional PowerShell and Microsoft Graph reporting solution with input validation, structured CSV generation, source-system verification and technical documentation.

It provides practical evidence of Microsoft Entra ID administration, PowerShell automation, troubleshooting, cloud authentication and reporting skills.
