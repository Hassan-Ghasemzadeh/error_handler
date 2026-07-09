# Resultex Logger 🚀

A lightweight, powerful, and highly compatible logging system for Dart and Flutter. Built directly
on top of native `developer.log`, it ensures seamless **cross-platform, Web, and WASM compatibility
** without breaking a sweat or relying on heavy external dependencies.

---

## ✨ Features

* **✅ Color Logs:** High-visibility ANSI escape sequences to colorize your terminal.
* **✅ Comprehensive LogLevels:** Full support for `info`, `verbose`, `warning`, `debug`, `error`,
  `critical`, `fine`, and `good`.
* **🚧 Logs Grouping (In Progress):** Visual nesting for hierarchical runtime operations.
* **🚧 Collapsible Huge Logs (In Progress):** Smart multi-line layout to handle massive payloads and
  stack traces cleanly.

---

## 📸 Preview
  <img src="https://github.com/Hassan-Ghasemzadeh/error_handler/blob/main/docs/assets/screenshot-dash.png" alt="Resultex Ecosystem Banner" width="100%">
  <img src="https://github.com/Hassan-Ghasemzadeh/error_handler/blob/main/docs/assets/screenshot-hash.png" alt="Resultex Ecosystem Banner" width="100%">

---

## 📦 Installation

Since this package is tailored for internal/monorepo architectural designs, add it to your
`pubspec.yaml` using a local path:

```yaml
dependencies:
  resultex_logger: ^1.1.1
```

**🛠️ Getting Started**

1. **Initialize Dependencies**
   Before using the logger, initialize its dependency injection layer. It is highly recommended to
   do this in your main.dart before runApp:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger base configuration
  // Initialize the concrete instance of AppLogger.
  final logger = ResultexLogger(
    settings: ResultexLoggerSettings(
      maxLineWidth: 40, // Slimmer boxes
      lineSymbol: '*', // Use hashes instead of solid lines
    ),
  );

  await loggerBase.init();

  runApp(const MyApp());
}
```

2. **Basic Usage & Log Mapping**
   Import the main entry point and start logging across your application. The logger automatically
   maps colors, tags, and Syslog levels internally:

```dart
import 'package:resultex_logger/logger.dart';

void main() {
  // Initialize the logger base configuration
  // Initialize the concrete instance of AppLogger.
  final logger = ResultexLogger(
    settings: ResultexLoggerSettings(
      maxLineWidth: 40, // Slimmer boxes
      lineSymbol: '*', // Use hashes instead of solid lines
    ),
  );

  await loggerBase.init();
  // Standard Logs
  logger.info('Application started successfully.');
  logger.good('Database connection established.');
  logger.fine('Resource allocated smoothly.');
  logger.verbose('User scrolling index: 24');

  // Warnings & Debugs
  logger.warning('API response time is slower than expected.');
  logger.debug('Fetching user data dynamic payload...');

  // Errors & Critical Crashes
  try {
    throw Exception('Connection timed out');
  } catch (e, stack) {
    logger.error('Failed to load dashboard data', error: e, stackTrace: stack);
    logger.critical(
        'Fatal: System is unable to recover from this state!', error: e, stackTrace: stack);
  }
}
```

****🏗️ Architecture Note****
This package adheres strictly to the Single Responsibility Principle. The AppLogger is decoupled
from initialization lifecycles, preventing circular dependencies and making it extremely easy to
mock during Unit Testing.
