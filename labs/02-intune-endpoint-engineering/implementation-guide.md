# Lab 02 — End-to-end implementation guide

**Status:** Instructions only; no steps are marked completed. Enter actual observations in the Phase 1 results table below, and enter corresponding summary test outcomes in `test-cases.md`. Do not mark unperformed checks PASS.

## Phase 0 — Change-control and safe scope
1. Retain Lab 01 unchanged. Create the new `labs/02-intune-endpoint-engineering/` folder. Do not publish `build/`, `.intunewin`, installer binaries, tokens or raw Intune diagnostic ZIPs.
2. Record tenant admin, pilot UPN (redacted in public screenshots), proposed group and VM names, intended change, anticipated effect, recovery action, initial state and testing date in `change-record.md`.
3. Confirm that no tenant-wide security/default compliance/Conditional Access policy is changed for this lab. If an existing policy conflicts, document it and narrow the pilot rather than disabling it globally.

## Phase 1 — Prerequisites (capture proof before provisioning)
1. Open https://intune.microsoft.com > Tenant administration > Tenant status. Capture MDM authority and Intune entitlement (sanitise if publishing).
2. Open https://admin.microsoft.com > Billing > Your products; confirm **Microsoft 365 Business Premium**. Open Users > Active users and identify an available licence. A user actually using Intune must be licensed; a licence in stock does not by itself prove a user is licensed.
3. Confirm Entra device join permission: https://entra.microsoft.com > Entra ID > Devices > Device settings > Users may join devices to Microsoft Entra. Verify your pilot user is allowed, and their device join limit is not exhausted.
4. Verify existing Intune enrolment restrictions at Devices > Device onboarding > Enrollment > Device platform restrictions / device limit restrictions. Allow only the necessary controlled enrolment. A corporate join can be blocked by restrictive personal-enrolment rules; document the observed rule.
5. **Read-only check now:** Inspect Windows automatic MDM enrollment at Devices > Device onboarding > Enrollment > Windows > Automatic Enrollment. Record the CURRENT MDM user scope (None / Some / All), selected groups if applicable, and whether other MDM providers have overlapping scope. Do not change the scope yet: the pilot group has not been created. In Phase 2, after creating the group, set scope to Some for the pilot only if it is necessary and will not disrupt existing users; if scope is already All, document the existing setting instead of narrowing it without a change plan.
6. **VM support/licensing gate:** Microsoft's Intune VM guidance expressly documents support for **Windows Enterprise VMs**, with limitations. Prefer Windows 11 Enterprise x64 for this lab. A Windows 11 Pro VM may technically enroll, but do NOT treat that as a documented supported Intune VM configuration. Verify proper guest licensing; a host Windows licence does not itself prove VM rights. Microsoft offers a time-limited Windows 11 Enterprise evaluation (check its conditions and expiry). For Windows 11 VM hardware, allocate 2+ vCPUs, 8 GB RAM recommended (4 GB minimum), 64+ GB virtual disk, UEFI, Secure Boot and vTPM. Take an unjoined snapshot before enrollment; NEVER clone an enrolled identity-bearing VM into another managed device.
7. In the guest run `winver`, `Get-ComputerInfo | Select-Object WindowsProductName,OsArchitecture,OsVersion`, `Get-Tpm`, `Confirm-SecureBootUEFI`, `Test-NetConnection login.microsoftonline.com -Port 443`, `Test-NetConnection intune.microsoft.com -Port 443`. Expected: intended supported Windows edition, x64, valid guest connectivity and Windows 11 VM hardware requirements. A successful TCP 443 test is NOT a complete Intune endpoint-access test. Log errors from the TPM/Secure Boot commands; do not label unsupported capabilities PASS. If the VM is not created yet, mark this check PENDING rather than PASS.
8. Record Windows build precisely using `cmd /c ver`; record time sync (`w32tm /query /status`), disk space (`Get-PSDrive C`) and PowerShell version (`$PSVersionTable.PSVersion`). Review Intune *device platform* enrollment restrictions (including ownership, Windows platform and OS constraints), *device limits*, and Entra device joining limits; no change until justified. Do not invent values in the published preflight table.


### Phase 1 — Actual prerequisite observations (FILL IN AS YOU PROGRESS)

**How to use this table:** Replace `NOT TESTED` only after performing the check. For each row enter the observed result, check date (YYYY-MM-DD), and any redacted evidence reference or relevant warning. `PASS` means the required condition was actually verified; `BLOCKED` means you cannot complete the check; `FAIL` means the verified condition is not met. Do not enter account secrets, serial numbers, tenant GUIDs, licence keys, or raw diagnostic logs in this public file. If VM provisioning is not yet completed, `PENDING` is acceptable here but keep corresponding test cases `NOT TESTED`.

| Check ID | Check / expected result | Observed result (actual value or finding) | Status | Checked (date) | Evidence / notes |
|---|---|---|---|---|---|
| P01 | Correct Entra tenant/domain confirmed | Not recorded | NOT TESTED | — | EV-01 |
| P02 | Active Microsoft 365 Business Premium subscription and available pilot seat | Not recorded | NOT TESTED | — | EV-01 |
| P03 | Intune MDM authority = Microsoft Intune; Intune functionality available | Not recorded | NOT TESTED | — | EV-01 |
| P04 | Entra ID P1 entitlement verified for pilot use | Not recorded | NOT TESTED | — | EV-01 |
| P05 | Administrative roles sufficient for intended later changes | Not recorded | NOT TESTED | — | Role name only, no private IDs |
| P06 | Entra device-join policy permits intended pilot; relevant limit recorded | Not recorded | NOT TESTED | — | EV-03 after pilot exists |
| P07 | MDM user scope and any competing MDM scope documented | Not recorded | NOT TESTED | — | EV-03 after pilot group exists |
| P08 | Windows enrollment restrictions and ownership classification reviewed | Not recorded | NOT TESTED | — | Note conflicts; no global changes |
| P09 | Hypervisor and host capacity verified (if VM host available) | Not recorded | NOT TESTED | — | EV-02 |
| P10 | Windows 11 Enterprise VM support/licensing approach recorded | Not recorded | NOT TESTED | — | EV-02 / evaluation expiry if used |
| P11 | VM Windows build, x64, vTPM/Secure Boot, disk, RAM verified | Not recorded | NOT TESTED | — | EV-02; after VM exists |
| P12 | VM sign-in/management connectivity, time sync and pre-join state checked | Not recorded | NOT TESTED | — | EV-02; after VM exists |

**Phase 1 exit decision:** `READY` only when the prerequisites needed to provision the pilot and VM are demonstrably satisfied. Otherwise write `BLOCKED — [specific reason]` or `PARTIALLY VERIFIED — [outstanding checks]`. No pilot user, group, MDM scope or device assignments are changed during Phase 1.

## Phase 2 — Pilot identities and static groups
1. Entra admin center > Entra ID > Users > New user > Create new user. Proposed display name: **Lab Endpoint 01**, UPN `lab.endpoint01@itengineeringlab.onmicrosoft.com`, usage location United Kingdom. No administrator role. Give a unique secure temporary password and protect sign-in with the tenant's required authentication mechanisms. Never put credentials in the repository.
2. Microsoft 365 admin center > Users > Active users > Lab Endpoint 01 > Licenses and apps > assign Microsoft 365 Business Premium. If no unallocated seat exists, stop; do not assume one is available or strip an essential service without planning.
3. Entra admin center > Entra ID > Groups > New group. Create **Security**, Membership type **Assigned**, name `LAB-INTUNE-02-USERS-PILOT`; add only the pilot account.
4. Create two further Assigned Security groups: `LAB-INTUNE-02-DEVICES-PILOT` and `LAB-INTUNE-02-DEVICES-UNINSTALL`; leave them empty initially.
5. Verify each group via Overview and Members. Do not place the old Lab 01 reporting identities into licence-dependent device assignments unnecessarily.
6. Return to Intune > Devices > Device onboarding > Enrollment > Windows > Automatic Enrollment. If existing MDM user scope = Some, add the pilot user group without removing existing intended groups. If scope = None, set Some and select only the pilot group after recording the change and its impact. If scope = All, keep All unless there is a separately justified and approved tenant-wide change. Save, then verify pilot inclusion; record before/after state in `change-record.md`. The Intune automatic-enrollment configuration procedure documents Global Administrator privileges; avoid changing scope without them.

## Phase 3 — Entra join and Intune enrolment
1. On the disposable VM, finish Windows setup and install updates. If it is initially configured with a local admin account, open Settings > Accounts > Access work or school > Connect > **Join this device to Microsoft Entra ID** (alternate action, not merely the basic work-account registration). Sign in as pilot and complete MFA.
2. Restart or sign out when prompted. Sign in as the pilot user, not solely as the original local account.
3. Run `dsregcmd /status`. **AzureAdJoined : YES** and **DomainJoined : NO** are expected for the cloud-only join. `AzureAdPrt` is user-context-specific; check from the pilot's interactive session and record the observed value, not a fabricated success.
4. Open Entra admin center > Devices > All devices; locate `LAB-W11-INTUNE-01` by name and confirm Microsoft Entra joined. Open Intune admin center > Devices > All devices; confirm it is managed by Intune, primary user and ownership display as observed, last check-in appears and it is not merely Entra registered.
5. Add its **Entra device object** (not the pilot user) to `LAB-INTUNE-02-DEVICES-PILOT`. Verify the object and membership. Leave uninstall group empty.
6. On VM: Settings > Accounts > Access work or school > select connected tenant > Info > Sync, or use Intune device overview > Sync. Allow asynchronous processing. Record actual sync/check-in timestamps; do not claim instantaneous propagation.

## Phase 4 — Endpoint configuration and compliance
1. Create Settings catalog policy: Intune > Devices > Manage devices > Configuration > Create > New policy > Windows 10 and later > Settings catalog. Name `LAB02-WIN-EDGE-CONFIG-PILOT`. Search Microsoft Edge policy **Configure the home page URL** (device setting, not the `(User)` variant); set Enabled and URL `https://learn.microsoft.com/`. Assign only `LAB-INTUNE-02-DEVICES-PILOT`. On VM, open `edge://policy`, reload policies and verify effective `HomepageLocation` and source. Document a conflict if another policy takes precedence.
2. Create Windows compliance policy `LAB02-WIN-COMPLIANCE-PILOT` from Devices > Manage devices > Compliance > Create policy > Windows 10 and later. Set **Device security: Firewall = Require; Antivirus = Require**; **Defender: Real-time protection = Require**. Avoid TPM-dependent/BitLocker compliance or configuration requirements for this VM because Microsoft documents limitations on TPM/hardware-dependent Intune VM configuration; validate only supported checks for the pilot. Optionally set Minimum OS version no higher than the ACTUAL guest build (format major.minor.build.revision; do not guess). Assign pilot device group. Default noncompliance action is Mark device noncompliant immediately; retain that action only. Do not add email notification actions unless desired and tested.
3. Check actual status in Intune device overview > Device compliance, settings and per-setting compliance. Record **Compliant** only if the portal reports it; investigate Not evaluated, Error, or Noncompliant separately.
4. Negative compliance test (OPTIONAL): temporarily set the pilot-only minimum OS version higher than the guest's actual version, wait for policy evaluation, record noncompliance, then restore and verify compliant again. Never disable antivirus/real-time protection to manufacture test failure. Do not enable enforcing Conditional Access during this test.

## Phase 5 — Controlled Win32 application local validation
1. Use the included `scripts/Install-Lab02App.ps1`, `Uninstall-Lab02App.ps1`, `Start-Lab02App.ps1`, detection scripts and `app-source/v1|v2/version.txt`.
2. On an isolated TEST copy of the VM (or the same VM followed by confirmed cleanup) stage the v1 folder containing four files: installer script, uninstaller script, launcher and v1 `version.txt`. From an ELEVATED Windows PowerShell prompt, run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Install-Lab02App.ps1`. This installer writes to 64-bit Program Files.
3. Inspect `C:\Program Files\ITEngineeringLab\Lab02App\version.txt`, launch `powershell.exe -NoProfile -File "C:\Program Files\ITEngineeringLab\Lab02App\Start-Lab02App.ps1"`, verify version 1.0.0. Execute detection script and verify output plus `$LASTEXITCODE` from an external PowerShell process (or the script's process exit code). Execute uninstall and verify target folder removed.
4. Repeat the local install/launch/uninstall check for v2. Confirm the final VM baseline has no residual Lab02App folder before Intune assignments begin.

## Phase 6 — Package the application
1. Download latest Microsoft `IntuneWinAppUtil.exe` ONLY from https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool ; verify release/tool version (`IntuneWinAppUtil.exe -v`) and review publisher/download source. Prerequisite: .NET Framework 4.7.2 or newer as required by tool.
2. Do not place `IntuneWinAppUtil.exe` inside the app source folder. In PowerShell 7 on the authoring PC execute (substitute real paths):

```powershell
.\scripts\Build-Lab02Packages.ps1 -ContentPrepTool 'C:\Tools\IntuneWinAppUtil.exe'
```

3. Expected local-only output: `%USERPROFILE%\Lab02-Intune-Build\packages\v1\Install-Lab02App.intunewin` and corresponding `v2` file. Verify both files exist and have nonzero size. **Do not upload either package to GitHub**; upload separately to Intune.

## Phase 7 — Create Win32 app v1 and deploy Required
1. Intune > Apps > All Apps > Create > Windows app (Win32). Upload the v1 `.intunewin`.
2. App information: Name `LAB02 Endpoint Demo v1`; Publisher `IT Engineering Lab`; Description `Controlled Win32 endpoint lifecycle lab, version 1.0.0`; Category `Productivity` or another suitable available category; featured = No.
3. Program: **Installer type Command line**; Install command `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File Install-Lab02App.ps1`; Uninstall command `powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File Uninstall-Lab02App.ps1`; Install behavior **System**; Device restart behavior **No specific action**; Allow available uninstall **No** for Required phase; install timeout **15 minutes**.
4. Requirements: Architecture **64-bit**; minimum operating system **Windows 11** if offered by portal; otherwise select the lowest supported Windows 10 build from the list and use the Windows 11 VM as the verified pilot. Leave unnecessary disk/RAM/CPU additional constraints blank.
5. Detection: **Use a custom detection script**; upload `scripts/Detect-Lab02App-v1.ps1`; Run script as 32-bit process on 64-bit clients = **No**; Enforce script signature check = **No** only within isolated pilot. Script returns output and exit code 0 only when `version.txt` equals `1.0.0`.
6. Dependencies: None. Supersedence: None. Scope tags: Default. Assignments: Required > `LAB-INTUNE-02-DEVICES-PILOT`. No Available or Uninstall assignment yet.
7. After save/upload, allow the IME to evaluate assignment. Confirm Windows service `IntuneManagementExtension`, folder `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`, portal **Device install status**, physical installation path, version file and launcher output.

## Phase 8 — Controlled detection failure, recovery and evidence
1. Once v1 is successful, capture evidence for installed version and portal result.
2. Deliberately replace v1's Intune detection script with the v2 detection script (expected `2.0.0`) while leaving v1 installed. Save the app changes and wait for device re-evaluation, using the app's check-in/IME logs for evidence. Intune can report **Not installed** and attempt reinstallation because v1 version does not satisfy the false detection rule. Timing is asynchronous; do not infer failure from a short delay.
3. Record actual detection status, relevant sanitised `AppActionProcessor.log`/`AppWorkload.log` excerpts and absence of version 2.0.0 on the endpoint.
4. Restore the correct v1 detection script, wait for re-evaluation, confirm successful detection and version 1.0.0. Record the incident in `troubleshooting.md`.

## Phase 9 — Publish v2 and test supersedence
1. Create the v2 Win32 app by repeating Phase 7 using v2 `.intunewin`, name `LAB02 Endpoint Demo v2`, version `2.0.0` and `Detect-Lab02App-v2.ps1`.
2. In the v2 app's **Supersedence** settings, select `LAB02 Endpoint Demo v1` as the superseded app; **Uninstall previous version = No**. The v2 installer overwrites the same application folder and is an in-place update.
3. Remove **Required** assignment from v1 (do not delete the app or its history). Assign v2 as **Required** to `LAB-INTUNE-02-DEVICES-PILOT`. Ensure targeting has had time to update, then validate v2 installation and exact-version detection. Avoid simultaneously requiring conflicting versions.
4. Record prior/current version, change window, update outcome, portal status and device evidence in `change-record.md` and `test-cases.md`.

## Phase 10 — Managed uninstall and optional reinstallation
1. After v2 is confirmed, remove `LAB-INTUNE-02-DEVICES-PILOT` from v2 **Required** targeting. Wait for assignment state to update; removing a Required assignment does **not** itself uninstall an app.
2. Add the VM device object to `LAB-INTUNE-02-DEVICES-UNINSTALL`. On v2, assign **Uninstall** to this group. Ensure no overlapping Required targeting applies to the device and that the intended uninstall app is v2.
3. Wait for successful uninstall. Verify folder is absent and the v2 detection script returns exit 1. Record Intune uninstall status and local evidence. A stale Discovered apps inventory row by itself does not prove failure: validate app detection, local file state and app install status independently.
4. Remove uninstall assignment and remove device from uninstall group before any optional reinstall. If practising **Available** installation, assign v2 as Available to `LAB-INTUNE-02-USERS-PILOT`, install Company Portal through supported means if missing, initiate installation as the pilot and verify detection. Do not keep an Uninstall intent concurrently targeted to the same device.

## Phase 11 — Real application: 7-Zip
1. Source the official 64-bit Windows MSI from https://www.7-zip.org/download.html (the site displayed version 26.03 released 3 September 2026 when the blueprint was prepared). Record the version and SHA256 hash (`Get-FileHash`). Store installer outside public repository.
2. Repackage the MSI as `.intunewin` using the Microsoft Content Prep Tool; select the actual MSI filename (not an invented MSI ProductCode). In Intune create `LAB02 7-Zip <actual-version> (Pilot)`; Program install `msiexec.exe /i "ACTUAL_FILENAME.msi" /qn /norestart` and uninstall with the MSI **ProductCode GUID actually extracted from that exact MSI** (`msiexec.exe /x {ACTUAL-GUID} /qn /norestart`), or an otherwise vendor-supported verified silent command.
3. Prefer MSI ProductCode-based detection, provided Intune extracts/returns the correct code; optionally require version match. Scope to the same device pilot group after application-lifecycle tests no longer compete for assignments. Prove install, application launch, detection and removal. 7-Zip's Discovered apps inventory may lag.

## Phase 12 — Conditional Access report-only (never Enforce by default)
1. Confirm a separately managed emergency-access path exists and test it according to your tenant's security plan. Do not create an unprotected administrator account merely for the lab.
2. Entra admin center > Entra ID > Conditional Access > Policies > New policy. Name `LAB02-CA-COMPLIANT-REPORT-ONLY`.
3. Users: Include only `LAB-INTUNE-02-USERS-PILOT`. Exclude emergency-access account(s). Target resources: select a relevant test Microsoft 365 resource the pilot can access, e.g. Office 365. Conditions: Device platforms Windows only if appropriate. Grant: Require device to be marked as compliant. Enable policy: **Report-only**.
4. Generate a legitimate sign-in from the pilot on the joined VM, then inspect Entra sign-in logs and report-only Conditional Access result. If testing sign-in from an unmanaged device/browser, interpret device identity and token claims carefully; do not claim guaranteed failure/success without the observed sign-in log.
5. Keep report-only at closure. No enforcement or tenant-wide targeting is part of Lab 02 core scope.

## Phase 13 — Evidence and publication
1. Update tests from `NOT TESTED` to `PASS`, `FAIL` or `BLOCKED`, with date, observed outcome and EV reference. Do not mark tests passed solely because a command is expected to work.
2. Upload sanitised screenshots only once captured; match file names in `evidence/README.md`. Keep unpublished photos / raw IME logs outside GitHub.
3. Update `lessons-learned.md` with findings actually observed (leave placeholder until then). Summarise versions, risks and decisions in `change-record.md`.
4. Review `.gitignore` additions in root README instructions. Check every relative Markdown link from public/in-private browser and all images. Update root `README.md` with a truthful Lab 02 status and link once the directory is added.
5. A production-like statement on CV must say **home-lab** or **non-production**. Do not present pilot VM management as employer production experience.

## Phase 14 — Cleanup and rollback
1. Unassign pilot apps and policies before deleting their objects. If retaining the VM for further labs, document active policies and leave it compliant.
2. Remove the device from uninstall/pilot groups and only delete controlled lab-specific objects if there are no dependencies. Do not delete shared Lab 01 users/groups.
3. If VM is to be retired, wipe/remove device from Intune and Entra with care; disconnect VM and release licences as appropriate. Deleting an Intune device record alone does not guarantee guest software is uninstalled.
4. If licence or VM cost applies, stop unused virtual resources and retain a clean snapshot according to licensing conditions.

## Official sources
The main sources are linked in README.md. In case of Microsoft Intune UI changes, search for the named feature/settings (the semantics matter more than one menu position).

