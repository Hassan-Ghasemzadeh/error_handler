import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:resultex/lib/error_handler.dart';

/// A simple domain data transfer object (DTO) representing a system user.
class User {
  /// The unique identifier of the user.
  final int id;

  /// The name profile string of the user.
  final String name;

  /// Creates a standard [User] representation instance.
  User({required this.id, required this.name});

  @override
  String toString() => 'User(id: $id, name: "$name")';
}

// =========================================================================
// Data Layer Implementation (Repository matching Clean Architecture)
// =========================================================================

/// A boundary data repository managing data access and remote entity orchestration.
///
/// It utilizes the centralized structural [_executor] instance to wrap direct async operations
/// inside type-safe [Result] wrappers, automatically routing catches to the log telemetry.
class UserRepository {
  // Extract and assign the static ResultExecutor pipeline from the package initialization module.
  final _executor = ErrorHandler.executor;

  /// Fetches a target [User] entity profile securely from the infrastructure stream layer.
  ///
  /// Leverages `executeAsync` to build a clean protective boundary around the simulated local request.
  Future<Result<User>> getUserProfile(int id) async {
    return _executor.executeAsync(
      () async {
        // Simulate local database or remote network request latency.
        await Future.delayed(const Duration(milliseconds: 200));
        return User(id: id, name: "Hassan Ghasemzadeh");
      },
      context: 'UserRepository.getUserProfile($id)',
    );
  }

  /// Triggers a simulated problematic core remote data request context.
  ///
  /// Intentionally throws a [TimeoutException] to demonstrate how the infrastructure
  /// automatically intercepts, structures, and logs unexpected service breakdowns.
  Future<Result<User>> getRequiredConfiguration() async {
    return _executor.executeAsync(
      () async {
        // Simulate network pipeline latency before breaking.
        await Future.delayed(const Duration(milliseconds: 200));
        throw TimeoutException('Remote database failed to respond in time.');
      },
      context: 'UserRepository.getRequiredConfiguration',
    );
  }
}

// =========================================================================
// Main Execution Bootstrap Flow
// =========================================================================
void main() async {
  if (kDebugMode) {
    print('=== [Phase 1]: Bootstrapping Core Error Telemetry Containers ===\n');
  }

  // Trigger the asynchronous initialization lifecycle of dependencies and error hooks.
  await ErrorHandler().init();

  if (kDebugMode) {
    print(
        '\n=== [Phase 2]: Evaluating Functional Result Pattern Operations ===\n');
  }

  // Initialize the domain data boundary manager instance.
  final repository = UserRepository();

  // -------------------------------------------------------------
  // Scenario A: Standard Successful Future Data Request Execution
  // -------------------------------------------------------------
  final Result<User> successResult = await repository.getUserProfile(10);

  // Evaluate the monadic result variants safely via standard continuous structural folding.
  successResult.fold(
    onSuccess: (user) {
      if (kDebugMode) {
        print('✔ UI Success Callback: Render profile for -> ${user.name}');
      }
    },
    onFailure: (failure) {
      if (kDebugMode) {
        print('❌ UI Failure Callback: Display warning -> ${failure.message}');
      }
    },
  );

  if (kDebugMode) {
    print('\n-------------------------------------------------------------');
  }

  // -------------------------------------------------------------
  // Scenario B: Handling Network Collapses with Map & GetOrElse Functional Chains
  // -------------------------------------------------------------
  final Result<User> result = await repository.getRequiredConfiguration();
  if (kDebugMode) {
    print(
        '--- Processing Intercepted Failures & Validating Fallback Vectors: ---');
  }

  // Map transforms a successful monad into another state type without unwrapping or leaking structural variables.
  final upperCaseNameResult =
      successResult.map((user) => user.name.toUpperCase());
  if (kDebugMode) {
    print(
        '✔ Mapped structural identity output value: ${upperCaseNameResult.valueOrNull}');
  }

  // GetOrElse falls back onto a safe local domain baseline instance if the computation pipeline encounters a breakdown.
  final fallbackUser = result.getOrElse(User(id: 0, name: "Fallback Profile"));
  if (kDebugMode) {
    print(
        '❌ Extracted result reference with getOrElse strategy: $fallbackUser');
  }

  if (kDebugMode) {
    print('\n=== Pipeline Processing Sequence Evaluated and Cleared ===');
  }

  if (kDebugMode) {
    print('\n💡 For more advanced features and detailed documentation, please read the README.');
  }
}
