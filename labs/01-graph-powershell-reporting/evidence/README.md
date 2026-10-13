
# Lab 01 — Evidence Index

## Purpose

This folder contains screenshots documenting the execution, testing and validation of the Lab 01 PowerShell and Microsoft Graph reporting solution.

Screenshots are located in the `screenshots/` subdirectory.

## Evidence Register

| ID | Screenshot | Description |
|---|---|---|
| EV-01 | [Script Execution Success](screenshots/01-script-execution-success.png) | Successful execution of the PowerShell reporting script |
| EV-02 | [Graph Authentication](screenshots/02-graph-authentication.png) | Microsoft Graph authentication evidence |
| EV-03 | [Report Terminal Output](screenshots/03-report-terminal-output.png) | Terminal output produced by the reporting process |
| EV-04 | [Import-Csv](screenshots/04-import-csv.png) | Importing the generated CSV into PowerShell |
| EV-05 | [CSV Report Validation](screenshots/05-csv-report-validation.png) | Inspection and validation of generated report data |
| EV-06 | [Entra Source Validation](screenshots/06-entra-source-validation.png) | Comparison of reported membership information against the source environment |
| EV-07 | [Invalid Tenant ID Test](screenshots/07-invalid-tenant-id-test.png) | Controlled negative test demonstrating parameter validation |

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

Screenshots should be reviewed for sensitive information before public publication.

Raw tenant-generated CSV reports are not intended for inclusion in the public repository.

See the [Repository Security Policy](../../../SECURITY.md).

## Related Documentation

- [Lab README](../README.md)
- [Implementation Guide](../implementation-guide.md)
- [Test Cases](../test-cases.md)
- [Troubleshooting](../troubleshooting.md)
