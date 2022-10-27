import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

/// Taps a widget that contains text.
///
/// Examples:
///
///   `Then I tap the label that contains the text "Logout" within "10" seconds`
///   `Then I tap the button that contains the text "Sign up" within "10" seconds`
///   `Then I tap the widget that contains the text "My User Profile" within "10" seconds`
StepDefinitionGeneric tapWidgetWithTextWithinTimeStep() {
  return then2<String, int, FlutterWorld>(
    RegExp(
        r'I tap the (?:button|element|label|field|text|widget) that contains the text {string} within {int} second(s)$'),
    (input1, seconds, context) async {
      final finder = find.text(input1);
      await context.world.driver?.scrollIntoView(finder);
      await FlutterDriverUtils.tap(
        context.world.driver,
        finder,
        timeout: Duration(seconds: seconds),
      );
    },
  );
}
