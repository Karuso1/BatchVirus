# BatchVirus — Analysis & Defensive Notes

> ⚠️ **WARNING — DO NOT RUN ANY SCRIPTS**
> This repository documents *analysis* and defensive guidance related to a destructive Windows batch sample. **No destructive files are included in this README.**
> If you are not an authorized security professional, do not attempt to run or reproduce the behavior described here. If you are really sure to run the scripts, please run it in an isolated VM!

## Purpose

This repository is intended for **security researchers, incident responders, and educators** who need a high-level, defensive description of a destructive batch script encountered in the wild. The goal is defensive analysis, detection, and recovery guidance — **not** to enable destructive testing on uncontrolled systems.

## Intended audience

* Incident Response teams
* Malware analysts (with legal authorization)
* Security engineers writing detection/playbooks
* Educators demonstrating malware risks using benign simulations

## High-level effects (non-actionable)

When executed, the destructive sample is observed to attempt the following behaviors. This is a **summary only** — there are no instructions here to recreate those steps.

* Attempt privilege escalation to obtain administrative rights.
* Display a warning / confirmation popup (social-engineering element).
* Check for development tooling (e.g., C++ toolchain) before proceeding.
* Remove or delete **user** and **system** environment variables (can break PATH, TEMP, other runtime behavior).
* Reset the current user’s password to a strong random password (locks legitimate user out).
* Lock the workstation (LockWorkStation), preventing local access.
* Dynamically generate, compile, and execute a native binary that **overwrites the Master Boot Record (MBR)** or otherwise corrupts boot metadata (can render the system unbootable).
* Delete registry keys related to environment variables and force an immediate reboot.
* Attempt self-deletion of the script after execution.

## Risks

* Loss of access to affected accounts and machines.
* Permanent data loss if backups are not available and the disk/boot metadata is damaged.
* Service outages and wide-scale impact if executed in a domain/production environment.
* Forensic evidence may be deleted or self-destructed quickly.

## High-level detection indicators

(Non-actionable list for defenders)

* Sudden changes to `HKCU\Environment` or `HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`.
* PATH, TEMP, TMP, or other env variables missing or empty.
* Unexpected password changes for local accounts.
* Lock workstation events followed by immediate reboot.
* Creation/compilation of binaries in temporary folders (`%TEMP%`, etc.).
* Disk I/O patterns targeting raw physical drives or writes at low offsets.
* Self-deleting scripts or missing expected files after short time windows.

## Quick recovery overview (high-level)

1. Isolate affected host(s) from the network.
2. Preserve forensic evidence: image disks, capture memory, and collect relevant logs.
3. Do **not** perform ad-hoc recovery on production hardware — consult disk/forensic specialists if boot metadata is suspected corrupted.
4. Restore from known-good backups and rotate credentials.
5. Hunt for indicators across the environment and escalate to legal/compliance as needed.

## Safe alternatives for educators

* Use **benign demo scripts** that simulate prompts and log actions without making system changes.
* Use offline virtual machines or air-gapped labs with snapshots for reversible tests.
* Present static analysis (strings, control flow) and sandbox results rather than executing destructive samples.
