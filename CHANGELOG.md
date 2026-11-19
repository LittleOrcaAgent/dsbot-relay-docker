# Changelog

All notable changes to this project are documented here.

## [Unreleased]

### Added

- Container image for the DS Bot phone-link relay server, built from a pinned upstream commit.
- Multi-arch build for `linux/amd64` and `linux/arm64`.
- Health check on `/healthz` and a non-root runtime user.
- Publish to GitHub Container Registry on push, tag, schedule and manual dispatch.
