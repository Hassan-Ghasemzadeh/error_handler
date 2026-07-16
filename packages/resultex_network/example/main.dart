import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:resultex_network/resultex_network.dart';

void main() {
  runApp(const MyApp());
}

/// Initialize the Dio client with the [ResultexDioInterceptor].
/// This intercepts raw network errors (timeouts, 4xx, 5xx) and transforms
/// them into domain-safe [Failure] objects automatically.
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
  ..interceptors.add(ResultexDioInterceptor());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ProfileScreen());
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Simulates an API call to fetch a user profile.
  /// The [.guard()] extension handles the try-catch block internally,
  /// wrapping the response or any potential network exception into a [Result].
  Future<Result<String>> fetchUser() async {
    return dio.get('/profile').guard((data) => data['name'] as String);
  }

  /// Holds the state of the network request.
  Result<String>? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Execute the request and update the UI state
                final res = await fetchUser();
                setState(() => _result = res);
              },
              child: const Text('Fetch Profile'),
            ),
            const SizedBox(height: 20),

            // Declarative UI state handling using ResultSwitch
            if (_result != null)
              ResultSwitch(
                result: _result!,
                // Handles success state
                onSuccess: (name, _) => Text(
                  'Welcome, $name!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Handles all failure states (mapped via interceptor)
                onFailure: (context, failure) => Text(
                  'Error: ${failure.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                // Handles the loading state
                onLoading: (context) => const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
