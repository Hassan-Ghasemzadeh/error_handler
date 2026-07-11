<p align="center">
  <img src="https://raw.githubusercontent.com/Hassan-Ghasemzadeh/error_handler/main/docs/assets/header.svg" alt="Resultex Ecosystem Banner" width="100%">
</p>

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
resultex: ^2.6.0
```

### **Core Concepts**

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

### Reactive UI Validation (`ResultTextController`)

Stop writing custom stateful boilerplate or messy condition branches just to validate form fields.
`ResultTextController` extends Flutter's native `TextEditingController` with a built-in functional
error boundary.

```dart
// 1. Declare the controller with atomic business logic predicates
final emailController = ResultTextController<String>(
  validator: (text) {
    if (text.isEmpty) return Result.failure(Failure(message: 'Email cannot be empty'));
    if (!text.contains('@')) return Result.failure(Failure(message: 'Invalid email format'));
    return Result.success(text.trim());
  },
);

// 2. Evaluate instantly in your UI thread without boilerplate
@override
Widget build(BuildContext context) {
  return TextField(
    controller: emailController,
    decoration: InputDecoration(
      // Dynamic inline error reading!
      errorText: emailController.validatedResult.when(
        onSuccess: (_) => null,
        onFailure: (fail) => fail.message,
      ),
    ),
  );
}
```

**Functional Side-Effect Interception (.inspect)**  
Sometimes you need to intercept data midway through a functional stream for analytics, local
caching, or debugging without modifying the wrapped payload state. Use .inspectSuccess and
.inspectFailure to execute clean passive telemetry.

```Dart

final profileResult = await
authRepository.getProfile
().inspectSuccess
(
(user) => firebaseAnalytics.logUserLogin(user.id))
    .inspectFailure((fail) => appLogger.critical('Telemetry crash: ${fail.message}'))
    .map((user) => user
.
toSummary
(
)
); // The user object travels downstream completely unaltered!
```

**Fluent Pipeline Constraints (.ensure)**  
Enforce atomic operational rules instantly downstream using .ensure. If the predicate yields false,
it automatically short-circuits the pipeline into a structured FailureResult.

```Dart

final Result<User> adultUserResult = await
authRepository.getProfile
().ensure
(
(user) => user.age >= 18,
(user) => Failure(message: "Access Forbidden: ${user.name} is underaged."),
);
```

**Crash-Proof Reactive Flows (.toResultStream())**  
Raw asynchronous Streams (like WebSockets, Location trackers, or Firebase listeners) are highly
prone to unhandled runtime leaks that crash the UI stack. Safely encapsulate them into stable
error-boundary streams.

```Dart
// Transforms Stream<T> natively into a stable Stream<Result<T>>
Stream<Result<LocationData>> safeCoordinates = locationService
    .listenToCoordinates()
    .toResultStream();

safeCoordinates.listen
(
(result) {
result.when(
onSuccess: (coords) => updateMapPin(coords),
onFailure: (fail) => showNetworkAlert(fail.message),
);
});
```

**Zero-Data Expressive Closures (VoidResult)**  
In functional design, returning Result<void> or Result.success(null) is an anti-pattern. Use the
robust, immutable VoidResult alias and Unit type to cleanly model operations that succeed with no
return payload (like deleting database entities).

```Dart
VoidResult logoutUser() {
  try {
    secureStorage.clearAllTokens();
    return VoidResult.success(); // Expressive, type-safe substitute for void/null
  } catch (e) {
    return VoidResult.failure(Failure(message: e.toString()));
  }
}
```

### **Reactive UI Layer**

State Management via ResultNotifier  
A lightweight, lifecycle-aware alternative to heavy state management boilerplate. Track any
asynchronous operation safely inside your controllers or state classes.

```dart

final userNotifier = ResultNotifier<User>();

// Automatically handles loading state, catches unexpected errors, and updates the UI
userNotifier.track
(
repository
.
fetchUserProfile
(
)
);
```

**Declarative Layouts via ResultBuilder**  
Eliminate bloated conditions inside your widget tree. Separate your UI cleanly into three
predictable layout paths.

```Dart
@override
Widget build(BuildContext context) {
  return ResultBuilder<User>(
    notifier: _userNotifier,
    onLoading: (context) => const CircularProgressIndicator(),
    onFailure: (context, failure) => Text('Error: ${failure.message}'),
    onSuccess: (context, user) => Text('Hello, ${user.name}'),
  );
}
```

## Advanced Features (Enterprise Grade)

Resultex is built to scale. For large, complex Flutter applications, the package offers advanced
architectural tools to handle memory safety, concurrency, and global monitoring.

1. Memory-Safe Operations (`CancellableResult`)

Prevent memory leaks and the dreaded `setState() called after dispose()` error in Flutter. When a
user navigates away from a screen, you can instantly abort any pending background operations.

```dart
late CancellableResult<UserProfile> profileRequest;

@override
void initState() {
  super.initState();
  profileRequest = Result.cancellable(() => api.fetchUserProfile());

  profileRequest.value.then((result) {
    result.when(
      onSuccess: (profile) => setState(() => this.profile = profile),
      onFailure: (failure) {
        // Automatically ignores the failure if it was cancelled
        if (failure is CancellationFailure) return;
        showError(failure.message);
      },
    );
  });
}

@override
void dispose() {
  profileRequest.cancel('Screen disposed'); // Instantly severs the pipeline
  super.dispose();
}
```

2. High-Availability Racing (Result.race)
   Speed up your app by requesting data from multiple sources simultaneously. Result.race waits for
   the first successful response and ignores the rest. It only returns a failure if ALL operations
   fail.

```Dart

final Result<AppConfig> configResult = await
Result.race
([api.fetchFromPrimaryServer(),
api.fetchFromBackupCDN(),
localDatabase.getCachedConfig(),
]);
```

3. Concurrent Request Memoization (Result.memoizeAsync)
   Optimize performance by ensuring a heavy process or network request is only executed once, even
   if requested multiple times concurrently by different UI components.

```Dart
// The network request executes only once.
final fetchDashboard = Result.memoizeAsync(() => api.getHeavyDashboardData());

// Both widgets safely await the exact same process without duplicate API calls.
final widgetOneData = await

fetchDashboard();

final widgetTwoData = await

fetchDashboard();
```

4. Global Error Telemetry (ResultexObserver)
   Stop writing repetitive logging boilerplate in your UI or Domain layers. Register a global
   observer once to automatically catch and report every Failure instantiated in your app to your
   telemetry service (like Sentry or Firebase).

```Dart
void main() {
  ResultexObserver.initialize((failure, stackTrace) {
// Automatically logs every failure across the entire app
    FirebaseCrashlytics.instance.recordError(failure.message, stackTrace);
  });
  runApp(const MyApp());
}
```

## **Advanced Functional Pipelines**

### Type-Safe Record Zipping (Dart 3+)

Resultex provides an elegant, compile-time type-safe ecosystem to consolidate completely dynamic and
heterogeneous `Result` instances concurrently using modern Dart 3 Records.

Instead of manual index casting (`as User`), you can wrap your independent operations inside a
record tuple and call `.zip()` directly. If any internal operation yields a `FailureResult`, the
entire pipeline short-circuits instantly, propagating that precise failure downstream.

### Heterogeneous Zip Example (Up to 5 Elements)

```dart
import 'package:resultex/resultex.dart';

Future<void> loadDashboard() async {
  // 1. Fire asynchronous requests or continuous operations
  final Result<User> userRes = await authRepository.getProfile();
  final Result<CryptoWallet> walletRes = await cryptoRepository.getBalance();

  // 2. Zip disparate types seamlessly with 100% type safety
  final Result<DashboardView> dashboardResult = (userRes, walletRes).zip(
        (User user, CryptoWallet wallet) {
      // Both parameters are strongly typed based on the input record tuple!
      return DashboardView(user: user, wallet: wallet);
    },
  );

  // 3. Evaluate and fold into your presentation tier
  dashboardResult.fold(
    onSuccess: (view) => renderDashboard(view),
    onFailure: (failure) => showErrorSnackBar(failure.message),
  );
}
```

**Asynchronous Chaining (asyncMap & asyncFlatMap)**  
Chain multiple asynchronous dependencies sequentially without running into await callback hell.

```Dart
// Streamline complex database/network pipelines elegantly
Future<Result<Orders>> ordersResult = repository.getUser(1) // Future<Result<User>>
    .asyncMap((user) => user.id) // Future<Result<int>>
    .asyncFlatMap((id) => orderRepository.getOrders(id)); // Future<Result<Orders>>
```

**Adapting Errors downstream (mapFailure)**  
Transform internal exceptions into localized or presentation-friendly error messages before hitting
the UI.

```Dart

final uiResult = apiResult.mapFailure(
      (fail) => Failure(message: 'Localized Error: ${fail.message}'),
);
```

**Resilient Operation Retries (withRetry)**  
Attach configurable recovery retries to any transient network dispatch with support for exponential
backoff.

```Dart

final networkResult = await
Result.guardAsync
(
() => (() => http.get(uri)).withRetry(
const RetryOptions(maxAttempts: 3, delay: Duration(seconds: 2), backoffFactor: 2.0),
),
);
```

### **Advanced Features & Extensions**

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

**Fluid Usage Guide**  
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

**Advanced ResultExecutor Architecture**  
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

### **Best Practices**

✅ DO

- Use ResultUtils.combineAll for maximizing parallel performance across independent network
  dispatches.
- Use the .when() extension inside Flutter layout building pipelines for pristine scannability.
- Provide meaningful context tags within ResultExecutor blocks to maintain bulletproof debug logs.

❌ DON'T

- Don't force-extract values without evaluating state via pattern matching or explicit folds.
- Don't catch generic raw exceptions manually inside execution blocks managed by guard hooks.

**📄 License**
---------------
This project is licensed under the MIT License - see the LICENSE file for details. Open Source
development is respected; feel free to modify, distribute, and implement this package in both public
repositories and enterprise closed-source commercial systems.

### **Made with ❤️ for clean, maintainable Dart & Flutter code architectures.**