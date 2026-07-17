# Changelog

All notable changes to this project will be documented in this file.

## 1.1.4

### Fixed

- Fixed potential initialization conflicts when multiple loggers were instantiated.
- Improved ANSI color handling for cleaner terminal output.

## 1.1.3

### Added

- **Extended Log Levels**: Introduced `LogLevel.critical`, `LogLevel.good`, `LogLevel.fine`, and
  `LogLevel.verbose` to the telemetry core for precise runtime segmentation and semantic tracking.
- **Enhanced `LoggerService` Interface**: Updated the core logging contract to explicitly expose
  dedicated API endpoints for the new severity weights.
- **Platform Style Expansions**: Added system-level `magenta` (for catastrophic infrastructure
  crashes) and low-contrast balanced `gray` ANSI pens to `LoggerStyles`.

### Changed

- **Pipeline Evaluation Overhaul**: Re-architected the `_shouldLog` operational layer inside
  `ResultexLogger` to evaluate granular filtering thresholds using numerical Syslog weights (
  `value`) instead of position indexes.

### Fixed

- **AnsiPen Reference Linking**: Restructured inline documentation to clean up references and
  prevent complex element loop timeouts during automatic `dartdoc` execution.

## [1.1.2] - 2026-07-09

### Added

- Added high-visibility terminal output screenshots to the README.

### Changed

- Updated the example project implementation for better clarity and alignment with best practices.
- Improved README documentation and configuration guides.

# [1.1.1] - 2026-07-02

- Updated GitHub repository url
- Updated environment sdk and flutter version

## [1.1.0] - 2026-07-01

### Added

- Introduced strong-typed severity control via the new `LogLevel` enum (supporting numerical Syslog
  weights).
- Added `LogDetails` data transfer object (DTO) to encapsulate metadata, payloads, errors, and stack
  traces.
- Added environment-aware log level filtering with `minLogLevel` configuration to easily suppress
  diagnostic logs in production.
- **Unified Group Lifecycle Tracing:** Enhanced the `group()` utility with an explicit, secure
  `🔻 END GROUP` lifecycle marker to visually isolate scoped processes in console streams.

### Changed

- **Advanced Terminal UI Box-Enclosure:** Upgraded `error`, `critical`, and `warning` log levels to
  automatically render inside fully enclosed, symmetric visual boxes for immediate error boundaries
  and scanning.
- **Symmetric Multi-line & Content Coloring:** Rewrote the layout engine to calculate the maximum
  line length dynamically, ensuring internal text contents and vertical borders are uniformly
  colorized without breaking console layout.
- **Refactored for SOLID & Clean Architecture:** Separated presentation layers by decoupling ANSI
  styling into a dedicated `LoggerStyles` class and abstracting layout behaviors into a solid
  `LoggerFormatter` contract strategy.
- **Enhanced Platform Compatibility (Linux/Desktop Color Fix):** Routes logs to standard native
  `print` on desktop platforms to bypass a known Flutter issue where `developer.log` strips ANSI
  escape codes in Linux/Mac/Windows terminal streams, while seamlessly retaining `developer.log` for
  Web/WASM targets.
- **Seamless Structural Box Boundaries:** Reworked the horizontal framing system to generate
  continuous, flush headers and footers using a single customizable `lineSymbol`, completely
  removing isolated distinct corner tokens.

### Fixed

- Fixed code duplication (DRY principle violation) by unifying error and stack trace extraction
  flows under a centralized nested pipeline.
- **Monospace Grid Alignment & Escaped Padding:** Fixed terminal layout misalignment where ANSI
  colors distorted length calculations by shifting to a 100% plain-text matrix calculation layer
  prior to code colorization.
- **Asymmetric Wall Overflow:** Eliminated the multi-line right-wall drift caused by bulk multiline
  outputs by converting the formatter stream into an isolated `List<String>` layer, ensuring uniform
  prefix tag injection (`[INFO]`, `[ERROR]`) across every independent stdout line.
- **Vertical Font Margins:** Resolved the broken vertical alignment caused by the keyboard pipe
  character (`|`) by unifying side walls to share the exact same structural `lineSymbol` context as
  horizontal borders, avoiding font-rendering gaps.

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