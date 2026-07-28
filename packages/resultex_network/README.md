# Resultex Network 🌐

An elegant, resilient, and production-ready network companion for the **Resultex** functional
error-handling ecosystem.

This package seamlessly bridges the gap between raw HTTP communications (using **Dio**) and
structured domain-driven failures. It automatically intercepts API exceptions, maps HTTP status
codes, and wraps responses into functional `Result` monads.

---

## Features

* ✅ **Umbrella Exports:** No double-importing. Simply import `resultex_network` and get access to
  both network helpers and the entire core `resultex` library.
* ✅ **Robust Dio Interceptor:** An out-of-the-box `ResultexDioInterceptor` that captures network
  timeouts, socket issues, and server breakdowns.
* ️✅ **Rich Failure Mapping:** Automatically translates raw responses and HTTP status codes into
  domain failures (e.g., `ValidationFailure`, `ServerFailure`, `UnauthorizedFailure`,
  `OfflineFailure`).
* ✅ **Future Guard Extension:** Execute asynchronous network operations safely with `.guard()` and
  transform them directly into a functional `Result<T, Failure>`.
* ️✅ **Clean Architecture Aligned:** Keeps your Data Sources and Repositories decoupled, highly
  testable, and pure.

---

## Get Started

## Installation

### Prerequisites

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

```

Add `resultex_network` to your `pubspec.yaml` dependencies.

```yaml
dependencies:
  resultex_network: ^1.2.0
``` 

### Easy to use

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
| Interceptors | Description |
|:--------------------------------------------------------------| :-- | :--- |
| ResultexConnectivityInterceptor     | A Dio Interceptor that prevents network requests from being sent if there is no active internet connection. |
| ResultexDioInterceptor | A custom Dio [Interceptor] that catches low-level network errors, |
| ResultexLoggerInterceptor | An interceptor that automatically logs network activity using [ResultexLogger]. |
| ResultexRetryInterceptor | A Dio interceptor that automatically retries failed network requests. |

## Caching & Offline Strategies

If your application requires robust offline support and smart data synchronization, you can leverage
the built-in caching policies to control data flow seamlessly.

### Supported Cache Policies

- **`CachePolicy.cacheFirst`**: Checks the local cache first. If data exists, it returns immediately
  and skips the network call. Ideal for static or infrequently updated data.
- **`CachePolicy.networkFirst`**: Always attempts to fetch fresh data from the network first. If the
  network call fails (e.g., offline mode), it gracefully falls back to the last cached version.
- **`CachePolicy.swr` (Stale-While-Revalidate)**: Instantly emits cached data for immediate UI
  rendering, then fetches fresh data from the network in the background to update the cache.

### Usage Example

```dart
// 1. Initialize Hive (Usually done in main.dart)
await Hive.initFlutter();

// 2. Create the Hive Cache Provider instance
// For standard types like String, Map, or int. For custom models, register adapters first.
final myCacheProvider = HiveCacheProvider<String>(boxName: 'user_data_cache');

// 3. Initialize the Offline-First Handler
final handler = ResultexOfflineFirstHandler<String>(
  cacheProvider: myCacheProvider,
  policy: CachePolicy.swr, // Stale-While-Revalidate
);

// 4. Execute the request
await handler.execute(
  key: 'user_profile_123',
  fetcher: () => apiService.fetchUserProfile(), // Your network call
  onEmit: (state) {
  // Here you update the resultex state!
  // Example: resultState.value = state;
  print('Current UI State: $state');
  },
);
```
### **License 📄**

This project is licensed under the MIT License - see the LICENSE
file for details.
