import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import './steps/click_button_with_key.dart';
import './steps/click_button_with_tooltip.dart';
import './steps/wait_x_seconds.dart';
import './steps/text_exists_step_with_time.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r'tests/app_tests/features/**.feature')]
    ..reporters = [
      StdoutReporter(MessageLevel.error),
      ProgressReporter(),
      TestRunSummaryReporter(),
      StdoutReporter(MessageLevel.verbose),
      JsonReporter(path: 'tests/app_tests/cucumber-report-android.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [
      tapWidgetWithTooltip(),
      tapWidgetWithTheKey(),
      waitXSeconds(),
      textExistsWithTimeStep(),
    ]
    ..targetAppPath = "tests/app_tests/app.dart"
    ..dartDefineArgs = ['TEST_RUN=true']
    ..hooks = [AttachScreenshotOnFailedStepHook()]
    // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
    ..restartAppBetweenScenarios =
        true // set to false if debugging to exit cleanly
    ..buildFlavor = 'dev'
    ..flutterBuildTimeout = const Duration(seconds: 600);
  return GherkinRunner().execute(config);
}
