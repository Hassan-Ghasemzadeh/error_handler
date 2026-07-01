# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-07-01

### Added

- **[Feature]** Added ANSI colorized output support for terminal logs (`✅ Color logs`).
- **[Feature]** Implemented full `LogLevels` support covering: `info`, `verbose`, `warning`,
  `debug`, `error`, `critical`, `fine`, and `good`.
- Created native `AppLogger` implementation using Dart `developer.log` for full cross-platform and
  WASM compatibility.
- Exported the core logger functionality via the main library entry point.

### Changed

- Decoupled `GetItConfiguration.init()` from the `AppLogger` constructor to prevent circular
  dependencies.
- Moved dependency injection initialization to the base lifecycle class (`ResultexLoggerBase`).
- Marked the package as non-publishable (`publish_to: 'none'`) to support local path dependencies.

### In Progress (🚧 Under Development)

- 🚧 **Logs grouping:** Designing a structured API to visually group and nest related runtime
  operations.
- 🚧 **Collapsible feature for huge logs:** Developing a smart multi-line block layout to handle
  massive payloads and stack traces cleanly.