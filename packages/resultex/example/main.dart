import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:resultex/core/utils/result_flutterx_extension.dart';
import 'package:resultex/core/utils/result_utils.dart';
import 'package:resultex/resultex.dart';
import 'package:resultex/src/model/multi_failure.dart';

void main() async {
  // Ensure Flutter binding is initialized if needed before async main operations
  WidgetsFlutterBinding.ensureInitialized();

  // Simulating ecosystem lifecycle initialization
  final loggerBase = Resultex();
  await loggerBase.init();

  if (kDebugMode) {
    print('Resultex core ecosystem successfully initialized.');
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
  // Note: The resolved widget is assigned to a local variable to prevent compiler errors.
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

  // Use the displayWidget down below in your real UI pipeline or layout state setup
  if (kDebugMode) {
    print('UI state successfully mapped to: $displayWidget');
  }
}

// =========================================================================
// 1. Mock Domain Models
// =========================================================================

/// Represents the authenticated profile details payload.
class User {
  final String name;

  const User(this.name);
}

/// Represents an in-app system notice framework instance.
class AppNotification {
  final String title;

  const AppNotification(this.title);
}

/// Represents the secure balance ledger state for cryptocurrencies.
class CryptoWallet {
  final double balance;

  const CryptoWallet(this.balance);
}

// =========================================================================
// 2. Mock Repository Implementation
// =========================================================================

/// A mock remote data source simulating network latency and returning isolated [Result] contracts.
class DashboardRepository {
  /// Fetches user profile data with a simulated network delay.
  Future<Result<User>> fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return SuccessResult(const User('Hassan'));
  }

  /// Fetches system notifications list with a simulated network delay.
  Future<Result<List<AppNotification>>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SuccessResult([const AppNotification('New Login Detected')]);
  }

  /// Fetches digital asset metadata state with a simulated network delay.
  Future<Result<CryptoWallet>> fetchCryptoWallet() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return SuccessResult(const CryptoWallet(1.25));
  }
}
