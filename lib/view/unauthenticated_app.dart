import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/routers/unauthenticated_router.dart';

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
      locale: defaultLocale,
      themeMode: defaultThemeMode,
      routeInformationParser: r.routeInformationParser,
      routeInformationProvider: r.routeInformationProvider,
      routerDelegate: r.routerDelegate,
    );
  }

  void init(BuildContext context) {
    precacheImage(
      Image.asset('assets/images/start_screen1.png').image,
      context,
    );
    precacheImage(
      Image.asset('assets/images/start_screen2.png').image,
      context,
    );
    precacheImage(
      Image.asset('assets/images/start_screen3.png').image,
      context,
    );
  }
}
