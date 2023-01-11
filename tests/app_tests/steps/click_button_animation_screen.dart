// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:flutter_gherkin/flutter_gherkin.dart';
// import 'package:gherkin/gherkin.dart';

// /// Taps a widget with exact tooltip.
// ///
// /// Examples:
// ///
// ///   `Then I tap the button with tooltip "String"`

// StepDefinitionGeneric tapWidgetWithTheKeyOnAnimatedScreen() {
//   return when1<String, FlutterWorld>(
//       RegExp(r'I tap the button with the key: {string} on animated screen'),
//       (key, context) async {
//     await context.world.driver!.runUnsynchronized(
//       () async {
//         SerializableFinder finder = find.byValueKey(key);
//         // final finder = find.byValueKey(key);
//         await context.world.driver!.tap(finder);
//       },
//     );
//   });
// }
