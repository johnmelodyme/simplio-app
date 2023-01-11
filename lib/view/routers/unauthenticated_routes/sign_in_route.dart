import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/cubit/sign_in_form/sign_in_form_cubit.dart';
import 'package:simplio_app/view/mixins/page_builder_mixin.dart';
import 'package:simplio_app/view/helpers/application_route.dart';
import 'package:simplio_app/view/screens/unauthenticated_screens/sign_in_screen.dart';

class SignInRoute extends ApplicationRoute with PageBuilderMixin {
  static const name = 'sign-in';
  static const path = 'sign-in';

  const SignInRoute({
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
          create: (context) => SignInFormCubit.builder(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          child: SignInScreen(),
        ),
      ),
    );
  }
}
