# IT Engineering and Development Portfolio

## Overview

Welcome to my IT Engineering and Development portfolio.

This repository documents practical projects, home labs, automation scripts, technical investigations and learning activities undertaken to develop and demonstrate my capabilities in IT engineering, cloud infrastructure, identity and access management, endpoint management, cybersecurity and software development.

The portfolio emphasises practical implementation, troubleshooting, validation, documentation and continuous improvement.

Each completed lab is intended to demonstrate not only how a solution was implemented, but also how its functionality, reliability and security considerations were assessed.

## Professional Focus

My current areas of professional development include:

- Microsoft 365 administration and engineering
- Microsoft Entra ID and identity management
- Microsoft Intune and endpoint management
- PowerShell scripting and automation
- Microsoft Graph API integration
- Microsoft Azure infrastructure and networking
- Cloud security and identity protection
- Infrastructure as Code and DevOps
- Software development and engineering

This repository will expand as additional projects are implemented and validated.

## Completed and Developing Labs

### Lab 01 — PowerShell and Microsoft Graph User Reporting

**Status:** Complete — core reporting functionality validated. A final-script retest is recorded in the Lab 01 test cases. Documentation and reviewed evidence are included. Controlled membership-query failure testing (TC-07) remains NOT TESTED.

**Technologies:**
- PowerShell 7
- Microsoft Graph PowerShell SDK
- Microsoft Entra ID
- Microsoft 365
- GitHub
- Visual Studio Code

**Objective:**

Develop a reusable PowerShell reporting solution that connects to Microsoft Graph, retrieves Microsoft Entra ID user and direct group membership information, and exports the results to a timestamped CSV file.

**Demonstrated capabilities:**
- PowerShell scripting
- Parameter handling and validation
- Microsoft Graph authentication
- Microsoft Entra directory reporting
- Direct group membership retrieval
- CSV report generation
- Error handling
- Troubleshooting and controlled testing
- Technical documentation
- Security and privacy considerations

**Project location:** [Lab 01 — PowerShell and Microsoft Graph User Reporting](labs/01-graph-powershell-reporting/)

## Planned Development Areas

Future projects may address:

### Microsoft 365 and Modern Workplace

Identity management, device provisioning, application deployment, configuration policies and endpoint management.

### Azure Infrastructure and Networking

Cloud infrastructure deployment, network segmentation, connectivity, monitoring and troubleshooting.

### Security Engineering

Identity security, endpoint protection, access control, security monitoring and operational security practices.

### Automation and DevOps

PowerShell automation, Infrastructure as Code, Git workflows, automated testing and deployment pipelines.

### Software Engineering

Programming, API development, testing, application integration and maintainable software design.

Planned projects are not represented as completed implementations.

## Repository Structure

```text
it-engineering-and-development/
├── .gitignore
├── LICENSE
├── README.md
├── SECURITY.md
└── labs/
    └── 01-graph-powershell-reporting/
        ├── README.md
        ├── implementation-guide.md
        ├── lessons-learned.md
        ├── permissions.md
        ├── test-cases.md
        ├── troubleshooting.md
        ├── evidence/
        │   ├── README.md
        │   └── screenshots/
        │       ├── .gitkeep
        │       ├── 01-script-execution-success.png
        │       ├── 02-graph-authentication.png
        │       ├── 03-report-terminal-output.png
        │       ├── 04-import-csv.png
        │       ├── 05-csv-report-validation.png
        │       ├── 06-entra-source-validation.png
        │       ├── 07-invalid-tenant-id-test.png
        │       ├── 08-group-a-members.png
        │       └── 09-group-b-members.png
        ├── sample-output/
        │   ├── .gitkeep
        │   ├── README.md
        │   └── example-user-report.csv
        └── scripts/
            ├── .gitkeep
            └── Get-LabUserReport.ps1
```

The structure will evolve as additional laboratories and software projects are introduced.

## Engineering Approach

Projects in this repository generally follow these principles:

1. Define the technical objective and expected outcome.
2. Identify the relevant technologies, prerequisites and permissions.
3. Implement the solution in a controlled environment.
4. Test expected behaviour and investigate errors.
5. Validate outputs against appropriate reference information.
6. Document troubleshooting activities and lessons learned.
7. Review security, privacy and operational considerations.
8. Publish verified code and suitable evidence.

Not every project will require the same implementation or testing methodology.

## Lab Environment

Projects are primarily performed in controlled personal learning environments.

The Microsoft 365 and Entra ID laboratory is identified as **IT Engineering Lab**.

The laboratory tenant's domain is included for technical context. Credentials, authentication material and sensitive tenant-specific configuration details are not required to reproduce the published examples and must not be included in public artefacts.

Any published sample data should be synthetic or appropriately sanitised.

## Documentation Standards

Where applicable, labs may contain:

- A project README
- An implementation guide
- Source code or automation scripts
- Troubleshooting records
- Test cases and validation outcomes
- Screenshots or other technical evidence
- Lessons learned
- Security and privacy notes

Documentation will distinguish completed and verified work from future improvements.

## Security

This repository is intended for technical learning and professional portfolio demonstration.

Do not publish authentication tokens, passwords, private keys, sensitive directory exports or confidential organisational information.

See [SECURITY.md](SECURITY.md) for the repository security policy.

## Disclaimer

Projects are developed for learning and demonstration.

Scripts and configuration examples should be reviewed and tested before use in other environments, particularly production systems.

Availability, permissions, tenant configuration and software versions may affect behaviour.

## Portfolio Development

This portfolio is a continuing record of practical IT engineering and software development.

Its primary objective is to demonstrate technical capability through working solutions, evidence-based validation, structured troubleshooting and clear documentation.
