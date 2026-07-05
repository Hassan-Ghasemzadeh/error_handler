# Changelog

All notable changes to the `error_handler` package will be documented in this file. This project
adheres to Semantic Versioning.

## 2.4.0

### 🚀 New Features

- **Dart 3 Records Zipping**: Redesigned the type-safe zipping architecture to natively leverage
  Dart 3 Records (`(Result1, Result2).zip(...)`) supporting up to 5 heterogeneous elements with
  exhaustive pattern matching.
- **FutureResultX Extension**: Introduced the highly requested `.toResult()` extension on raw
  asynchronous primitive futures, enabling instant inline conversion from third-party APIs into
  clean `Result` wrappers.
- **ResultTransformationX Extension**: Added monadic transformation and side-effect mapping
  extensions to easily manipulate encapsulated data down the functional stream.
- **ResultExecutor Optimization**: Enhanced `executeAsync` to handle asynchronous flat-mapping
  lifecycles seamlessly, preventing annoying nested `Result<Result<T>>` structures.

## 2.3.1

- Updated README.md and scripts

## 2.3.0

### 🚀 Added

- **Advanced Async Functional Chaining:** Introduced `asyncMap` and `asyncFlatMap` extensions on
  `Future<Result<S>>` to seamlessly chain asynchronous operations without nested `await` blocks.
- **Reactive UI State Management (`ResultNotifier`):** Added a lightweight, lifecycle-aware state
  manager extending Flutter's `ValueNotifier` to track operational statuses natively.
- **Declarative Layout Builder (`ResultBuilder`):** Added a tailored UI builder widget that
  exhaustively pattern-matches `ResultNotifier` states into `onLoading`, `onSuccess`, and
  `onFailure` widget trees.
- **Resilient Recovery Pipelines:** Added advanced `mapFailure` and `asyncMapFailure` extensions to
  mutate and adapt failure contracts down the stream.
- **Transient Network/Operation Retries:** Added a flexible `withRetry` mechanism on `Future`
  closures supporting custom attempt limits and backoff strategies.

### ⚡ Changed

- Fully optimized all internal UI routing mechanics to exploit Dart 3+ exhaustive switch expressions
  for rigid compile-time safety.

## [2.2.0] - 2026-07-02

### Added

- **Flutter UI Extension (`.when()`)**: Added a highly readable, Dart 3 pattern-matching-backed
  extension method on `Result` to cleanly map success and failure states directly into Flutter
  widgets without conditions.
- **Parallel Execution Utility (`ResultUtils.combineAll`)**: Introduced a concurrent utility method
  to fire multiple `Future<Result>` operations simultaneously.
- **Composite Error Framework (`MultiFailure`)**: Added a new failure variant that aggregates all
  intercepted errors from parallel dispatches instead of short-circuiting on the first failure.

### Changed

- **License Alignment**: Fully migrated and aligned the project license framework to **MIT** across
  all documentation and registry metadata for seamless commercial and open-source adoption.
- **Documentation Updates**: Rewrote the `README.md` to include interactive layout design recipes,
  concurrent API usage guides, and modern Dart 3 structural pattern examples.

### Fixed

- **Pattern Matching Type Inference**: Resolved internal compiler mismatches during تو در تو (
  nested) destructuring of the `Success<T>` wrapper inside concrete `SuccessResult` scopes.

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