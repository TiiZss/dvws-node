# Security Policy

## ⚠️ WARNING: VULNERABLE APPLICATION

**DO NOT DEPLOY THIS APPLICATION IN A PRODUCTION ENVIRONMENT.**

This application (`dvws-node`) is intentionally vulnerable. It contains multiple security flaws including SQL Injection, XSS, CSRF, and more. It is designed **solely for educational purposes** to learn about web application security and penetration testing.

### Reporting Vulnerabilities

Since this is a widely known vulnerable application, please **do not** report the vulnerabilities listed in the README or Wiki as security issues. 

However, if you find a vulnerability in the *infrastructure* (e.g., the Docker configuration, build process, or scripts) that poses a risk to the host machine beyond the scope of the intended application, you may open an issue or pull request.

## Proper Usage

- Run this application only in an isolated environment (e.g., a local Docker container, virtual machine, or dedicated lab network).
- Do not expose this application to the internet.
- Use strong passwords for the host machine and other services.
