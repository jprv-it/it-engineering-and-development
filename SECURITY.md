# Security Policy

## 1. Purpose

This document describes the security principles, reporting procedures and handling requirements applicable to the IT Engineering and Development portfolio.

The repository contains technical learning projects, laboratory exercises, scripts and supporting documentation.

Although the projects are primarily intended for education and professional demonstration, security and privacy are treated as integral engineering considerations.

## 2. Supported Projects

The repository is maintained as a personal learning and professional development portfolio.

Projects may be updated, enhanced or replaced as new technologies and implementation approaches are adopted.

| Project category | Security maintenance |
|---|---|
| Completed published labs | Reviewed when issues are identified |
| Projects under development | Updated during active development |
| Historical or archived examples | Not guaranteed to receive updates |

No formal production support or security service-level agreement is provided.

## 3. Reporting Security Vulnerabilities

If you identify a potential vulnerability in code or configurations published in this repository, please report it privately.

Where GitHub private vulnerability reporting is enabled, use the repository's **Security** section to submit a report.

Do not disclose sensitive vulnerability details through public issues, discussions or pull requests before they have been reviewed.

A useful security report should include:

- The affected file or project.
- A description of the potential vulnerability.
- Steps to reproduce the issue where safe and appropriate.
- The possible security impact.
- Suggested mitigation, if known.

Reports will be reviewed on a best-effort basis.

Private reporting availability depends on repository configuration.

## 4. Credentials and Secrets

The repository must not intentionally contain:

- Passwords
- Access tokens or refresh tokens
- API keys
- Client secrets
- Private encryption keys
- Authentication device codes
- Sensitive connection strings
- Credentials associated with real organisations

Authentication information must be handled securely and excluded from public source files and documentation.

If sensitive information is accidentally committed, the affected credentials should be revoked or rotated as appropriate.

Removing information from the latest version of a file does not necessarily remove it from Git history.

## 5. Microsoft 365, Entra ID and Azure Data

Laboratory projects may interact with Microsoft cloud services.

Published material should not unnecessarily expose:

- Personal information
- Real user directory exports
- Confidential organisational information
- Privileged account information
- Sensitive tenant configurations
- Access-control details that could increase security risk

Environment-specific identifiers should be removed or replaced with placeholders where practicable.

The presence of a value in a test environment does not automatically make it suitable for public distribution.

## 6. Generated Reports and Evidence

Scripts may generate CSV files, log files, diagnostic reports and screenshots.

Generated outputs must be reviewed before publication.

Where possible, use synthetic data for public samples.

If actual laboratory evidence is published, it should be appropriately sanitised.

Local output directories should be excluded from source control where practical.

Screenshots should be reviewed for exposed identifiers, session information and authentication details.

## 7. Least Privilege

Scripts should request only the permissions necessary for their intended functionality.

Read-only access is preferred where a task does not require modification.

Read-only access does not eliminate data protection responsibilities.

Permission requirements should be documented in individual lab README files.

## 8. Script Execution and Safe Use

Published scripts are provided for learning and demonstration.

Users should review the code and understand the permissions required before executing it.

Scripts should initially be tested in non-production environments.

Do not assume that a script validated in one tenant or environment is immediately suitable for another.

## 9. Dependency Management

Projects may depend on external modules, libraries, APIs and platform services.

Dependencies should be obtained from trusted sources.

Users should review module versions, supported platforms and known security advisories.

Outdated or unsupported dependencies should be assessed before reuse.

## 10. Responsible Disclosure and Remediation

Potential security issues should be investigated and addressed according to their severity and relevance.

Appropriate corrective actions may include:

- Updating affected code.
- Reducing excessive permissions.
- Removing sensitive information.
- Replacing compromised credentials.
- Updating dependencies.
- Revising documentation and usage guidance.

Security fixes may be recorded through repository commits or other appropriate GitHub mechanisms.

## 11. Scope and Disclaimer

This repository is not presented as a production-ready software distribution.

No warranty is provided regarding suitability for production deployment.

Users remain responsible for validating compatibility, permissions, security and regulatory requirements in their own environments.

## 12. Policy Review

This security policy may be revised as the repository develops and as additional projects introduce new security considerations.
