
# Lab 01 — Microsoft Graph Permissions

## 1. Purpose

This document explains the Microsoft Graph permissions requested by `Get-LabUserReport.ps1`, why they are required, and the security considerations associated with their use.

## 2. Authentication Method

The script uses interactive delegated Microsoft Graph authentication.

Authentication is initiated using `Connect-MgGraph` with:

- `-TenantId`
- `-Scopes`
- `-ContextScope Process`
- `-UseDeviceCode`
- `-NoWelcome`

The authentication session operates using the identity of the signed-in user.

The requested permissions do not bypass the signed-in account's applicable access restrictions.

## 3. Required Delegated Permissions

| Permission | Type | Purpose |
|---|---|---|
| `User.Read.All` | Delegated | Read Microsoft Entra user information required for reporting |
| `GroupMember.Read.All` | Delegated | Read group memberships required to determine direct group associations |

These permissions are requested by the script:

```powershell
$requiredScopes = @(
    'User.Read.All',
    'GroupMember.Read.All'
)
```

Both permissions are read-oriented. Neither scope grants general write access to directory users or groups.

However, read access can still expose sensitive identity and organisational information.

## 4. Consent Requirements

The requested permissions require appropriate consent.

Administrator consent may be required depending on the permission and tenant configuration.

The account must also be authorised to access the requested directory information.

Authentication success does not automatically guarantee that every directory query will succeed.

## 5. Authentication Context Validation

After authentication, the script retrieves the Microsoft Graph context using:

```powershell
$context = Get-MgContext
```

The script checks that:

1. An authentication context exists.
2. The connected tenant matches the supplied Tenant ID.
3. The required scopes are present.

If these checks fail, the script raises an error.

## 6. Least-Privilege Considerations

The script requests delegated read permissions needed for the intended reporting operations.

It does not request write scopes such as:

- `User.ReadWrite.All`
- `Group.ReadWrite.All`
- `Directory.ReadWrite.All`

The selected read permissions nevertheless have broad directory visibility.

Before using the script outside a controlled lab, assess whether its scope, permissions and account access are appropriate for the intended environment.

## 7. Process-Scoped Authentication

The script specifies:

```powershell
-ContextScope Process
```

This requests a Microsoft Graph authentication context scoped to the current PowerShell process.

The script also attempts to disconnect from Microsoft Graph during cleanup.

Process-scoped authentication does not remove the need to protect authentication details, console output or exported files.

## 8. Report Data Protection

The generated CSV can contain:

- Display names
- User principal names
- Account status
- User type
- Group membership information
- Report generation timestamps

The output should be treated as potentially sensitive directory information.

Generated reports must not be committed to the public repository without appropriate review and sanitisation.

## 9. Validation Status

The script has been successfully authenticated and executed in the controlled IT Engineering Lab tenant.

Its successful execution demonstrates that the permissions and access available during that test were sufficient for the completed reporting operations.

This does not establish suitability for unrestricted production use.

## 10. Related Documentation

- [Lab 01 README](README.md)
- [PowerShell Script](scripts/Get-LabUserReport.ps1)
- [Test Cases](test-cases.md)
- [Troubleshooting](troubleshooting.md)
- [Repository Security Policy](../../SECURITY.md)
