# Lab 01 — Troubleshooting and Validation Log

## Purpose

This document records troubleshooting activities, controlled tests, observed behaviour, corrective actions and validation outcomes encountered during the development of `Get-LabUserReport.ps1`.

The objective is to demonstrate a systematic approach to diagnosing errors, validating expected behaviour and distinguishing actual defects from legitimate system behaviour.

## Test 01 — PowerShell Multiline Command Syntax

**Issue:** A PowerShell command entered across multiple lines produced a parser error.

**Observed error:** `Missing argument in parameter list.`

**Investigation:** The command included unintended PowerShell continuation prompts (`>>`) as part of the pasted command text.

**Cause:** PowerShell displays `>>` when it is expecting more input. These prompts are not part of the command being entered.

**Corrective action:** Removed the copied prompt characters and re-entered the command using valid PowerShell syntax.

**Validation:** The corrected command could be parsed and executed without the original parser error.

**Lesson:** Terminal prompts should not be included when copying commands for reuse.

## Test 02 — Tenant ID Parameter Validation

**Objective:** Verify that the script rejects malformed Microsoft Entra tenant identifiers before attempting Microsoft Graph authentication.

**Method:** Execute `Get-LabUserReport.ps1` using an intentionally malformed Tenant ID containing characters that are not valid hexadecimal digits.

**Expected result:** PowerShell should reject the supplied value during parameter validation.

**Actual result:** PowerShell returned an argument validation error indicating that the Tenant ID failed the configured regular-expression pattern.

**Outcome:** PASS

**Technical explanation:** The script uses a `ValidatePattern` attribute requiring a GUID-shaped value. This prevents malformed identifiers from reaching the script's authentication logic.

**Limitation:** This test validates the format of an identifier, not whether the tenant exists, is accessible or is the intended tenant.

## Test 03 — Microsoft Graph Authentication

**Objective:** Confirm that the script can establish an authenticated Microsoft Graph session against the intended lab tenant.

**Method:** Execute the script with a correctly formatted Tenant ID, completing the device-code authentication process using an authorised lab account.

**Expected result:** Microsoft Graph authentication succeeds and the script proceeds with its read-only reporting operations.

**Actual result:** Authentication was successful during the working script's execution.

**Outcome:** PASS

**Lesson:** Authentication is a separate dependency from PowerShell syntax, parameter validation and report generation.

## Test 04 — Microsoft Graph Group Membership Reporting

**Observation:** Some lab users appeared as members of more groups than the manually created lab groups alone would suggest.

**Investigation:** Compared the script's group membership results against the memberships visible in Microsoft Entra and Microsoft Teams.

**Finding:** Membership of the existing organisation-wide Team, `Modern Workplace Lab`, accounted for an additional group membership for the relevant accounts.

**Conclusion:** The additional memberships were legitimate tenant state, not a script defect.

**Lesson:** Reported data should be compared with the source environment before treating an unexpected result as an error.

## Test 05 — CSV Report Validation

**Objective:** Confirm that the generated CSV contains the expected columns and coherent reporting data.

**Method:**

1. Execute the script successfully.
2. Locate the generated timestamped CSV file.
3. Import the file using PowerShell's `Import-Csv` cmdlet.
4. Examine the returned objects and their properties.
5. Compare selected user and group information with Microsoft Entra.

**Expected result:** The CSV can be imported, contains the expected columns and reflects the queried tenant state.

**Actual result:** The reporting output was successfully imported and reviewed.

**Outcome:** PASS

**Note:** The report includes all returned users in the scope of the Graph query, not only the four specifically created lab accounts.

## Test 06 — Partial Membership Data Handling

**Objective:** Verify that a failure to retrieve a user's group membership is identifiable rather than silently interpreted as a genuine zero-group result.

**Implemented safeguard:** The script includes a membership-query status field and warning behaviour for failed membership retrieval.

**Validation status:** Implementation reviewed; controlled failure-injection testing has not yet been recorded.

**Further test:** Simulate an appropriate membership retrieval failure in a controlled lab environment and verify that the CSV and terminal output accurately indicate the unsuccessful query.

**Lesson:** In operational reporting, missing data and valid empty results are not equivalent.

## Summary

The completed tests demonstrate PowerShell troubleshooting, parameter validation, successful Microsoft Graph authentication, group membership interpretation, CSV validation and source-system comparison.

The tests also distinguish confirmed successful outcomes from safeguards that have been implemented but not independently tested through fault injection.

The documented process demonstrates the principle that a successful script execution is only one part of solution validation.
