import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/dark_mode.dart';
import 'package:simplio_app/view/themes/light_mode.dart';

class SplashScreen extends StatelessWidget {
  final Future<void> Function() loadingFunction;
  final VoidCallback onLoaded;

  const SplashScreen({
    super.key,
    required this.loadingFunction,
    required this.onLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: loadingFunction().then(((_) => onLoaded())),
        builder: (context, snapshot) {
          // since we support only dark theme now we set proper system bar color here
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

          // we need to use another MaterialApp widget for correct display of
          // this page. Only one of these widgets is displayed at any time
          return MaterialApp(
            title: 'Simplio',
            themeMode: defaultThemeMode,
            theme: LightMode.theme,
            darkTheme: DarkMode.theme,
            home: Builder(
              builder: (context) => Scaffold(
                body: SafeArea(
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/icon/icon_blue.png',
                            width: 48,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Simplio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.fontSize),
                          ),
                        ],
                      ),
                      Padding(
                        padding: Paddings.vertical20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 3,
                              width: 220,
                              child: LinearProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor:
                                    Theme.of(context).highlightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: Paddings.bottom20,
                          child: Text('Built with Flutter 3'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
