import 'package:example/core/services/url_launcher_service.dart';
import 'package:resultex/resultex.dart';
import 'package:url_launcher/url_launcher.dart';

/// Concrete implementation of [UrlLauncherService] utilizing the `url_launcher` package
/// integrated with `resultex` for safe asynchronous execution and error handling.
class UrlLauncherServiceImpl implements UrlLauncherService {
  late final ResultExecutor _executor;

  UrlLauncherServiceImpl() {
    _executor = Resultex.executor;
  }

  /// Private helper method to handle URL launching safely inside a [ResultExecutor] pipeline.
  Future<bool> _launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final result = await _executor.executeAsync<bool>(
      () async {
        if (await canLaunchUrl(uri)) {
          return await launchUrl(uri, mode: mode);
        }
        return false;
      },
    );

    return result.valueOrNull ?? false;
  }

  @override
  Future<bool> openWeb(String url, {bool inApp = false}) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    return await _launch(
      uri,
      mode: inApp ? LaunchMode.inAppWebView : LaunchMode.externalApplication,
    );
  }

  @override
  Future<bool> openEmail(String email, {String? subject, String? body}) async {
    // Construct URI query parameters safely for email clients
    final String query = [
      if (subject != null) 'subject=${Uri.encodeComponent(subject)}',
      if (body != null) 'body=${Uri.encodeComponent(body)}',
    ].join('&');

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: query.isEmpty ? null : query,
    );

    return await _launch(uri);
  }

  @override
  Future<bool> callPhone(String phoneNumber) async {
    final uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    return await _launch(uri);
  }

  @override
  Future<bool> openApp(String customScheme) async {
    final uri = Uri.parse(customScheme);
    return _launch(uri, mode: LaunchMode.externalApplication);
  }
}
