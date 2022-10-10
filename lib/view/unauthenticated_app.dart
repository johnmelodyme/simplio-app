import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/data/model/account_settings.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/routes/unauthenticated_router.dart';

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
}
