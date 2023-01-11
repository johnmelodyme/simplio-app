import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/cubit/sign_up_form/sign_up_form_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/unauthenticated_screens/sign_up_screen.dart';

class SignUpRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'sign-up';
  static const path = 'sign-up';

  const SignUpRoute({
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
          create: (context) => SignUpFormCubit.builder(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          child: SignUpScreen(),
        ),
      ),
    );
  }
}
