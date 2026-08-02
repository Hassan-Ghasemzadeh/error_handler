/// A utility class that holds all hardcoded strings for the app.
/// This class is final and has a private constructor to prevent
/// instantiation and extension.
final class AppStrings {
  AppStrings._();

  // ==========================================
  // Global & URLs
  // ==========================================
  static const String appName = 'Resultex Live Demo';
  static const String apiBaseUrl = 'https://api.sampleapis.com';
  static const String gitLogoUrl =
      'https://raw.githubusercontent.com/Hassan-Ghasemzadeh/error_handler/main/docs/assets/github.png';
  static const String pubDevUrl = 'https://pub.dev/packages/resultex';
  static const String resultexGitHubUrl =
      'https://github.com/Hassan-Ghasemzadeh/error_handler/tree/main';
  static const String exampleGitHubUrl =
      'https://github.com/Hassan-Ghasemzadeh/error_handler/tree/main/packages/resultex/example';
  static const String font = 'monospace';
  static const String sourceCode = 'Source Code';

  // ==========================================
  // Hero Section
  // ==========================================
  static const String dartTitle =
      'Dart 3 Records & Pattern Matching Fully Supported';
  static const String resultexTitle = 'Resultex';
  static const String resultexDescription =
      'An elegant, type-safe, and highly expressive functional error handling pattern for Dart and Flutter. Stop throwing exceptions, start handling results.';
  static const String pubDevBtn = 'View on Pub.dev';
  static const String gitHubBtn = 'GitHub Repository';

  // ==========================================
  // Features Section
  // ==========================================
  static const String featureOneTitle = 'Functional Architecture';
  static const String featureOneDescription =
      'Encapsulate Success data and Failures into explicit types. Avoid runtime crashes caused by unhandled implicit exceptions.';

  static const String featureTwoTitle = 'Clean Architecture Ready';
  static const String featureTwoDescription =
      'Designed specifically to protect Use Cases and Repositories. Data issues bubble them up cleanly to your BLoC/Cubit.';

  static const String featureThreeTitle = 'Zero Dependencies';
  static const String featureThreeDescription =
      'Ultra lightweight, performant, and completely dependency-free. Blends seamlessly into any standard Dart or Flutter codebase.';

  // ==========================================
  // Installation & How It Works
  // ==========================================
  static const String installTitle = 'Installation';
  static const String installDescription =
      'Add Resultex to your Flutter project with a single command:';
  static const String installCommand = 'flutter pub add resultex';

  static const String howItWorksTitle = 'How it works?';
  static const String howItWorksDescription =
      'Replace error-prone try-catch blocks with clear, declarative code flow control.';
  static const String codeFileName = 'coffee_repository_impl.dart';
  static const String exampleRepoFileName = 'example_repository.dart';

  // ==========================================
  // Documentation & Explanations
  // ==========================================
  static const String requestHandlingTitle = 'Request Handling';
  static const String requestHandlingDesc =
      'Resultx is an encapsulated error-free request and response utility for handling operations safely, parsing data, and recommending best practices in your apps.';

  static const String safeResultMappingTitle = 'Safe Result Mapping';
  static const String safeResultMappingDesc =
      'The code challenges error handling by returning results in the coffee demo.';

  // ==========================================
  // Live Demo Section
  // ==========================================
  static const String liveDemoTitle = 'Live Demo: Coffee Explorer';
  static const String mobileTitle = 'Resultx Coffee Shop';
  static const String initialStateMessage = 'Tap "Fetch" to load data';
  static const String noDataMessage = 'No coffees available.';

  // ==========================================
  // Status Monitor
  // ==========================================
  static const String statusMonitorTitle = 'Status Monitor';
  static const String statusMonitorDescription =
      'Fetch Hot Coffees (api.sampleapis.com)';
  static const String statusMonitorInitial = 'Status: Idle / Ready';
  static const String statusMonitorLoading = 'Status: Loading...';
  static const String statusMonitorSuccess = 'Success: 200 OK';
  static const String statusMonitorFailure = 'Failed to fetch';
}
