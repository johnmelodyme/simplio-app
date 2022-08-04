import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/sign_in_form/sign_in_form_cubit.dart';
import 'package:simplio_app/view/routes/unauthenticated_router.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/widgets/password_text_field.dart';
import 'package:simplio_app/view/widgets/text_header.dart';
import 'package:simplio_app/view/widgets/themed_text_form_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocListener<SignInFormCubit, SignInFormState>(
      listener: (context, state) {
        final res = state.response;

        if (res is SignInFormSuccess) {
          context
              .read<AuthBloc>()
              .add(GotAuthenticated(accountId: res.account.id));
        }

        if (res is SignInFormFailure) {
          //  TODO: Implement logic for failure.
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          key: const Key('sign-in-screen-app-bar-button'),
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: CommonTheme.horizontalPadding,
                    child: TextHeader(
                      title: context.locale.loginScreenTitle,
                      subtitle: context.locale.loginScreenSubTitle,
                    ),
                  ),
                  Padding(
                    padding: CommonTheme.horizontalPadding,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: CommonTheme.verticalPadding,
                            child: ThemedTextFormFiled(
                              key: const Key('sign-in-screen-email-text-field'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (email) => context
                                  .read<SignInFormCubit>()
                                  .state
                                  .login
                                  .emailValidator(
                                    email,
                                    errorMessage:
                                        context.locale.emailValidationError,
                                  ),
                              decoration: InputDecoration(
                                labelText: context.locale.email,
                                hintText: context.locale.email,
                              ),
                              onChanged: (String? email) {
                                context
                                    .read<SignInFormCubit>()
                                    .changeFormValue(login: email);
                              },
                              onFocusChange: (focused) => focused
                                  ? null
                                  : formKey.currentState?.validate(),
                            ),
                          ),
                          PasswordTextField(
                            key:
                                const Key('sign-in-screen-password-text-field'),
                            validator: (pass) => context
                                .read<SignInFormCubit>()
                                .state
                                .password
                                .passwordValidator(
                                  pass,
                                  errorMsg:
                                      context.locale.passwordValidationError,
                                ),
                            passwordComplexityCondition: (_) => context
                                .read<SignInFormCubit>()
                                .state
                                .password
                                .isValid,
                            onChanged: (password) {
                              context
                                  .read<SignInFormCubit>()
                                  .changeFormValue(password: password);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 20, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        final res =
                            context.read<SignInFormCubit>().state.response;
                        if (res is! SignInFormPending) {
                          GoRouter.of(context).pushNamed('password-reset');
                        }
                      },
                      child: Text(
                        key: const Key('sign-in-screen-reset-password-button'),
                        context.locale.forgotPasswordButtonLabel,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  Padding(
                    padding: CommonTheme.horizontalPadding,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<SignInFormCubit, SignInFormState>(
                            builder: (context, state) {
                              if (state.response != null) {
                                final res = state.response;
                                if (res is SignInFormPending) {
                                  return OutlinedButton(
                                    key: const Key(
                                        'sign-in-screen-progress-indicator'),
                                    onPressed: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: CommonTheme.paddingAll,
                                          child: Text(
                                            context.locale.signingInLabel,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }
                              return ElevatedButton(
                                key: const Key('sign-in-screen-sign-in-button'),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await context
                                        .read<SignInFormCubit>()
                                        .submitForm();
                                  }
                                },
                                child: Text(context.locale.signInButtonLabel),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: Text(
                              key: const Key(
                                  'sign-in-screen-create-account-button'),
                              context.locale.orCreateAccountButtonLabel,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            onTap: () {
                              final res = context
                                  .read<SignInFormCubit>()
                                  .state
                                  .response;
                              if (res is! SignInFormPending) {
                                GoRouter.of(context)
                                    .pushNamed(UnauthenticatedRouter.signUp);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
