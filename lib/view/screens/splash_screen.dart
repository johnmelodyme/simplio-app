import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/logic/cubit/loading/loading_cubit.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/themes/dark_mode.dart';
import 'package:simplio_app/view/themes/light_mode.dart';

class SplashScreen extends StatelessWidget {
  final Future<void> Function() loadingFunction;

  const SplashScreen({super.key, required this.loadingFunction});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: loadingFunction()
            .then((_) => context.read<LoadingCubit>().setSplashScreen(false)),
        builder: (context, snapshot) => _splashScreenWidget(context));
  }

  Widget _splashScreenWidget(BuildContext context) {
    // since we support only dark theme now we set proper system bar color here
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    // we need to use another MaterialApp widget for correct display of
    // this page. Only one of these widgets is displayed at any time
    return MaterialApp(
      title: 'Simplio',
      themeMode: const AccountSettings.preset().themeMode,
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
                  padding: CommonTheme.verticalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 3,
                        width: 220,
                        child: LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: Theme.of(context).highlightColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: CommonTheme.bottomPadding,
                    child: const Text('Built with Flutter 3'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
