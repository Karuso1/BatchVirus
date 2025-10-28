# Contributing Guidelines

Thank you for your interest in contributing to the **BatchVirus (Defensive Analysis Project)**. This project is intentionally strict to maintain safety, clarity, and control over potentially harmful code. Please read the entire guide before submitting any contributions.

## Important Notice

* This repository is for **educational and defensive cybersecurity research** only.
* You can help to improve the virus but never **force** anyone to download the files.

## What You Can Contribute

* **Code Improvements:** Optimization, structure cleanup or anything similar to that for more safety.
* **Documentation:** Improving README, SECURITY, or any other markdown documentation.
* **Testing and Simulation Scripts:** Safe test frameworks that demonstrate behavior without causing system damage.
* **Defensive Tools:** Scripts or guides that help protect systems from similar malicious behaviors.

## Contribution Rules

1. Always create a new branch for your contribution (`feature/your-feature-name`).
2. Do **not** push directly to the `main` branch.
3. Each pull request must:

   * Clearly explain the purpose of the change.
   * Pass all existing repository checks.
4. Any code that deletes files, modifies passwords, or interacts with system drives must be **sandboxed, simulated, or commented out**.
5. Keep your commits clean — use descriptive messages like `docs: updated SECURITY.md` or `fix: improved warning popup logic`.

## Review and Approval

All pull requests are reviewed by maintainers for safety and relevance. Unsafe or unverified submissions will be closed without merge.

## Getting Started

1. Fork the repository.
2. Clone your fork locally:

   ```bash
   git clone https://github.com/Karuso1/BatchVirus.git
   ```
3. Make your edits, then push your branch:

   ```bash
   git checkout -b feature/my-update
   git commit -m "docs: improved contributing guide"
   git push origin feature/my-update
   ```
4. Open a pull request with a clear summary of what you changed.

*Last updated: October 28, 2025*
