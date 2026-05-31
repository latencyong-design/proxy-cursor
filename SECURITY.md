# Security Policy

## Reporting Security Issues

Please do not publish working credentials, private proxy URLs, tokens, or local
machine identifiers in public issues.

Open a public issue only for general hardening questions. If a report contains
sensitive details, describe the impact at a high level and say that sensitive
details are available privately.

## Local Safety Model

proxy-cursor is a local helper. It registers a Windows scheduled task and starts
ProxyBridge with elevated privileges because ProxyBridge uses packet
interception on Windows.

The project does not require cloud credentials. Do not add proxy usernames,
passwords, tokens, or private network details to tracked files.
