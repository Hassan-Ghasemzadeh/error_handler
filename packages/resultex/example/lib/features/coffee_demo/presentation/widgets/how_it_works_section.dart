import 'package:example/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A reusable window container component styled like a macOS code editor frame.
class CodeWindowDisplay extends StatelessWidget {
  final String fileName;
  final Widget codeContent;

  const CodeWindowDisplay({
    super.key,
    required this.fileName,
    required this.codeContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // macOS window action dots (red, yellow, green) and active file header tab
          Row(
            children: [
              _buildDot(const Color(0xFFFF5F56)),
              const SizedBox(width: 8),
              _buildDot(const Color(0xFFFFBD2E)),
              const SizedBox(width: 8),
              _buildDot(const Color(0xFF27C93F)),
              const SizedBox(width: 16),
              Text(
                fileName,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontFamily: AppStrings.font,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Horizontally scrollable code presentation container
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: codeContent,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Section widget presenting code execution walkthroughs with custom syntax highlighting.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.howItWorksTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.howItWorksDescription,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          CodeWindowDisplay(
            fileName: AppStrings.codeFileName,
            codeContent: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppStrings.font,
                  fontSize: 14,
                  height: 1.5,
                  color: const Color(0xFFC9D1D9),
                ),
                children: const [
                  TextSpan(
                    text: 'Future<',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(
                    text: 'Result<List<CoffeeEntity>>',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(text: '> '),
                  TextSpan(
                    text: 'getHotCoffees',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '() '),
                  TextSpan(
                    text: 'async ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(text: '{\n'),
                  TextSpan(
                    text: '  return ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(text: '_executor.'),
                  TextSpan(
                    text: 'executeAsync',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(
                    text: '<',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(
                    text: 'List<CoffeeEntity>',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(text: '>(\n'),
                  TextSpan(text: '    () '),
                  TextSpan(
                    text: 'async ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(text: '{\n'),
                  TextSpan(
                    text: '      final ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(text: 'models = '),
                  TextSpan(
                    text: 'await ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(text: 'remoteDataSource.'),
                  TextSpan(
                    text: 'fetchHotCoffees',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '();\n'),
                  TextSpan(
                    text: '      final ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(text: 'entities = models.'),
                  TextSpan(
                    text: 'map',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '((m) => m.'),
                  TextSpan(
                    text: 'toEntity',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '()).'),
                  TextSpan(
                    text: 'toList',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '();\n'),
                  TextSpan(
                    text: '      return ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(
                    text: 'Result.',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(
                    text: 'success',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '(entities);\n    },\n  ).'),
                  TextSpan(
                    text: 'catchError',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '(\n    (error, stackTrace) {\n'),
                  TextSpan(
                    text: '      return ',
                    style: TextStyle(color: Color(0xFFFF7B72)),
                  ),
                  TextSpan(
                    text: 'Result.',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(
                    text: 'failure',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(text: '(\n'),
                  TextSpan(
                    text: '        Failure',
                    style: TextStyle(color: Color(0xFF79C0FF)),
                  ),
                  TextSpan(text: '(\n'),
                  TextSpan(text: '          message: error.'),
                  TextSpan(
                    text: 'toString',
                    style: TextStyle(color: Color(0xFFD2A8FF)),
                  ),
                  TextSpan(
                    text:
                        '(),\n          stackTrace: stackTrace,\n          error: error,\n        ),\n      );\n    },\n  );\n}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
