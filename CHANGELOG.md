# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-01-03
### Added
- **Security Policy**: Added `SECURITY.md` to warn users about the vulnerable nature of the app.
- **Contributing Guidelines**: Added `CONTRIBUTING.md`.
- **Project Badges**: Added tech stack, version, and star badges to README.
- **Improved Documentation**: Migrated Solutions to Project Wiki and updated all links.
- **Wiki**: Full migration of documentation to the repository Wiki.

### Fixed
- **Docker Stability**: Reverted `body-parser` removal to ensure stability during login.
- **Documentation Links**: Corrected all cloning instructions and external links to point to the new repository `TiiZss/dvws-node`.

## [1.0.0] - 2026-01-03

### Added
- **New Vulnerabilities Implemented**:
  - Cross-Site Request Forgery (CSRF) via `POST /v2/users/password`.
  - CRLF Injection via `GET /v2/preference`.
  - Server-Side Request Forgery (SSRF) via `POST /v2/notes/import`.
  - GraphQL Denial of Service (Circular Query) in `friends` field.
  - GraphQL NoSQL Injection via `unsafeSearch` query.
  - SOAP Injection (XML Injection) in `dvwsuserservice`.
- **Documentation**:
  - Added `Solutions-Cheatsheet.md` covering all new vulnerabilities.
  - Updated README with status of implemented vulnerabilities.
  - Docker Compose support verification.

### Changed
- Forked from [snoopysecurity/dvws-node](https://github.com/snoopysecurity/dvws-node).
- Updated `soapserver` logic to allow manual XML construction for injection.
- Updated `users` controller to include vulnerable endpoints.
- Updated `notebook` controller to include vulnerable SSRF endpoint.
