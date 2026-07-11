# Changelog

All notable changes to the `error_handler` package will be documented in this file. This project
adheres to Semantic Versioning.
## 2.5.1

## Advanced Functional & Reactive Operations

This release introduces powerful monadic pipelines, UI-layer reactive bridges, and parallel validation mechanisms to make resultex the ultimate state and error management ecosystem for Dart and Flutter.

**1. Parallel Validation Accumulation**

- Added ResultAccumulatorX.accumulate to evaluate multiple lazy validation closures simultaneously.

- Introduced AccumulatedFailure to safely group and propagate multiple parallel validation errors (e.g., UI form validations) instead of short-circuiting at the first failure.

**2. Declarative State Management Bridge**

- Added the highly requested .toBlocState() extension for synchronous Result and asynchronous Future<Result> instances.

- Streamlined presentation-layer boilerplate by natively routing success payloads and failures directly to your state emission systems (like BLoC/Cubit emit methods) in a single declarative chain.

**3. Monadic Pipeline Recovery**

- Added .recover() (synchronous) and .recoverAsync() (asynchronous) operational boundaries.

- Enabled clean inline fallback routing (e.g., retrieving cached disk data if a remote network configuration call fails) without breaking method chaining.

**Quality of Life & Performance**
- Improved type safety and compiler optimization structures across all monadic operators.
- Fully tested async/sync recovery edge cases to guarantee zero unhandled runtime crashes.

## 2.5.0

### 🚀 New Features

- **ResultTextController (Flutter)**: Introduced an advanced reactive text field validator
  controller enabling direct mapping of native UI form inputs into declarative, type-safe `Result`
  outputs.
- **VoidResult & Functional Unit**: Introduced the semantic `Unit` object (built on top of a strict
  `final class` contract) and `VoidResult` type alias to elegantly model actions that finish
  successfully without returning data, eliminating `Result<void>` or `null` bypasses.
- **Conditional Interception (.ensure)**: Added the `.ensure()` filtering pipeline to conditionally
  validate wrapped data; failing the predicate dynamically reroutes the execution into a
  `FailureResult`.
- **Reactive Stream Safety**: Implemented `ResultStreamX` featuring `.toResultStream()` to map
  native asynchronous Dart Streams safely into predictable, crash-proof `Stream<Result<T>>`
  pipelines.
- **Passive Inspect Telemetry**: Added `.inspectSuccess()` and `.inspectFailure()` monadic
  side-effect pipelines to intercept data streams for logging/analytics without modifying the
  internal payload state.
- **Dart 3 Records Zipping**: Redesigned the type-safe zipping architecture to natively leverage
  Dart 3 Records (`(Result1, Result2).zip(...)`) supporting up to 5 heterogeneous elements with
  exhaustive pattern matching.
- **FutureResultX Extension**: Introduced the highly requested `.toResult()` extension on raw
  asynchronous primitive futures, enabling instant inline conversion from third-party APIs into
  clean `Result` wrappers.
- **ResultExecutor Optimization**: Enhanced `executeAsync` to handle asynchronous flat-mapping
  lifecycles seamlessly, preventing annoying nested `Result<Result<T>>` structures.

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