
# Lab 01 — Evidence Index

## Purpose

This folder contains screenshots documenting the execution, testing and validation of the Lab 01 PowerShell and Microsoft Graph reporting solution.

Screenshots are located in the `screenshots/` subdirectory.

## Evidence Register

| ID | Screenshot | Description |
|---|---|---|
| EV-01 | [Script Invocation](screenshots/01-script-execution-success.png) | Initial PowerShell script invocation, module loading and start of execution |
| EV-02 | [Graph Authentication](screenshots/02-graph-authentication.png) | Microsoft Graph device-code authentication and successful continuation |
| EV-03 | [Successful Report Completion](screenshots/03-report-terminal-output.png) | Successful report completion, eight users processed and terminal output |
| EV-04 | [Import-Csv Validation](screenshots/04-import-csv.png) | PowerShell import and inspection of the generated CSV |
| EV-05 | [CSV Report Validation](screenshots/05-csv-report-validation.png) | Eight report records, exported columns and group membership data |
| EV-06 | [Entra User Source Validation](screenshots/06-entra-source-validation.png) | Microsoft Entra user-list comparison for identity, user type and account status |
| EV-07 | [Invalid Tenant ID Test](screenshots/07-invalid-tenant-id-test.png) | Controlled negative test demonstrating rejection of malformed GUID input |
| EV-08 | [Group A Membership Validation](screenshots/08-group-a-members.png) | Direct members of LAB-GRAPH-REPORTING-A: Lab Graph 02 and Lab Graph 03 |
| EV-09 | [Group B Membership Validation](screenshots/09-group-b-members.png) | Direct members of LAB-GRAPH-REPORTING-B: Lab Graph 03 and Lab Graph 04 |

EV-01, EV-02 and EV-03 document different phases of the same successful PowerShell execution. They are purpose-specific extracts of one execution session and do not represent three independent script runs.

## Testing and Validation

The evidence supports the documented tests covering:

- Script execution
- Delegated Microsoft Graph authentication
- Report generation
- CSV import and inspection
- Source-system comparison
- Invalid-input handling

Not every implemented error-handling feature has undergone controlled failure-injection testing.

Refer to [Test Cases](../test-cases.md) for the recorded outcomes and remaining test limitations.

## Security and Privacy

The screenshots in this register have been reviewed and sanitised for public viewing. Authentication details, sensitive account identities and unnecessary tenant identifiers have been obscured. Lab-specific demonstration information has been retained where necessary to support the documented test results.

Raw tenant-generated CSV reports are not intended for inclusion in the public repository.

See the [Repository Security Policy](../../../SECURITY.md).

## Related Documentation

- [Lab README](../README.md)
- [Implementation Guide](../implementation-guide.md)
- [Test Cases](../test-cases.md)
- [Troubleshooting](../troubleshooting.md)
