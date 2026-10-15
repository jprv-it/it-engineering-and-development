# Lab 02 — Pilot change record

**Current state:** Planned, no changes executed by this starter kit.

| Change ID | Phase | Proposed change | Scope | Risk / rollback | Date started | Date completed | Status |
|---|---|---|---|---|---|---|---|
| CH-00 | Documentation | Establish Lab 02 repository structure and prerequisite register | Public portfolio documentation | Low; revert GitHub commit if necessary | YYYY-MM-DD | YYYY-MM-DD | IN PROGRESS |
| CH-01 | Identity | Create licensed pilot and static groups | Lab-only | Remove group assignment; deactivate lab user after use | — | — | PLANNED |
| CH-02 | Enrollment | Pilot Entra join / automatic Intune MDM | Single VM | Restore pre-join VM snapshot if safe; retire cloud device record appropriately | — | — | PLANNED |
| CH-03 | Policy | Apply Edge catalog + compliance policies | Pilot device | Unassign lab policy | — | — | PLANNED |
| CH-04 | App v1 | Deploy version 1.0.0 as Required | Pilot device | Remove targeting, assign uninstall | — | — | PLANNED |
| CH-05 | Detection | Introduce and fix wrong detection script | v1 app only | Restore correct v1 detection | — | — | PLANNED |
| CH-06 | App v2 | Supersede v1 with 2.0.0 | Pilot device | Pause v2 targeting; consider reinstall of validated v1 | — | — | PLANNED |
| CH-07 | App uninstall | Remove Required, apply Uninstall | Pilot device | Remove uninstall intent; reinstall version 2 | — | — | PLANNED |
| CH-08 | CA | Report-only compliance rule | Pilot user only | Disable lab policy | — | — | PLANNED |
| CH-09 | Close | Sanitise evidence, audit, update README | Public repo | Correct or remove any overclaims / accidental data | — | — | PLANNED |

Record the **actual** before/after state.
NOTE: Avoid copying GUIDs, personal information, and production diagnostic logs to GitHub.
