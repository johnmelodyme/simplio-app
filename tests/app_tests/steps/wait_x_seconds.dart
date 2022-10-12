import 'dart:io';

import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget with exact tooltip.
///
/// Examples:
///
///   `Then I wait "number of" seconds'

StepDefinitionGeneric waitXSeconds() {
  return when1<int, FlutterWorld>(
    RegExp(r'I wait {int} seconds'),
    (secondsCount, context) async {
      sleep(Duration(seconds: secondsCount));
    },
  );
}
