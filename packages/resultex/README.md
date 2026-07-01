# Resultex 🎯

A robust, enterprise-grade core ecosystem for Flutter and Dart applications. `resultex` serves as
the foundational monorepo layer, providing essential utilities, dependency injection management, and
highly optimized sub-packages like modern logging systems to streamline development.

---

## 🏗️ Core Architecture & Package Structure

The ecosystem is designed around the **Single Responsibility Principle** and strict modularization.
Instead of monolithic codebases, features are isolated into lightweight, WASM-compatible modules.

```text
resultex/
├── lib/
│   ├── core/
│   │   ├── di/               # Global Dependency Injection (GetIt)
│   │   └── utils/            # Shared business logic and utilities
│   └── resultex.dart         # Main package entry point
└── packages/
    └── resultex_logger/      # High-performance native logger sub-package
```

**✨ Features & Modules**
⚡ Centralized Dependency Injection: Built-in boilerplate management via GetIt with isolated, highly
testable DIModule contracts.

🚀 Production-Ready Utilities: Optimized core classes tailored for cross-platform, Web, and WASM
performance.

🔌 Ecosystem Extension (resultex_logger): Included native terminal log management supporting ANSI
colorization and 8 custom LogLevels (good, fine, verbose, debug, info, warning, error, critical).

**📦 Installation**
To integrate the core ecosystem into your Flutter application, add resultex to your pubspec.yaml via
a local path:

```YAML
dependencies:
resultex:
path: '../error_handler/packages/resultex'
```

**🛠️ Getting Started**

1. Initialize the Ecosystem Lifecycle
   The core architecture decouples service locators from app components. You must initialize the
   dependency injection layer inside your main.dart before triggering runApp:

```Dart
import 'package:flutter/material.dart';
import 'package:resultex/resultex.dart';

void main() async {
// Ensure Flutter engine bindings are ready for async operations
  WidgetsFlutterBinding.ensureInitialized();

// Initialize all registered core modules and services
  final loggerBase = ResultexLoggerBase();
  await loggerBase.init();

  runApp(const MyApp());
}
``` 