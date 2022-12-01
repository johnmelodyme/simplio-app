import 'package:flutter/material.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';

class SioScaffold extends StatelessWidget {
  const SioScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.backgroundGradient,
  }) : assert(
          backgroundGradient == null || backgroundColor == null,
          'Cannot provide both a backgroundGradient and a backgroundColor\n',
        );

  final AppBar? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final BackgroundGradient? backgroundGradient;

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      backgroundColor: backgroundGradient != null
          ? SioColors.transparent
          : SioColors.softBlack,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    if (backgroundGradient != null) {
      scaffold = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.center,
              colors: getStatusBarGradientColors(backgroundGradient!),
            ),
          ),
          child: SafeArea(child: scaffold));
    }

    return scaffold;
  }

  List<Color> getStatusBarGradientColors(BackgroundGradient statusBarGradient) {
    switch (statusBarGradient) {
      case BackgroundGradient.backGradientDark4:
        return [
          SioColorsDark.backGradient4Start,
          SioColorsDark.softBlack,
        ];
    }
  }
}

enum BackgroundGradient {
  backGradientDark4,
}
