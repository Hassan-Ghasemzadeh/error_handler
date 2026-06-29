# Result Package

A robust, type-safe error handling package for Dart and Flutter that implements the Result pattern for clean, predictable error handling without exceptions.

## 📦 Overview

`Result` is a functional programming approach to error handling that wraps your results in a type-safe container. Instead of throwing exceptions, every function returns a `Result` that is either a `Success` with a value or a `Failure` with error details.

### Why Result?

- ✅ **No more try-catch everywhere** - Handle errors where they matter
- ✅ **Type-safe** - Compiler knows if you've handled both cases
- ✅ **Pattern matching** - Clean Dart 3 switch expressions
- ✅ **Composable** - Chain operations with `map`, `flatMap`
- ✅ **Testable** - Predictable behavior, no unexpected exceptions
- ✅ **Clean Code** - Following SOLID principles

## 🚀 Installation

### Prerequisites
- Dart SDK: `>=3.0.0 <4.0.0`
- Flutter: `>=3.10.0`
 
## 🎯 Core Concepts
### 1. Successful Result
```dart
final result = Result.success(User(id: 1, name: "Ali"));
// Contains: Success<User> with value
```
### 2. Failure Result
```dart
final result = Result.failure(Failure(message: "Network error"));
// Contains: Failure with message and optional error/stackTrace
```
### 3. Pattern Matching (Dart 3)
```dart
switch (result) {
  case SuccessResult<User>(value: final user):
    print('Welcome ${user.name}!');
  case FailureResult<User>(failure: final failure):
    print('Error: ${failure.message}');
}
```
## 📖 Usage Guide
### Basic Usage
```dart
// Repository
class UserRepository {
  final ApiClient _api;
  final ResultExecutor _executor;

  Future<Result<User>> getUser(int id) async {
    return _executor.executeAsync(
      () => _api.fetchUser(id),
      context: 'getUser($id)',
    );
  }
}

// BLoC / Controller
Future<void> loadUser(int id) async {
  final result = await repository.getUser(id);
  
  result.fold(
    onSuccess: (user) => emit(UserLoaded(user)),
    onFailure: (failure) => emit(UserError(failure.message)),
  );
}
```
### Transform Values with map
```dart
final result = await repository.getUser(1);

// Transform only if success
final nameResult = result.map((user) => user.name);
// Result<String>: Success("Ali") or Failure("Network error")
```
### Chain Operations with flatMap
```dart
// Get user, then get their orders
final ordersResult = await repository.getUser(1)
  .then((result) => result.flatMap(
    (user) => orderRepository.getOrders(user.id),
  ));
```
### Provide Defaults with getOrElse
```dart
final user = result.getOrElse(User.guest());
// Returns user or guest if failure
```
### Null Safety with fromNullable
```dart
final result = Result.fromNullable(
  cachedUser,
  errorMessage: 'User not found in cache',
);
```
### Safe Execution with guard
```dart
// Synchronous
final result = Result.guard(() => jsonDecode(rawJson));

// Asynchronous
final result = await Result.guardAsync(
  () => http.get(Uri.parse(url)),
);
```
### Combine Multiple Results
```dart
final results = await Future.wait([
  repository.getUser(1),
  repository.getUser(2),
]);

// One fails, all fails
final combined = Result.combine(results);
// Result<List<User>>
```
### Partition Successes and Failures
```dart
final (users, errors) = Result.partition(results);
// users: List<User> - all successful
// errors: List<Failure> - all failures
```
## 🔧 ResultExecutor
```dart
// Setup
final executor = ResultExecutor(
  logger: AppLogger(), 
);

// Usage
final result = await executor.executeAsync(
  () async {
    // Your operation
    final data = await api.fetch();
    return processData(data);
  },
  context: 'fetchAndProcess',
);
```
## Features:
🎯 Consistent error formatting

📝 Automatic logging

🔍 Debug mode support

📊 Execution context tracking
## 🌐 Global Error Handling
```dart
void main() {
  final errorHandler = FlutterErrorHandler(
    logger: AppLogger(),
    crashReporter: FirebaseCrashReporter(),
  );
  
  errorHandler.register();
  
  runApp(MyApp());
}
```
## 🎨 Real-World Examples
### 1. Form Validation
```dart
Result<String> validateEmail(String email) {
  if (email.isEmpty) return Result.failure(Failure(message: "Email is required"));
  if (!email.contains('@')) return Result.failure(Failure(message: "Invalid email"));
  return Result.success(email);
}

// Usage
validateEmail(value).fold(
  onSuccess: (email) => submitForm(email),
  onFailure: (error) => showError(error.message),
);
```
### 2. Cache-First Strategy
```dart
Future<Result<User>> getUser(int id) async {
  // Try cache first
  final cached = await cache.getUser(id);
  if (cached != null) return Result.success(cached);
  
  // Fetch from network
  final result = await network.getUser(id);
  
  // Cache if successful
  return result.map((user) {
    cache.saveUser(user);
    return user;
  });
}
```
### 3. Multiple API Calls
```dart
Future<Result<DashboardData>> loadDashboard() async {
  final results = await Future.wait([
    repository.getUser(userId),
    repository.getNotifications(userId),
    repository.getStats(userId),
  ]);
  
  final (success, failures) = Result.partition(results);
  
  if (failures.isNotEmpty) {
    return Result.failure(Failure(
      message: '${failures.length} operations failed',
    ));
  }
  
  return Result.success(DashboardData(
    user: success[0] as User,
    notifications: success[1] as List<Notification>,
    stats: success[2] as Stats,
  ));
}
```
## 🏗️ Best Practices
### ✅ DO:
#### - Always use ResultExecutor for API calls
#### - Use context parameter for debugging
#### - Handle both onSuccess and onFailure in fold
#### - Use map for simple transformations
#### - Use flatMap for chaining async operations

### ❌ DON'T:
#### - Don't extract value without checking isSuccess
#### - Don't catch exceptions inside guard/guardAsync
#### - Don't ignore failures - always handle both cases
#### - Don't use getOrThrow() in production code

## 🔄 Migration Guide
### Before (Exception-based):
```dart
try {
  final user = await api.getUser(1);
  // use user
} catch (e) {
  showError(e.toString());
}
```
### After (Result-based):
````dart
final result = await repository.getUser(1);
result.fold(
  onSuccess: (user) => useUser(user),
  onFailure: (error) => showError(error.message),
);
````
## 🚀 Performance
Result is a zero-cost abstraction in release mode. The Dart compiler optimizes sealed classes efficiently, making it suitable for high-performance applications.
## Contact
Email: software.clean.development@gmail.com
## License
Copyright © 2023

This Error handler is a free software licensed under GPL v3.0
It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Being Open Source doesn't mean you can just make a copy of the app and upload it on playstore or sell
a closed source copy of the same.
Read the following carefully:
1. Any copy of a software under GPL must be under same license. So you can't upload the app on a closed source
  app repository like PlayStore/AppStore without distributing the source code.
2. You can't sell any copied/modified version of the app under any "non-free" license.
   You must provide the copy with the original software or with instructions on how to obtain original software,
   should clearly state all changes, should clearly disclose full source code, should include same license
   and all copyrights should be retained.

In simple words, You can ONLY use the source code of this app for `Open Source` Project under `GPL v3.0` or later
with all your source code CLEARLY DISCLOSED on any code hosting platform like GitHub, with clear INSTRUCTIONS on
how to obtain the original software, should clearly STATE ALL CHANGES made and should RETAIN all copyrights.
Use of this software under any "non-free" license is NOT permitted.

### Made with ❤️ for clean, maintainable Dart/Flutter code
