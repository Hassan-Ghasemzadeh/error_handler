# Changelog

All notable changes to the `error_handler` package will be documented in this file. This project
adheres to Semantic Versioning.
## [3.0.1] - 2026-07-20
*   **Documentation:** Updated README.md with package table and improved installation guides.

## [3.0.0] - 2026-07-18

### Breaking Changes

- Refactored `ResultExecutor` and `FlutterErrorHandler` to use Constructor Injection. The implicit
  dependency on `GetIt` has been completely removed.

### Refactoring & Improvements

- **State Management:** Hardened `ResultNotifier` with execution tokens to prevent race conditions
  and added dispose-safety checks.
- **UI Builders:** Optimized `ResultBuilder` and `ResultSwitch` for better performance and stricter
  separation of concerns. Exchanged manual checks for Dart 3 exhaustive pattern matching.
- **Form Controls:** Improved `ResultTextController` performance by caching validation results.
- **Testing:** Replaced custom `Matcher` classes with Dart's native `isA<T>().having()` for greater
  test stability and prevention of unhandled exceptions.

## [2.7.0] - 2026-07-16

### Added

- **Public API Exposure**: Exported core domain models (`Failure`, `Success`) directly from the main
  library entry point (`lib/resultex.dart`). This enables clean integration with external
  sub-packages (like `resultex_network`) and third-party extensions without referencing internal
  `src/` files.
- **New `ResultSwitch` Widget**: Added a declarative, elegant UI component that allows developers to
  pattern-match and switch between different `Result` states directly in the widget tree, keeping
  presentation code clean and readable.

### Changed

- **Refactored `ResultBuilder`**: Thoroughly polished and optimized the state-rebuilding pipeline in
  `ResultBuilder` to offer smoother UI updates, stronger type safety, and better integration with
  asynchronous states.

## [2.6.1] - 2026-07-13

### 🚀 Added

* **Custom Test Matchers**: Introduced `isSuccess`, `isFailure`, and `isFailureType` inside
  `lib/resultex_test.dart` for clean, expressive, and robust unit testing of `Result` types.

### Fixed

* Resolved minor internal bugs to improve core package stability and pipeline performance.
* Adjusted `flutter_test` dependency allocation to correctly support library-level custom matchers.

## [2.6.0] - 2026-07-11

### Enterprise Concurrency & Lifecycle

* **Added `CancellableResult` and `CancellationFailure`**: Prevent memory leaks and `setState` after
  dispose errors in Flutter by instantly aborting pending asynchronous operations when a view is
  disposed.
* **Added `Result.race`**: Race multiple asynchronous `Result` operations. Resolves with the first
  `SuccessResult` or an `AccumulatedFailure` if all operations fail, perfect for redundant network
  requests.
* **Added `Result.memoizeAsync`**: Optimize performance by caching functional evaluations. Prevents
  duplicate network/computation calls for concurrent requests in the UI.

### Advanced Error Management

* **Added `ResultexObserver`**: A globally accessible, thread-safe observer for centralized error
  logging and crash reporting (e.g., Firebase Crashlytics, Sentry) without polluting business logic.
* **Added `Result.accumulate`**: Parallel validation flow support. Validate a collection of results
  simultaneously and catch all errors at once via the new `AccumulatedFailure` class (ideal for
  complex form validations).
* **Added Monadic Recovery (`.recover` & `.recoverAsync`)**: Gracefully patch pipeline failures by
  routing operational infractions through a fallback provider (e.g., falling back to a local
  database when a network request fails).

### State Management Integration

* **Added `toBlocState` Extension**: Seamlessly bridge asynchronous core architecture outcomes with
  Flutter state emitters (`BLoC`/`Cubit`). Automatically unpacks monad containers and dispatches
  execution blocks straight to state emission streams.

### Refactoring & Internal Improvements

* Enhanced asynchronous generic type matching and pipeline safety across all extension methods.
* Maintained 100% backward compatibility with `v2.5.0` core APIs.

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