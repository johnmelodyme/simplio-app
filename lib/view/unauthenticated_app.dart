import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/unauthenticated_router.dart';
import 'package:simplio_app/view/themes/dark_mode.dart';
import 'package:simplio_app/view/themes/light_mode.dart';

class UnauthenticatedApp extends StatelessWidget {
  const UnauthenticatedApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final r = UnauthenticatedRouter().router;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp.router(
      key: UniqueKey(),
      onGenerateTitle: (context) => context.locale.simplioTitle,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: const AccountSettings.preset().locale,
      themeMode: const AccountSettings.preset().themeMode,
      theme: LightMode.theme,
      darkTheme: DarkMode.theme,
      routeInformationParser: r.routeInformationParser,
      routeInformationProvider: r.routeInformationProvider,
      routerDelegate: r.routerDelegate,
    );
  }
}
