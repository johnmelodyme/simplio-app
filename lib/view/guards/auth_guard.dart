import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/models/account.dart';
import 'package:simplio_app/data/models/account_settings.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';

class AuthGuard extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    Account account,
  ) onAuthenticated;
  final WidgetBuilder onUnauthenticated;

  const AuthGuard({
    super.key,
    required this.onAuthenticated,
    required this.onUnauthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is Authenticated) {
          return onAuthenticated(context, state.account);
        }

        if (state is Unauthenticated) {
          return onUnauthenticated(context);
        }

        return MaterialApp(
          key: UniqueKey(),
          title: 'Simplio',
          themeMode: defaultThemeMode,
          home: const SioScaffold(),
        );
      },
    );
  }
}
