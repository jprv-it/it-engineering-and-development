
# Lab 01 — Test Cases and Validation Results

## 1. Purpose

This document records the functional, negative and data-validation tests associated with `Get-LabUserReport.ps1`.

The purpose is to establish which behaviours have been verified and which remain untested.

Tests documented here are based on the actual Lab 01 execution, validation and troubleshooting records.

## 2. Test Environment

- Environment: IT Engineering Lab
- Tenant domain: `itengineeringlab.onmicrosoft.com`
- Shell: PowerShell 7
- API interface: Microsoft Graph PowerShell SDK
- Authentication: Delegated device-code authentication
- Script: `scripts/Get-LabUserReport.ps1`
- Output format: Timestamped CSV

The validated report included eight user records, of which four were specifically created for the lab.

## 3. Test Summary

| Test ID | Test | Status |
|---|---|---|
| TC-01 | PowerShell command syntax correction | PASS |
| TC-02 | Valid script execution | PASS |
| TC-03 | Microsoft Graph authentication | PASS |
| TC-04 | CSV import and structure | PASS |
| TC-05 | User and group source validation | PASS |
| TC-06 | Invalid Tenant ID rejection | PASS |
| TC-07 | Controlled membership-query failure | NOT TESTED |

## 4. Detailed Test Cases

### TC-01 — PowerShell Command Syntax

**Objective:** Confirm that a PowerShell multiline command executes after removing incorrectly copied terminal continuation prompts.

**Procedure:**
1. Review the command that produced the parser error.
2. Remove unintended `>>` prompt text.
3. Re-enter the command using valid PowerShell syntax.

**Expected result:** The original parser error no longer occurs.

**Actual result:** The corrected command was accepted.

**Status:** PASS

**Reference:** `troubleshooting.md`, Test 01.

### TC-02 — Successful Script Execution

**Objective:** Verify that the reporting script completes successfully with valid input and appropriate access.

**Procedure:**
1. Open PowerShell 7.
2. Run the script with the correct Tenant ID.
3. Complete device-code authentication.
4. Allow the script to retrieve directory data and generate the report.

**Expected result:** The script retrieves users, processes memberships and generates a timestamped CSV.

**Actual result:** Successful script execution and report generation were observed.

**Status:** PASS

**Evidence:**

- `evidence/screenshots/01-script-execution-success.png` — initial script invocation.
- `evidence/screenshots/03-report-terminal-output.png` — successful completion and report results.

**Final script revision retest:**

- Date: 13 October 2026
- Version: Latest published Get-LabUserReport.ps1
- Outcome: PASS
- Users returned: 8
- Expected CSV columns: 8 of 8
- Membership query errors: 0
- Notes: Retested after the script's error-handling and module-guidance corrections.

### TC-03 — Microsoft Graph Authentication

**Objective:** Confirm that Microsoft Graph authentication succeeds.

**Procedure:**
1. Execute the script using a valid Tenant ID.
2. Complete the device-code sign-in.
3. Confirm that the script continues to retrieve directory information.

**Expected result:** Authentication completes successfully.

**Actual result:** Authentication was successful during the validated lab run.

**Status:** PASS

**Evidence:** `evidence/screenshots/02-graph-authentication.png`

### TC-04 — CSV Import and Structure

**Objective:** Confirm that the generated CSV can be imported and contains the expected fields.

**Procedure:**
1. Locate the generated CSV.
2. Import it using `Import-Csv`.
3. Inspect the returned records and column names.
4. Confirm the expected user count.

**Expected columns:**

- `DisplayName`
- `UserPrincipalName`
- `AccountEnabled`
- `UserType`
- `DirectGroupCount`
- `DirectGroups`
- `MembershipQueryStatus`
- `ReportGeneratedUtc`

**Expected result:** The CSV is readable and contains the expected report structure.

**Actual result:** The generated CSV was imported and reviewed. Eight user records were present in the validated run.

**Status:** PASS

**Evidence:**
- `evidence/screenshots/04-import-csv.png`
- `evidence/screenshots/05-csv-report-validation.png`

### TC-05 — User and Group Source Validation

**Objective:** Confirm that selected reported values correspond with Microsoft Entra directory information.

**Procedure:**
1. Review report records.
2. Compare selected user details against Microsoft Entra.
3. Compare direct group memberships with source directory and Teams information.
4. Investigate discrepancies.

**Expected result:** The selected report values match the actual source configuration.

**Actual result:** The checked records and memberships were consistent with the source environment.

An additional membership associated with the existing organisation-wide `Modern Workplace Lab` Team explained the unexpected group count for relevant users.

**Status:** PASS for checked user records and the two lab-group membership comparisons.

**Evidence:**

- `evidence/screenshots/06-entra-source-validation.png` — user identity, user type and account-status source comparison.
- `evidence/screenshots/08-group-a-members.png` — direct members of LAB-GRAPH-REPORTING-A.
- `evidence/screenshots/09-group-b-members.png` — direct members of LAB-GRAPH-REPORTING-B.

The group screenshots validate the memberships of the two purpose-created laboratory groups. They do not constitute an exhaustive validation of every group membership in the tenant.

### TC-06 — Invalid Tenant ID Rejection

**Objective:** Confirm that malformed tenant identifiers are rejected before authentication.

**Procedure:**
1. Execute the script with a deliberately malformed Tenant ID.
2. Observe PowerShell parameter validation.

**Expected result:** The invalid value is rejected by the `ValidatePattern` constraint.

**Actual result:** PowerShell returned the expected parameter validation error.

**Status:** PASS

**Evidence:** `evidence/screenshots/07-invalid-tenant-id-test.png`

**Limitation:** This validates the GUID format only, not tenant existence or authorisation.

### TC-07 — Controlled Membership-Query Failure

**Objective:** Confirm that a failed group membership query is explicitly identified.

**Implemented behaviour:** The script sets `MembershipQueryStatus` to `ERROR` and issues warnings if group membership retrieval fails.

**Expected result:** A controlled failure produces an error status and warning while preserving the distinction between unsuccessful retrieval and zero group memberships.

**Actual result:** No controlled failure-injection result has been recorded.

**Status:** NOT TESTED

**Next action:** Conduct a safe controlled failure-injection test if this functionality is to be independently validated.

Do not record this test as passed until its outcome has been observed.

## 5. Validation Conclusion

The completed tests demonstrate successful script execution, delegated authentication, structured CSV reporting, directory comparison and invalid-input rejection.

The controlled group-membership failure scenario remains untested.

Accordingly, the reporting solution has demonstrated its core functionality, while full validation of every error-handling path remains a future improvement.

## 6. Related Documentation

- [Lab 01 README](README.md)
- [Troubleshooting](troubleshooting.md)
- [Lessons Learned](lessons-learned.md)
- [Evidence Index](evidence/README.md)
- [PowerShell Script](scripts/Get-LabUserReport.ps1)
