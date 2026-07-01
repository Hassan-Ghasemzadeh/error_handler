## 2.0.0

### Breaking Changes
- **Decoupled DI Initialization:** Removed `GetItConfiguration.init()` from class constructors (such as `AppLogger`) to strictly adhere to the Single Responsibility Principle and prevent runtime circular dependencies.
- **Asynchronous Lifecycle Management:** Shifted dependency injection bootstrapping to the centralized `ResultexLoggerBase.init()` lifecycle method, requiring explicit `async/await` invocation at the application's root entry point (`main.dart`).

### Added
- **Modular DI Contracts:** Introduced structured `DIModule` registration patterns across core modules including `FlutterErrorHandlerModule` and `ResultExecutorModule`.
- **Dynamic Log Mapping:** Implemented a Type-safe, centralized Record-based mapping configuration (`_logMap`) within the logging infrastructure to dynamically stream system levels, colors, and visual tags.
- **Monorepo Dependency Integration:** Added native support for local `path` dependencies by marking internal sub-packages as non-publishable (`publish_to: 'none'`).

### Fixed
- **Static Analysis & Dartdoc Warnings:** Resolved multiple unresolved document references (such as `[AppLogger]` and `[modules]`) across `get_it_config.dart` and internal DI module registrations to pass `pana` evaluation with a perfect static analysis score.