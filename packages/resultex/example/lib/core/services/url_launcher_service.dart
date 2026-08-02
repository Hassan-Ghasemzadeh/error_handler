/// Abstract contract defining methods for interacting with external platforms via URL launching,
/// deep links, phone calls, and email protocols.
abstract class UrlLauncherService {
  /// Opens a web URL in an external browser or in-app web view.
  ///
  /// Returns `true` if the URL was launched successfully.
  Future<bool> openWeb(String url, {bool inApp = false});

  /// Opens the device's default email client pre-filled with an optional [subject] and [body].
  ///
  /// Returns `true` if the email application was opened successfully.
  Future<bool> openEmail(String email, {String? subject, String? body});

  /// Opens the device dialer with the specified [phoneNumber].
  ///
  /// Returns `true` if the phone dialer was launched successfully.
  Future<bool> callPhone(String phoneNumber);

  /// Launches an external app or deep link using a [customScheme].
  ///
  /// Returns `true` if the custom URI scheme was handled successfully.
  Future<bool> openApp(String customScheme);
}
