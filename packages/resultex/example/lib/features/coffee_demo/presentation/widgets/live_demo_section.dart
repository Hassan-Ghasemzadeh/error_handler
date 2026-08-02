import 'package:example/core/constants/app_strings.dart';
import 'package:example/features/coffee_demo/presentation/widgets/status_monitor_panel.dart';
import 'package:flutter/material.dart';
import 'feature_cards_section.dart';
import 'how_it_works_section.dart';
import 'installation_section.dart';
import 'mobile_mock_up.dart';

/// Responsive section displaying the live demo showcase, including the status panel,
/// mobile mockup, feature overview, installation steps, and code walkthrough.
class LiveDemoSection extends StatelessWidget {
  const LiveDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.liveDemoTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;

                if (isDesktop) {
                  return const Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: StatusMonitorPanel(),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: MobileMockup(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      FeatureCardsSection(),
                      SizedBox(height: 40),
                      InstallationSection(),
                      SizedBox(height: 40),
                      HowItWorksSection(),
                    ],
                  );
                }

                return const Column(
                  children: [
                    StatusMonitorPanel(),
                    SizedBox(height: 32),
                    Center(child: MobileMockup()),
                    SizedBox(height: 40),
                    FeatureCardsSection(),
                    SizedBox(height: 40),
                    InstallationSection(),
                    SizedBox(height: 40),
                    HowItWorksSection(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
