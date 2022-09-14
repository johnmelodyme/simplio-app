import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/sign_up_form/sign_up_form_cubit.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/widgets/password_rules_row.dart';
import 'package:simplio_app/view/widgets/password_text_field.dart';
import 'package:simplio_app/view/widgets/text_header.dart';
import 'package:simplio_app/view/widgets/themed_text_form_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocListener<SignUpFormCubit, SignUpFormState>(
      listener: (context, state) {
        final r = state.response;

        if (r is SignUpFormSuccess) {
          context
              .read<AuthBloc>()
              .add(GotAuthenticated(accountId: r.account.id));
        }

        if (r is SignUpFormFailure) {
          //  TODO: Implement logic for failure.
        }
      },
      // TODO - FIX - There is constrains when keyboard is on.
      child: Scaffold(
        appBar: AppBar(
          key: const Key('sign-up-screen-app-bar-button'),
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: CommonTheme.paddingAll,
                    child: TextHeader(
                      title: context
                          .locale.sign_up_screen_create_new_account_title,
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
                              key: const Key('sign-up-screen-email-text-field'),
                              autofocus: true,
                              validator: (email) => context
                                  .read<SignUpFormCubit>()
                                  .state
                                  .login
                                  .emailValidator(
                                    email,
                                    errorMessage: context
                                        .locale.common_email_validation_error,
                                  ),
                              decoration: InputDecoration(
                                labelText: context.locale.common_email,
                                hintText: context.locale.common_email,
                              ),
                              onChanged: (String? email) {
                                context
                                    .read<SignUpFormCubit>()
                                    .changeFormValue(login: email);
                              },
                              onFocusChange: (focused) => focused
                                  ? null
                                  : formKey.currentState?.validate(),
                            ),
                          ),
                          PasswordTextField(
                            key:
                                const Key('sign-up-screen-password-text-field'),
                            passwordComplexityCondition: (pass) => context
                                .read<SignUpFormCubit>()
                                .state
                                .password
                                .isValid,
                            onChanged: (password) {
                              context
                                  .read<SignUpFormCubit>()
                                  .changeFormValue(password: password);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: CommonTheme.paddingAll,
                    child: BlocBuilder<SignUpFormCubit, SignUpFormState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) => Column(
                        children: [
                          PasswordRulesRow(
                              key: const Key(
                                  'sign-up-screen-length-password-rule'),
                              text: context
                                  .locale.common_password_rule_atleast_8_chars,
                              passed: state.password.missingValue['length'] ??
                                  false),
                          PasswordRulesRow(
                              key: const Key(
                                  'sign-up-screen-number-password-rule'),
                              text:
                                  context.locale.common_password_rule_num_char,
                              passed:
                                  state.password.missingValue['numberChar'] ??
                                      false),
                          PasswordRulesRow(
                              key: const Key(
                                  'sign-up-screen-special-char-password-rule'),
                              text: context
                                  .locale.common_password_rule_special_char,
                              passed:
                                  state.password.missingValue['specialChar'] ??
                                      false),
                          PasswordRulesRow(
                              key: const Key(
                                  'sign-up-screen-upper-char-password-rule'),
                              text: context
                                  .locale.common_password_rule_upper_char,
                              passed:
                                  state.password.missingValue['upperChar'] ??
                                      false),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: CommonTheme.paddingAll,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<SignUpFormCubit, SignUpFormState>(
                            builder: (context, state) {
                              return state.isValid
                                  ? ElevatedButton(
                                      key: const Key(
                                        'sign-up-screen-sign-up-button',
                                      ),
                                      onPressed: () {
                                        context
                                            .read<SignUpFormCubit>()
                                            .submitForm();
                                      },
                                      child: Text(
                                        context.locale
                                            .sign_up_screen_create_account_btn_label,
                                      ),
                                    )
                                  : OutlinedButton(
                                      key: const Key(
                                        'sign-up-screen-disabled-sign-up-button',
                                      ),
                                      onPressed: null,
                                      child: Text(
                                        context.locale
                                            .sign_up_screen_create_account_btn_label,
                                      ),
                                    );
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
