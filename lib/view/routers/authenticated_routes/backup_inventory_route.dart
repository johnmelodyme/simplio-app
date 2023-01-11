import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/password_change_form/password_change_form_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/guards/protected_guard.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/authenticated_screens/backup_inventory_screen.dart';
import 'package:simplio_app/view/widgets/lock_with_shadow_icon.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';

class BackupInventoryRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'backup-inventory';
  static const path = 'backup';

  const BackupInventoryRoute({
    required super.navigator,
    super.routes,
  });

  @override
  GoRoute get route {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: navigator,
      routes: routes,
      pageBuilder: pageBuilder(
        withTransition: false,
        builder: (state) => BlocProvider(
          create: (context) => PasswordChangeFormCubit.builder(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          child: Builder(builder: (context) {
            return ProtectedGuard(
              icon: const LockWithShadowIcon(),
              title: context.locale.protected_guard_enter_pin_code,
              protectedBuilder: (_) => const BackupInventoryScreen(),
              onPrevent: (context) {
                context.read<AuthBloc>().add(
                      const GotUnauthenticated(),
                    );
              },
            );
          }),
        ),
      ),
    );
  }
}
