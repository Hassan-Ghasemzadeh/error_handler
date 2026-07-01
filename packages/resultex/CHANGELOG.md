## v2.0.1
* updated README.md and CHANGELOG.md

## v2.0.0

### Breaking Changes

- **Decoupled DI Initialization:** Removed `GetItConfiguration.init()` from class constructors (such
  as `AppLogger`) to strictly adhere to the Single Responsibility Principle and prevent runtime
  circular dependencies.
- **Asynchronous Lifecycle Management:** Shifted dependency injection bootstrapping to the
  centralized `ResultexLoggerBase.init()` lifecycle method, requiring explicit `async/await`
  invocation at the application's root entry point (`main.dart`).

### Added

- **Modular DI Contracts:** Introduced structured `DIModule` registration patterns across core
  modules including `FlutterErrorHandlerModule` and `ResultExecutorModule`.
- **Dynamic Log Mapping:** Implemented a Type-safe, centralized Record-based mapping configuration (
  `_logMap`) within the logging infrastructure to dynamically stream system levels, colors, and
  visual tags.
- **Monorepo Dependency Integration:** Added native support for local `path` dependencies by marking
  internal sub-packages as non-publishable (`publish_to: 'none'`).

### Fixed

- **Static Analysis & Dartdoc Warnings:** Resolved multiple unresolved document references (such as
  `[AppLogger]` and `[modules]`) across `get_it_config.dart` and internal DI module registrations to
  pass `pana` evaluation with a perfect static analysis score.

# Changelog

All notable changes to the `error_handler` package will be documented in this file. This project
adheres to Semantic Versioning.

## [1.0.4] - 2026-06-30

- Hard clean and complete removal of unused dependencies for full WASM/Web compatibility.

## [1.0.3] - 2026-06-30

- Removed external logger dependency to achieve full Web and WASM compatibility.

## [1.0.2] - 2026-06-30

- Switched to MIT license for better pub.dev recognition.
- Upgraded dependencies including get_it to support version 9.2.1.

## [1.0.1] - 2026-06-30

- Updated Flutter environment constraints.
- Added documentation example.
- Fixed pub points analysis.

## [1.0.0] - 2026-06-29

### Added

- **Core Result Pattern**: Introduced `Result<S, F>`, `SuccessResult`, and `FailureResult` using
  Dart 3 sealed classes for compile-time safe pattern matching.
- **Functional Operators**: Added fluent API chaining methods including `map`, `flatMap`, `fold`,
  `getOrElse`, and `fromNullable`.
- **Safe Execution Guards**: Implemented `Result.guard()` and `Result.guardAsync()` to seamlessly
  intercept and encapsulate imperative exceptions.
- **Batch Operations**: Added `Result.combine()` and `Result.partition()` for combining or
  separating multiple asynchronous operations.
- **ResultExecutor Layer**: Created a dedicated execution engine with built-in context tracking and
  automated error logging.
- **Global Error Hooks**: Added `FlutterErrorHandler` to handle framework-level crashes and
  integrate with external crash reporters (e.g., Firebase).

### Security & License

- Distributed under the **GPL v3.0 License** for open-source copyleft protection.
- Secure key and context tracking adhering to strict memory and performance safety.

---

## [0.0.1] - 2026-06-25

- Initial project structure setup and architecture design brainstorming.