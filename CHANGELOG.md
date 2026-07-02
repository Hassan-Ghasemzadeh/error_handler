# Changelog

All notable changes to the `error_handler` package will be documented in this file. This project
adheres to Semantic Versioning.

## 2.1.0

- **Feat**: Introduced `ResultExtensions` on the `Result<T>` sealed hierarchy.
- **Feat**: Added `.recover()` mechanism to gracefully intercept operational failures and route them
  through alternative backup execution pipelines.
- **Feat**: Added `.getOrElseAsync()` supporting polymorphic (`FutureOr<T>`) flows to safely unpack
  success states or execute asynchronous fallback strategies (e.g., local cache recovery).
- **Docs**: Fully documented extension methods with clean code architecture examples in README.

## 2.0.1

- Internal restructuring and code migrations.
- Integrated `resultex_logger` package as a core module dependency.
- Fixed dartdoc references and static analysis warnings.

## 2.0.0

### Breaking Changes

- Migrated core modules and decoupled dependency injection from localized constructors.
- Integrated `resultex_logger` as a core dependency.

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