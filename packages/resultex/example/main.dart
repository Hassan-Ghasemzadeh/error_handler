import 'package:flutter/foundation.dart';
import 'package:resultex/resultex.dart';

void main() async {
  // Simulating ecosystem lifecycle initialization
  final loggerBase = Resultex();
  await loggerBase.init();

  if (kDebugMode) {
    print('Resultex core ecosystem successfully initialized.');
  }
}
