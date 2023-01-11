import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/cubit/password_reset_form/password_reset_form_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/unauthenticated_screens/password_reset_screen.dart';

class PasswordResetRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'password-reset';
  static const path = 'password-reset';

  const PasswordResetRoute({
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
        builder: (state) => BlocProvider(
          create: (context) => PasswordResetFormCubit.builder(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          child: const PasswordResetScreen(),
        ),
      ),
    );
  }
}
