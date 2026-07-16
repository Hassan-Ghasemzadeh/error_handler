# Resultex Network 🌐

An elegant, resilient, and production-ready network companion for the **Resultex** functional
error-handling ecosystem.

This package seamlessly bridges the gap between raw HTTP communications (using **Dio**) and
structured domain-driven failures. It automatically intercepts API exceptions, maps HTTP status
codes, and wraps responses into functional `Result` monads.

---

## Features ✨

* **Umbrella Exports:** No double-importing. Simply import `resultex_network` and get access to
  both network helpers and the entire core `resultex` library.
* **Robust Dio Interceptor:** An out-of-the-box `ResultexDioInterceptor` that captures network
  timeouts, socket issues, and server breakdowns.
* ️ **Rich Failure Mapping:** Automatically translates raw responses and HTTP status codes into
  domain failures (e.g., `ValidationFailure`, `ServerFailure`, `UnauthorizedFailure`,
  `OfflineFailure`).
* **Future Guard Extension:** Execute asynchronous network operations safely with `.guard()` and
  transform them directly into a functional `Result<T, Failure>`.
* ️ **Clean Architecture Aligned:** Keeps your Data Sources and Repositories decoupled, highly
  testable, and pure.

---

## Installation

Add `resultex_network` to your `pubspec.yaml` dependencies. (Note: You do **not** need to add
`resultex` separately, as this package re-exports it).

```yaml
dependencies:
  resultex_network: ^1.0.0
```

## **Getting Started 🚀**

1. **Setup the Dio Client & InterceptorRegister**  
   the ResultexDioInterceptor in your Dio instance. This
   ensures that any unexpected raw API throw-behaves are gracefully mapped to structured errors.

```Dart
import 'package:dio/dio.dart';
import 'package:resultex_network/resultex_network.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: '[https://api.example.com](https://api.example.com)',
    connectTimeout: const Duration(seconds: 5),
  ),
)
  ..interceptors.add(ResultexDioInterceptor());
```

2. **Guarding API Requests in Data Sources**    
   With the .guard() extension on Future<Response<T>>, your data source becomes clean, robust, and
   free of massive try-catch blocks.

```dart
import 'package:dio/dio.dart';
import 'package:resultex_network/resultex_network.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: '[https://api.example.com](https://api.example.com)',
    connectTimeout: const Duration(seconds: 5),
  ),
)
  ..interceptors.add(ResultexDioInterceptor());
```

3. **Handling Results in the Presentation**  
   LayerBecause of the Umbrella Export, you have access to all
   Result patterns (like .fold()) right out of the box.

```Dart
import 'package:flutter/material.dart';
import 'package:resultex_network/resultex_network.dart';

void fetchAndRender(UserRemoteDataSource dataSource) async {
  final result = await dataSource.getUserProfile('123');

  result.fold(
    onSuccess: (data) {
      print('User profile loaded: $data');
    },
    onFailure: (failure) {
// Map domain failures directly to user-friendly messages
      final errorMessage = failure.map(
        server: (_) => 'Our servers are currently sleeping. Try again later.',
        unauthorized: (_) => 'Your session has expired. Please log in again.',
        validation: (f) => 'Invalid fields: ${f.errors}',
        offline: (_) => 'No internet connection detected.',
        generic: (f) => f.message,
      );

      print('Error: $errorMessage');
    },
  );
}
```

### **License 📄**

This project is licensed under the MIT License - see the LICENSE
file for details.
