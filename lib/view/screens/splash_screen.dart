import 'package:crypto_assets/crypto_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/list_loading.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

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
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

          return MaterialApp(
            home: SioScaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 120),
                        height: 120,
                        width: 10,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: SioColorsDark.mentolGreen.withOpacity(0.1),
                              spreadRadius: RadiusSize.radius140 / 2,
                              blurRadius: RadiusSize.radius140,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: SioColorsDark.vividBlue.withOpacity(0.1),
                              spreadRadius: RadiusSize.radius140 / 2,
                              blurRadius: RadiusSize.radius140,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 34,
                            width: 34,
                            child: AssetIcons.simplio,
                          ),
                          Gaps.gap10,
                          Text(
                            'Simplio',
                            style: SioTextStyles.h1.apply(
                              color: SioColorsDark.whiteBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 76),
                          child: ListLoading(
                            activeColor: SioColorsDark.secondary4,
                            backgroundColor: SioColorsDark.secondary2,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
