import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:resultex/core/extensions/future_result.dart';
import 'package:resultex/core/extensions/result_flutterx_extension.dart';
import 'package:resultex/core/extensions/result_zip_record.dart';
import 'package:resultex/core/utils/result_collection.dart';
import 'package:resultex/core/utils/result_utils.dart';
import 'package:resultex/resultex.dart';
import 'package:resultex/src/model/multi_failure.dart';

void main() async {
  // Ensure Flutter binding is initialized if needed before async main operations
  WidgetsFlutterBinding.ensureInitialized();

  // Simulating ecosystem lifecycle initialization
  final loggerBase = Resultex();
  await loggerBase.init();

  // Run legacy dashboards and collection utilities examples
  await _loadDashboardData();
  await _loadZippedDashboardData();
  await _processBatchRawFeeds();

  // =========================================================================
  // Execute new ResultExecutor educational examples
  // =========================================================================
  _demonstrateSyncExecution();
  await _demonstrateAsyncExecution();
  await _demonstrateStreamExecution();

  if (kDebugMode) {
    print('\nAll Resultex learning models executed perfectly.');
  }
}

// =========================================================================
// NEW: ResultExecutor Educational Examples
// =========================================================================

/// 1. Demonstrates handling synchronous (Sync) operations and capturing unexpected runtime crashes.
void _demonstrateSyncExecution() {
  // Assuming the executor instance is exposed via your core package singleton
  final executor = Resultex.executor;

  if (kDebugMode) {
    print('\n--- [ResultExecutor] 1. Synchronous Execution Demo ---');
  }

  // Scenario: Parsing an invalid string to an integer which normally throws a FormatException
  final Result<int> syncResult = executor.execute<int>(
    () {
      final rawString = "123_invalid_number";
      return int.parse(rawString); // This line will intentionally crash
    },
    context: 'ParsingUserAgeScope',
  );

  // The executor safely intercepts the crash, routes diagnostics, and returns a structured Failure
  syncResult.fold(
    onSuccess: (value) => print('Sync Success: $value'),
    onFailure: (failure) {
      if (kDebugMode) {
        print('Sync Intercepted Crash Successfully!');
        print('Captured Error Message: ${failure.message}');
      }
    },
  );
}

/// 2. Demonstrates handling asynchronous (Async) pipelines and the flat-mapping capability.
Future<void> _demonstrateAsyncExecution() async {
  final executor = Resultex.executor;
  final repository = DashboardRepository();

  if (kDebugMode) {
    print('\n--- [ResultExecutor] 2. Async & Flat-Mapping Demo ---');
  }

  // Case A: Wrapping a raw primitive Future pipeline (e.g., standard HTTP or third-party client)
  final Result<String> rawAsyncResult = await executor.executeAsync<String>(
    () async {
      await Future.delayed(const Duration(milliseconds: 200));
      return "Raw_Session_Token_XYZ";
    },
    context: 'FetchRawTokenNetworkScope',
  );

  // Case B: Flat-mapping a repository call that already returns a Result wrapper.
  // The executor automatically flattens it to Result<User> instead of nesting into Result<Result<User>>.
  final Result<User> profileResult = await executor.executeAsync<User>(
    () => repository.fetchUserProfile(),
    // This repository method returns Future<Result<User>>
    context: 'MonitoredProfileFetchScope',
  );

  profileResult.fold(
    onSuccess: (user) {
      if (kDebugMode) print('Async Executor Success: Loaded User ${user.name}');
    },
    onFailure: (fail) => print('Async Executor Failure: ${fail.message}'),
  );
}

/// 3. Demonstrates monitoring and securing multi-event stream pipelines.
Future<void> _demonstrateStreamExecution() async {
  final executor = Resultex.executor;

  if (kDebugMode) {
    print('\n--- [ResultExecutor] 3. Stream Pipeline Monitoring Demo ---');
  }

  // A mock stream factory that emits safe events and then throws a unexpected terminal exception
  Stream<double> mockPriceStreamFactory() async* {
    yield 54200.50; // Valid event 1
    yield 54350.20; // Valid event 2
    throw TimeoutException("Lost connection to live crypto socket feed!");
  }

  // Transforms the raw stream into a safe Stream<Result<T>> for secure UI binding (e.g., StreamBuilder)
  final Stream<Result<double>> securePriceStream =
      executor.executeStream<double>(
    mockPriceStreamFactory,
    context: 'CryptoLivePriceFeedScope',
  );

  // Listening to the safe stream sequences without breaking the host runtime loop
  await for (final Result<double> result in securePriceStream) {
    result.fold(
      onSuccess: (price) {
        if (kDebugMode) print('Stream Event -> Live Price Updated: \$$price');
      },
      onFailure: (failure) {
        if (kDebugMode) {
          print('Stream Intercepted Exception Safely: ${failure.message}');
        }
      },
    );
  }
}

/// Executes multiple asynchronous repository calls concurrently using [ResultUtils.combineAll].
Future<void> _loadDashboardData() async {
  final repository = DashboardRepository();

  // Fire all asynchronous requests concurrently to optimize execution time
  final Result<List<dynamic>> dashboardResult = await ResultUtils.combineAll([
    repository.fetchUserProfile(),
    repository.fetchNotifications(),
    repository.fetchCryptoWallet(),
  ]);

  // Evaluates the aggregated result state and resolves it into a target Flutter Widget
  final Widget displayWidget = dashboardResult.when(
    onSuccess: (data) {
      return const Text('Success');
    },
    onFailure: (failure) {
      if (failure is MultiFailure) {
        if (kDebugMode) {
          print(
              'Concurrently failed operations count: ${failure.failures.length}');
        }
      }
      return const Text('Failure');
    },
  );

  if (kDebugMode) {
    print('UI state successfully mapped via combineAll: $displayWidget');
  }
}

// =========================================================================
// NEW: Advanced Ecosystem Examples Implementation
// =========================================================================

/// Demonstrates [ResultZipRecordX.zip2] and [FutureResultX.toResult] utilities.
/// Merges completely different types concurrently with 100% compile-time type safety.
Future<void> _loadZippedDashboardData() async {
  final repository = DashboardRepository();

  // Step 1: Fire disparate requests and instantly unwrap primitive futures into safe Result wrappers using `.toResult()`
  final Result<User> userRes = await repository.fetchUserProfile();

  // Simulating a direct raw Future network dispatch converted inline using the new extension
  final Result<CryptoWallet> walletRes =
      await repository.fetchRawExternalWallet().toResult();

  // Step 2: Zip heterogeneous results safely via the new Dart 3 Records ecosystem wrapper
  // No explicit list indexes parsing or runtime casting ('as User') required!
  final Result<Widget> displayWidgetResult = (userRes, walletRes).zip(
    (user, wallet) {
      if (kDebugMode) {
        print(
            'Zipped Data Verified -> User: ${user.name}, Wallet Balance: ${wallet.balance}');
      }
      return Text('Welcome ${user.name}, Assets: \$${wallet.balance}');
    },
  );

  displayWidgetResult.when(
    onSuccess: (widget) =>
        Text('UI state mapped via Type-Safe Record Zip: $widget'),
    onFailure: (fail) =>
        Text('Zip operational pipeline broken: ${fail.message}'),
  );
}

/// Demonstrates [ResultCollection.mapList] utilizing both Strict and Lenient fallback strategies.
Future<void> _processBatchRawFeeds() async {
  // A simulated list of incoming untrusted raw payloads from external providers
  final List<Map<String, dynamic>> rawJsonFeed = [
    {'title': 'System Security Patch Released'},
    {'corrupted_key': null}, // Bad record that will throw during extraction
    {'title': 'Database Backup Completed Successfully'},
  ];

  if (kDebugMode) {
    print('\n--- Executing Collection Transformation Strategies ---');
  }

  // Tactics A: Lenient Mode (strict: false) -> Filters out corrupt records gracefully, keeping the view alive
  final Result<List<AppNotification>> lenientResult =
      ResultCollection.mapList<Map<String, dynamic>, AppNotification>(
    rawJsonFeed,
    (json) => Result.guard(() => AppNotification.fromMap(json)),
    strict: false,
  );

  lenientResult.fold(
    onSuccess: (notifications) {
      if (kDebugMode) {
        print(
            'Lenient MapList Success: Harvested ${notifications.length} functional records out of ${rawJsonFeed.length}.');
      }
    },
    onFailure: (_) {},
  );

  // Tactics B: Strict Mode (strict: true) -> Instant short-circuits upon hitting the first structural error
  final Result<List<AppNotification>> strictResult =
      ResultCollection.mapList<Map<String, dynamic>, AppNotification>(
    rawJsonFeed,
    (json) => Result.guard(() => AppNotification.fromMap(json)),
    strict: true,
  );

  strictResult.fold(
    onSuccess: (_) {},
    onFailure: (failure) {
      if (kDebugMode) {
        print('Strict MapList Short-Circuited as expected: ${failure.message}');
      }
    },
  );
}

// /// Demonstrates [ResultExecutor] managing full async flat-mapping lifecycles with built-in telemetry logs.
// Future<Result<User>> _monitoredProfileFetchContext() async {
//   // Instantiate an executor hooked to the core engine logger
//   final executor = Resultex.executor;
//   final repository = DashboardRepository();
//
//   // Seamlessly logs execution states, traces lifecycle boundaries and prevents nested Result<Result<T>> wrappers
//   return await executor.executeAsync<User>(
//     () => repository.fetchUserProfile(),
//     context: 'FetchUserProfileSecurityScope',
//   );
// }

// =========================================================================
// 1. Mock Domain Models
// =========================================================================

class User {
  final String name;

  const User(this.name);
}

class AppNotification {
  final String title;

  const AppNotification(this.title);

  /// Factory constructor to demonstrate parsing faults
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('title') || map['title'] == null) {
      throw FormatException(
          'Missing structural parameter [title] inside notification map instance.');
    }
    return AppNotification(map['title'] as String);
  }
}

class CryptoWallet {
  final double balance;

  const CryptoWallet(this.balance);
}

// =========================================================================
// 2. Mock Repository Implementation
// =========================================================================

class DashboardRepository {
  Future<Result<User>> fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(const User('Hassan'));
  }

  Future<Result<List<AppNotification>>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success([const AppNotification('New Login Detected')]);
  }

  Future<Result<CryptoWallet>> fetchCryptoWallet() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Result.success(const CryptoWallet(1.25));
  }

  /// A raw primitive Future method simulating standard library responses without Result wrappers
  Future<CryptoWallet> fetchRawExternalWallet() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const CryptoWallet(94.72);
  }
}
