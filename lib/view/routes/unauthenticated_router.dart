import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/data/repositories/auth_repository.dart';
import 'package:simplio_app/logic/cubit/password_reset_form/password_reset_form_cubit.dart';
import 'package:simplio_app/logic/cubit/sign_in_form/sign_in_form_cubit.dart';
import 'package:simplio_app/logic/cubit/sign_up_form/sign_up_form_cubit.dart';
import 'package:simplio_app/view/screens/password_reset_screen.dart';
import 'package:simplio_app/view/screens/sign_in_screen.dart';
import 'package:simplio_app/view/screens/sign_up_screen.dart';
import 'package:simplio_app/view/screens/welcome_screen.dart';

class UnauthenticatedRouter {
  static const String home = 'home';
  static const String signIn = 'sing-in';
  static const String signUp = 'sign-up';
  static const String passwordReset = 'password-reset';

  GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: home,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth',
        redirect: (state) => 'sign-in',
        routes: [
          GoRoute(
            path: 'sign-in',
            name: signIn,
            builder: (context, state) => BlocProvider(
              create: (context) => SignInFormCubit.builder(
                authRepository: RepositoryProvider.of<AuthRepository>(context),
              ),
              child: SignInScreen(),
            ),
          ),
          GoRoute(
            path: 'sign-up',
            name: signUp,
            builder: (context, state) => BlocProvider(
              create: (context) => SignUpFormCubit.builder(
                authRepository: RepositoryProvider.of<AuthRepository>(context),
              ),
              child: SignUpScreen(),
            ),
          ),
          GoRoute(
            path: 'password-reset',
            name: passwordReset,
            builder: (context, state) => BlocProvider(
              create: (context) => PasswordResetFormCubit.builder(
                authRepository: RepositoryProvider.of<AuthRepository>(context),
              ),
              child: const PasswordResetScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
