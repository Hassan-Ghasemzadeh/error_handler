import 'package:example/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/coffee_bloc/coffee_bloc.dart';

/// A panel component that displays state monitoring UI via [CoffeeBloc]
/// and presents documentation and usage examples for `Resultx`.
class StatusMonitorPanel extends StatelessWidget {
  const StatusMonitorPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================================================
        // Section 1: Status Monitor Card (Triggers BLoC & Shows State)
        // =========================================================
        _StatusMonitorCard(),
        const SizedBox(height: 20),

        // =========================================================
        // Section 2: Resultx Documentation & Code Example Card
        // =========================================================
        _IdeSimulationWindow(),
      ],
    );
  }
}

class _IdeSimulationWindow extends StatelessWidget {
  const _IdeSimulationWindow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Library Header
          const Text(
            'Resultx',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Feature 1: Request Handling
          const Text(
            AppStrings.requestHandlingTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.requestHandlingDesc,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Feature 2: Safe Result Mapping
          const Text(
            AppStrings.safeResultMappingTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.safeResultMappingDesc,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Simulated IDE Code Window
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Code Window Header Bar (Traffic light buttons & File name)
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      AppStrings.exampleRepoFileName,
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Syntax-Highlighted Code Content
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: AppStrings.font,
                      fontSize: 12,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '// 1. Define a function that explicitly handles errors\n',
                        style: TextStyle(color: Color(0xFF8B949E)),
                      ),
                      TextSpan(
                        text: 'Result',
                        style: TextStyle(
                          color: Color(0xFF79C0FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '<User> ',
                        style: TextStyle(color: Color(0xFFFFA657)),
                      ),
                      TextSpan(
                        text: 'getUserProfile',
                        style: TextStyle(color: Color(0xFFD2A8FF)),
                      ),
                      TextSpan(
                        text: '() async {\n  ',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: 'final',
                        style: TextStyle(color: Color(0xFFFF7B72)),
                      ),
                      TextSpan(
                        text: ' user = ',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: 'await',
                        style: TextStyle(color: Color(0xFFFF7B72)),
                      ),
                      TextSpan(
                        text: ' api.fetchUser();\n  ',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: 'return',
                        style: TextStyle(color: Color(0xFFFF7B72)),
                      ),
                      TextSpan(
                        text: ' Result.success(user);\n}\n\n',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: '// Flow-control using smooth fold pattern\n',
                        style: TextStyle(color: Color(0xFF8B949E)),
                      ),
                      TextSpan(
                        text: 'result.',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: 'fold',
                        style: TextStyle(color: Color(0xFFD2A8FF)),
                      ),
                      TextSpan(
                        text: '(\n  onSuccess: (data) => ',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: 'print',
                        style: TextStyle(color: Color(0xFFD2A8FF)),
                      ),
                      TextSpan(
                        text: '("Success"),\n  onFailure: (error) => ',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                      TextSpan(
                        text: 'print',
                        style: TextStyle(color: Color(0xFFD2A8FF)),
                      ),
                      TextSpan(
                        text: '("Failure"),\n);',
                        style: TextStyle(color: Color(0xFFC9D1D9)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMonitorCard extends StatelessWidget {
  const _StatusMonitorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Panel Title
          const Text(
            AppStrings.statusMonitorTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // CTA Button: Triggers the fetch coffees event in BLoC
          InkWell(
            onTap: () {
              context.read<CoffeeBloc>().add(FetchCoffeesRequested());
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                AppStrings.statusMonitorDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dynamic Status Indicator listening to CoffeeBloc
          BlocBuilder<CoffeeBloc, CoffeeState>(
            builder: (context, state) {
              Color statusColor = Colors.white;
              String statusText = AppStrings.statusMonitorInitial;

              // Map BLoC status to colors and texts
              if (state.status == CoffeeStatus.initial) {
                statusColor = Colors.amber;
                statusText = AppStrings.statusMonitorLoading;
              } else if (state.status == CoffeeStatus.success) {
                statusColor = Colors.green;
                statusText = AppStrings.statusMonitorSuccess;
              } else if (state.status == CoffeeStatus.failure) {
                statusColor = AppTheme.errorRed;
                statusText = AppStrings.statusMonitorFailure;
              }

              return Row(
                children: [
                  // Status Dot Indicator with dynamic glow effect
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Status Text
                  Expanded(
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
