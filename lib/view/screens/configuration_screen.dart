import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/wallet_connect/wallet_connect_cubit.dart';
import 'package:simplio_app/view/routes/authenticated_router.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        title: Text(context.locale.configuration_screen_settings_title),
      ),
      body: ListView(
        padding: Paddings.vertical20,
        children: [
          ...context
              .watch<WalletConnectCubit>()
              .state
              .sessions
              .entries
              .map<Widget>(
                (e) => ListTile(
                  minVerticalPadding: 20.0,
                  title: Text(e.value.name),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.read<WalletConnectCubit>().closeSession(e.key);
                    },
                    child: const Icon(Icons.link_off),
                  ),
                ),
              )
              .toList(),
          ListTile(
            title: Text(context.locale.configuration_screen_change_password),
            onTap: () {
              GoRouter.of(context)
                  .pushNamed(AuthenticatedRouter.passwordChange);
            },
          ),
          ListTile(
            title: Text(context.locale.configuration_screen_sign_out),
            onTap: () {
              context.read<AuthBloc>().add(const GotUnauthenticated());
            },
          ),
        ],
      ),
    );
  }
}
