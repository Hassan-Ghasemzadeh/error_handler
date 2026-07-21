<div align="center" style="text-align: center;">
<p align="center">
    <a href="https://github.com/Hassan-Ghasemzadeh/error_handler/tree/main" align="center">
        <img src="https://github.com/Hassan-Ghasemzadeh/error_handler/blob/main/docs/assets/resultex.png?raw=true" width="250px">
    </a>
</p>

## Robust, type-safe error handling for Dart and Flutter
<br>

Log your app actions, catch and handle exceptions, and implement clean, predictable error handling without using exceptions.
Show some ❤️ and [star the repo](https://github.com/Hassan-Ghasemzadeh/error_handler) to support the project!

<img src="https://raw.githubusercontent.com/Hassan-Ghasemzadeh/error_handler/main/docs/assets/header.png" alt="Resultex Ecosystem Banner" width="100%">

<br>  
<p align="center">
  <a href="https://pub.dev/packages/resultex"><img src="https://img.shields.io/pub/v/resultex" alt="resultex"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-yellow.svg" alt="License: MIT"></a>

  <br>
  <a href="https://github.com/Hassan-Ghasemzadeh/error_handler/tree/main/packages/resultex"><img src="https://img.shields.io/badge/resultex-passing-brightgreen"  alt="resultex"></a>
  <a href="https://github.com/Hassan-Ghasemzadeh/error_handler/tree/main/packages/resultex_network"><img src="https://img.shields.io/badge/resultex__network-passing-brightgreen" alt="resultex_network"></a>
  <a href="https://github.com/Hassan-Ghasemzadeh/error_handler/tree/main/packages/resultex_logger"><img src="https://img.shields.io/badge/resultex__logger-passing-brightgreen" alt="resultex_logger"></a>
</p>
</div>

## Overview

`resultex` brings a functional programming approach to error handling by wrapping your operational
outcomes in a type-safe container. Instead of throwing heavy exceptions and messing up your call
stack, every function returns a `Result` that is either a `SuccessResult` wrapping your value or a
`FailureResult` containing structured error details.

### Why Resultex?

* ✅ **Zero Try-Catch Boilerplate** - Handle operational errors exactly where they matter.
* ✅ **Type-Safe Destructuring** - The Dart compiler ensures you handle both success and failure
  states.
* ✅ **Pattern Matching** - Fully optimized for Dart 3+ exhaustive switch expressions.
* ✅ **Composable Pipelines** - Chain complex operations effortlessly with `map` and `flatMap`.
* ✅ **Highly Testable** - Predictable control flow, making Unit Testing a breeze without unexpected
  runtime crashes.
* ✅ **Clean Architecture Approved** - Follows SOLID principles, separating business logic outcomes
  from presentation layers.

## Packages

Resultex provides a robust, type-safe, and boilerplate-free way to handle operations in Dart and Flutter.

| Package | Version | Description |
| :--- | :--- | :--- |
| [resultex](https://pub.dev/packages/resultex) | [![pub](https://img.shields.io/pub/v/resultex.svg)](https://pub.dev/packages/resultex) | Main dart package for error handling |
| [resultex_logger](https://pub.dev/packages/resultex_logger) | [![pub](https://img.shields.io/pub/v/resultex_logger.svg)](https://pub.dev/packages/resultex_logger) | Customizable logger for resultex |
| [resultex_network](https://pub.dev/packages/resultex_network) | [![pub](https://img.shields.io/pub/v/resultex_network.svg)](https://pub.dev/packages/resultex_network) | Network error handling for Resultex |

## Get Started

## Installation 

### Prerequisites
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.10.0'

```

Add `resultex` to your `pubspec.yaml`:

```yaml
dependencies:
resultex: ^3.0.3
```
### Easy to use
You can access the `Resultex` instance throughout  
your application with a simple and concise syntax.
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Resultex.init();
  final executor = Resultex.executor; 
}
```
### **Core Concepts**

1. **Successful Result**

```dart

final result = Result.success(User(id: 1, name: "Hassan"));
// Contains a SuccessResult wrapping a Success<User> container
```

2. **Failure Result**

```dart

final result = Result.failure(Failure(message: "Network request timeout"));
// Contains a FailureResult with messages, codes, and optional stackTraces
```

3. **Exhaustive Pattern Matching (Dart 3+)**

```dart 
  switch (result) {
    case SuccessResult<User>(success: Success(:final value)):
      resultexLogger.info('Welcome back, ${value.name}!');
    case FailureResult<User>(failure: final fail):
      resultexLogger.debug('Error occurred: ${fail.message}');
  } 
```
## **ResultExecutor Architecture**  
Wrap execution scopes into monitored contexts complete with automated structured logging and error
tracking capabilities.

```dart
final executor = ResultExecutor(logger: AppLogger());
final result = await executor.executeAsync(() async {
final data = await api.fetchData();
return processData(data);
}, context: 'fetchAndProcessDashboardData');
```
You can see more features about `ResultexExecutor` [here](https://github.com/Hassan-Ghasemzadeh/error_handler/blob/main/packages/resultex/lib/src/result_executor/result_executor.dart).

## Logical Features
### **Functional Side-Effect Interception (.inspect)**  
Sometimes you need to intercept data midway through a functional stream for analytics, local
caching, or debugging without modifying the wrapped payload state. Use .inspectSuccess and
.inspectFailure to execute clean passive telemetry.

```dart 
final profileResult = await authRepository     
    .getProfile()
    .inspectSuccess((user) => firebaseAnalytics.logUserLogin(user.id))
    .inspectFailure(
      (fail) => appLogger.critical('Telemetry crash: ${fail.message}'))
    .map((user) => user.toSummary());
```

### **Fluent Pipeline Constraints (.ensure)**  
Enforce atomic operational rules instantly downstream using .ensure. If the predicate yields false,
it automatically short-circuits the pipeline into a structured FailureResult.

```dart
final Result<User> adultUserResult = await authRepository
    .getProfile()
    .ensure(
      (user) => user.age >= 18,
      (user) =>
        Failure(message: "Access Forbidden: ${user.name} is underaged."),
    );
```

### **Crash-Proof Reactive Flows (.toResultStream())**  
Raw asynchronous Streams (like WebSockets, Location trackers, or Firebase listeners) are highly
prone to unhandled runtime leaks that crash the UI stack. Safely encapsulate them into stable
error-boundary streams.

```dart 
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

### **Zero-Data Expressive Closures (VoidResult)**  
In functional design, returning Result<void> or Result.success(null) is an anti-pattern. Use the
robust, immutable VoidResult alias and Unit type to cleanly model operations that succeed with no
return payload (like deleting database entities).

```dart
VoidResult logoutUser() {
  try {
    secureStorage.clearAllTokens();
    return VoidResult.success(); // Expressive, type-safe substitute for void/null
  } catch (e) {
    return VoidResult.failure(Failure(message: e.toString()));
  }
}
```

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

### **Asynchronous Chaining (asyncMap & asyncFlatMap)**  
Chain multiple asynchronous dependencies sequentially without running into await callback hell.

```dart
// Streamline complex database/network pipelines elegantly
Future<Result<Orders>> ordersResult = repository.getUser(1) // Future<Result<User>>
    .asyncMap((user) => user.id) // Future<Result<int>>
    .asyncFlatMap((id) => orderRepository.getOrders(id)); // Future<Result<Orders>>
```

### **Adapting Errors downstream (mapFailure)**  
Transform internal exceptions into localized or presentation-friendly error messages before hitting
the UI.

```dart

final uiResult = apiResult.mapFailure(
      (fail) => Failure(message: 'Localized Error: ${fail.message}'),
);
```

### **Resilient Operation Retries (withRetry)**  
Attach configurable recovery retries to any transient network dispatch with support for exponential
backoff.

```dart 
final networkResult = await
  Result.guardAsync
    (
        () => (() => http.get(uri)).withRetry(
      const RetryOptions(
          maxAttempts: 3, delay: Duration(seconds: 2), backoffFactor: 2.0),
    ),
  ); 
```

### **Fluid Usage Guide**  
Safe Execution Closures (guard / guardAsync)
Automatically intercept synchronous or asynchronous unexpected exceptions and encapsulate them into
safe Result variants.

```dart
final result = Result.guard(() => jsonDecode(rawJsonString));
final networkResult = await Result.guardAsync(() => http.get(Uri.parse(url)));
```

### **Functional Chaining (map & flatMap)**  
Transform successful values or sequentially chain multiple business operations without nesting
blocks.

```dart
final nameResult = result.map((user) => user.name); // Result<String>
final ordersResult = await repository
    .getUser(1)
.then((res) => res.flatMap((user) => orderRepository.getOrders(user.id)));
```

### Concurrent Parallel Execution (ResultUtils.combineAll)
   When executing multiple operations simultaneously, ResultUtils.combineAll fires them in parallel.
   If any operation fails, it aggregates all intercepted errors into a unified MultiFailure contract
   instead of short-circuiting on the first error.

```dart 
  final Result<List<dynamic>> dashboardResult = await
  ResultUtils.combineAll
    ([repository.fetchUserProfile(),
    repository.fetchNotifications(),
    repository.fetchCryptoWallet(),
  ]); 
```


### Operational Recovery Path (.recover())
   Intercept an operational Failure and route it through an alternative backup execution pipeline
   smoothly.

```dart

Result<User> userResult = await authRepository.fetchRemoteUser();
Result<User> finalizedResult = userResult.recover((failure) {
  print('Remote fetch failed: ${failure.message}. Falling back to local cache...');
  return Result.success(localDatabase.getCachedUser());
});
```
## UI features
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

### **Reactive UI Layer**

State Management via ResultNotifier  
A lightweight, lifecycle-aware alternative to heavy state management boilerplate. Track any
asynchronous operation safely inside your controllers or state classes.

```dart 
  final userNotifier = ResultNotifier<User>();
  userNotifier.track(repository.fetchUserProfile());
```

#### **Declarative Layouts via ResultBuilder**  
Eliminate bloated conditions inside your widget tree. Separate your UI cleanly into three
predictable layout paths.

```dart
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

### UI Layer Clean Mapping (.when())
   The package provides a tailored Flutter extension to directly map your Result states into widgets
   inside the build method without bloated conditions.

```dart
import 'package:resultex/core/utils/result_flutterx_extension.dart';

@override
Widget build(BuildContext context) {
  return userResult.when(
    onSuccess: (user) => Text('Hello, ${user.name}'),
    onFailure: (failure) => Text('Error: ${failure.message}'),
  );
}
```
### CancellableResult

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
### Handling Side-Effects (`ResultListener`)

Use `ResultListener` when you want to execute side-effects (such as showing SnackBars, displaying Dialogs, or triggering Navigation) **without rebuilding the UI subtree**.

```dart
ResultListener<User>(
    notifier: _userNotifier,
    onSuccessListener: (context, user) {
    Navigator.of(context).pushNamed('/profile');
  },
    onFailureListener: (context, failure) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(failure.message)),
    );
  },
  child: const UserProfileBody(), // Static child — never rebuilds on state changes
)
```
### Combined UI & Side-Effects (ResultConsumer)
Use ResultConsumer when a single component needs to both rebuild the UI and execute side-effects in response to state changes. It cleanly merges ResultBuilder and ResultListener.
```dart
ResultConsumer<User>(
  notifier: _userNotifier,
  // --- Side-Effect Callbacks ---
  onFailureListener: (context, failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(failure.message)),
    );
  },
  onSuccessListener: (context, user) {
    print('User logged in: ${user.name}');
  },
  // --- UI Builder Callbacks ---
  onLoading: (context) => const CircularProgressIndicator(),
  onFailure: (context, failure) => Text('Error: ${failure.message}'),
  onSuccess: (context, user) => Text('Welcome, ${user.name}!'),
)
```
## (Unit Testing Matchers)
### Fluent Unit Testing (`resultex_test.dart`)

Resultex provides first-class framework-level matchers to make your domain and data layer unit tests
extremely expressive and readable.

To keep your production builds lightweight, these utilities are isolated. Simply import the
dedicated test entry point in your test files:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';
import 'package:resultex/resultex_test.dart'; // Import custom matchers

void main() {
  group('User Repository Tests', () {
    test('should return SuccessResult with accurate payload', () async {
      final result = await repository.fetchUser(1);

      expect(result, isSuccess<User>());
      expect(result, isSuccess<User>(expectedUser)); // Verifies the internal payload
    });

    test('should gracefully intercept server errors', () async {
      final result = await repository.fetchUser(500);

      expect(result, isFailure());
      expect(result, isFailure('Internal Server Error')); // Verifies the exact message
    });

    test('should match specific clean architecture failure types', () async {
      final result = await repository.fetchUserWithoutInternet();

      expect(result, isFailureType<NetworkFailure>()); // Asserts the exact subclass
    });
  });
}
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
----
For deep-dive documentation and all available features,
please refer to the [GitHub repository.](https://github.com/Hassan-Ghasemzadeh/error_handler/).

**📄 License**
---------------
This project is licensed under the MIT License - see the LICENSE file for details. Open Source
development is respected; feel free to modify, distribute, and implement this package in both public
repositories and enterprise closed-source commercial systems.

### **Made with ❤️ for clean, maintainable Dart & Flutter code architectures.**