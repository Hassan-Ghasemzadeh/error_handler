# Resultex

A robust, type-safe error handling ecosystem for Dart and Flutter that implements the Result pattern
for clean, predictable error handling without exceptions.

[![pub package](https://img.shields.io/pub/v/resultex)](https://pub.dev/packages/resultex)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

📦 Overview
-------------
`resultex` brings a functional programming approach to error handling by wrapping your operational
outcomes in a type-safe container. Instead of throwing heavy exceptions and messing up your call
stack, every function returns a `Result` that is either a `SuccessResult` wrapping your value or a
`FailureResult` containing structured error details.

### Why Resultex?

* 🛡️ **Zero Try-Catch Boilerplate** - Handle operational errors exactly where they matter.
* 🔒 **Type-Safe Destructuring** - The Dart compiler ensures you handle both success and failure
  states.
* 🧩 **Pattern Matching** - Fully optimized for Dart 3+ exhaustive switch expressions.
* 🚂 **Composable Pipelines** - Chain complex operations effortlessly with `map` and `flatMap`.
* 🧪 **Highly Testable** - Predictable control flow, making Unit Testing a breeze without unexpected
  runtime crashes.
* 💎 **Clean Architecture Approved** - Follows SOLID principles, separating business logic outcomes
  from presentation layers.

🚀 Installation
----------------

### Prerequisites

* **Dart SDK:** `>=3.0.0 <4.0.0`
* **Flutter SDK:** `>=3.10.0`

Add `resultex` to your `pubspec.yaml`:

```yaml
dependencies:
  resultex: ^2.2.0
```

**🎯 Core Concepts**

1. Successful Result

```Dart

final result = Result.success(User(id: 1, name: "Hassan"));
// Contains a SuccessResult wrapping a Success<User> container
```

2. Failure Result

```Dart

final result = Result.failure(Failure(message: "Network request timeout"));
// Contains a FailureResult with messages, codes, and optional stackTraces
```

3. Exhaustive Pattern Matching (Dart 3+)

```Dart
switch (result) {
case SuccessResult<User>(success: Success(:final value)):
print('Welcome back, ${value.name}!');
case FailureResult<User>(failure: final fail):
print('Error occurred: ${fail.message}');
}
```

**🎨 Advanced Features & Extensions**

1. UI Layer Clean Mapping (.when())
   The package provides a tailored Flutter extension to directly map your Result states into widgets
   inside the build method without bloated conditions.

```Dart
import 'package:resultex/core/utils/result_flutterx_extension.dart';

@override
Widget build(BuildContext context) {
  return userResult.when(
    onSuccess: (user) => Text('Hello, ${user.name}'),
    onFailure: (failure) => Text('Error: ${failure.message}'),
  );
}
```

2. Concurrent Parallel Execution (ResultUtils.combineAll)
   When executing multiple operations simultaneously, ResultUtils.combineAll fires them in parallel.
   If any operation fails, it aggregates all intercepted errors into a unified MultiFailure contract
   instead of short-circuiting on the first error.

```Dart
import 'package:resultex/core/utils/result_utils.dart';

final Result<List<dynamic>> dashboardResult = await
ResultUtils.combineAll
([repository.fetchUserProfile(), // Future<Result<User>>
repository.fetchNotifications(), // Future<Result<List<Notif>>>
repository.fetchCryptoWallet(), // Future<Result<Wallet>>
]);

dashboardResult.when(
onSuccess: (data) {
final user = data[0] as User;
final wallet = data[2] as CryptoWallet;
// Render your screen using safely casted data
},
onFailure: (failure) {
if (failure is MultiFailure) {
print('${failure.failures.length} operations failed concurrently.');
}
},
);
```

3. Operational Recovery Path (.recover())
   Intercept an operational Failure and route it through an alternative backup execution pipeline
   smoothly.

```Dart

Result<User> userResult = await
authRepository.fetchRemoteUser
();

Result<User> finalizedResult = userResult.recover((failure) {
  print('Remote fetch failed: ${failure.message}. Falling back to local cache...');
  return Result.success(localDatabase.getCachedUser());
});
```

**📖 Fluid Usage Guide**
Safe Execution Closures (guard / guardAsync)
Automatically intercept synchronous or asynchronous unexpected exceptions and encapsulate them into
safe Result variants.

```dart
// Synchronous parsing guard
final result = Result.guard(() => jsonDecode(rawJsonString));
// Asynchronous API call guard
final networkResult = await
Result.guardAsync
(
() => http.get(Uri.parse(url
)
)
);
```

**Functional Chaining (map & flatMap)**
Transform successful values or sequentially chain multiple business operations without nesting
blocks.

```Dart
// Map values on success
final nameResult = result.map((user) => user.name); // Result<String>

// Chain dependencies flatly
final ordersResult = await
repository.getUser
(1)
.then((res) => res.flatMap((user) => orderRepository.getOrders(user.id)
)
);
```

**🔧 Advanced ResultExecutor Architecture**
Wrap execution scopes into monitored contexts complete with automated structured logging and error
tracking capabilities.

```Dart

final executor = ResultExecutor(logger: AppLogger());
final result = await
executor.executeAsync
(
() async {
`final data = await api.fetchData();
`return processData(data);
},
context
:
fetchAndProcessDashboardData
);
```

**🏗️ Best Practices**
✅ DO
Use ResultUtils.combineAll for maximizing parallel performance across independent network
dispatches.

Use the .when() extension inside Flutter layout building pipelines for pristine scannability.

Provide meaningful context tags within ResultExecutor blocks to maintain bulletproof debug logs.

❌ DON'T
Don't force-extract values without evaluating state via pattern matching or explicit folds.

Don't catch generic raw exceptions manually inside execution blocks managed by guard hooks.

**📄 License**
This project is licensed under the MIT License - see the LICENSE file for details. Open Source
development is respected; feel free to modify, distribute, and implement this package in both public
repositories and enterprise closed-source commercial systems.

**Made with ❤️ for clean, maintainable Dart & Flutter code architectures.**