import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import './steps/click_button_with_key.dart';
import './steps/click_button_with_tooltip.dart';
import './steps/wait_x_seconds.dart';
import './steps/text_exists_step_with_time.dart';

Future<void> main() {
  Map<String, String> envVars = Platform.environment;
  final String? apiUrl = envVars['API_URL'];
  final String? apiKey = envVars['API_KEY'];
  final config = FlutterTestConfiguration()
    ..features = [Glob(r'tests/app_tests/features/**.feature')]
    ..reporters = [
      StdoutReporter(MessageLevel.error),
      ProgressReporter(),
      TestRunSummaryReporter(),
      StdoutReporter(MessageLevel.verbose),
      JsonReporter(path: 'tests/app_tests/cucumber-report-ios.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [
      tapWidgetWithTooltip(),
      tapWidgetWithTheKey(),
      waitXSeconds(),
      textExistsWithTimeStep(),
    ]
    ..targetAppPath = "tests/app_tests/app.dart"
    ..dartDefineArgs = ['TEST_RUN=true', 'API_URL=$apiUrl', 'API_KEY=$apiKey']
    ..hooks = [AttachScreenshotOnFailedStepHook()]
    ..tagExpression = "not @blockedByBug"
    // ..tagExpression = "@smoke"
    ..restartAppBetweenScenarios =
        true // set to false if debugging to exit cleanly
    ..order = ExecutionOrder.alphabetical
    ..flutterBuildTimeout = const Duration(seconds: 600);
  return GherkinRunner().execute(config);
}
