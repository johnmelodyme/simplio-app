import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/sign_up_form/sign_up_form_cubit.dart';
import 'package:simplio_app/view/decorations/underlined_text_form_field_decoration.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/password_rules_row.dart';
import 'package:simplio_app/view/widgets/password_text_field.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/sio_text_form_field.dart';
import 'package:sio_glyphs/sio_icons.dart';

class SignUpScreen extends StatelessWidget with PopupDialogMixin {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return BlocListener<SignUpFormCubit, SignUpFormState>(
      listenWhen: ((prev, curr) => prev.response != curr.response),
      listener: (context, state) {
        final r = state.response;

        if (r is SignUpFormSuccess) {
          context
              .read<AuthBloc>()
              .add(GotAuthenticated(accountId: r.account.id));
        }

        if (r is SignUpFormFailure) {
          showError(context, message: state.response!.props.first.toString());
        }
      },
      child: SioScaffold(
        body: SafeArea(
          top: true,
          child: BackGradient4(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: [
                      ColorizedAppBar(
                          key: const Key('sign-in-screen-app-bar-button'),
                          firstPart: context
                              .locale.sign_up_screen_create_new_account_sign_up,
                          secondPart: context.locale
                              .sign_up_screen_create_new_account_with_email),
                      Padding(
                        padding: Paddings.horizontal20,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: Paddings.vertical20,
                                child: SioTextFormField(
                                  key: const Key(
                                      'sign-up-screen-email-text-field'),
                                  autofocus: true,
                                  validator: (email) => context
                                      .read<SignUpFormCubit>()
                                      .state
                                      .login
                                      .emailValidator(
                                        email,
                                        errorMessage: context.locale
                                            .common_email_validation_error,
                                      ),
                                  cursorColor: SioColorsDark.whiteBlue,
                                  focusedStyle: SioTextStyles.bodyPrimary
                                      .apply(color: SioColorsDark.whiteBlue),
                                  unfocusedStyle: SioTextStyles.bodyPrimary
                                      .apply(color: SioColorsDark.secondary7),
                                  decoration: UnderLinedTextFormFieldDecoration(
                                    labelText: context.locale
                                        .sign_up_screen_create_account_your_email_label,
                                    hintText: context.locale
                                        .sign_up_screen_create_account_your_email_label,
                                  ),
                                  onChanged: (String? email) {
                                    formKey.currentState?.validate();
                                    context
                                        .read<SignUpFormCubit>()
                                        .changeFormValue(login: email);
                                  },
                                  onFocusChange: (focused) {
                                    focused
                                        ? null
                                        : formKey.currentState?.validate();
                                  },
                                ),
                              ),
                              PasswordTextField(
                                key: const Key(
                                    'sign-up-screen-password-text-field'),
                                passwordComplexityCondition: (pass) => context
                                    .read<SignUpFormCubit>()
                                    .state
                                    .password
                                    .isValid,
                                onChanged: (password) {
                                  formKey.currentState?.validate();
                                  context
                                      .read<SignUpFormCubit>()
                                      .changeFormValue(password: password);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gaps.gap20,
                      Padding(
                        padding: Paddings.horizontal20,
                        child: BlocBuilder<SignUpFormCubit, SignUpFormState>(
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, state) => Column(
                            children: [
                              PasswordRulesRow(
                                  key: const Key(
                                      'sign-up-screen-length-password-rule'),
                                  text: context.locale
                                      .common_password_rule_atleast_8_chars,
                                  passed:
                                      state.password.missingValue['length'] ??
                                          false),
                              PasswordRulesRow(
                                  key: const Key(
                                      'sign-up-screen-number-password-rule'),
                                  text: context
                                      .locale.common_password_rule_num_char,
                                  passed: state.password
                                          .missingValue['numberChar'] ??
                                      false),
                              PasswordRulesRow(
                                  key: const Key(
                                      'sign-up-screen-special-char-password-rule'),
                                  text: context
                                      .locale.common_password_rule_special_char,
                                  passed: state.password
                                          .missingValue['specialChar'] ??
                                      false),
                              PasswordRulesRow(
                                  key: const Key(
                                      'sign-up-screen-upper-char-password-rule'),
                                  text: context
                                      .locale.common_password_rule_upper_char,
                                  passed: state
                                          .password.missingValue['upperChar'] ??
                                      false),
                            ],
                          ),
                        ),
                      ),
                      Gaps.gap20,
                      Padding(
                        padding: Paddings.horizontal16,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child:
                                  BlocBuilder<SignUpFormCubit, SignUpFormState>(
                                builder: (context, state) {
                                  return HighlightedElevatedButton(
                                    key: const Key(
                                      'sign-up-screen-disabled-sign-up-button',
                                    ),
                                    onPressed: state.isValid
                                        ? () {
                                            context
                                                .read<SignUpFormCubit>()
                                                .submitForm();
                                          }
                                        : null,
                                    label: context.locale.common_continue,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.gap20,
                      Padding(
                        padding: Paddings.horizontal16,
                        child: GestureDetector(
                          child: Row(
                            key: const Key('sign-up-screen-log-in-button'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.locale
                                    .sign_up_screen_create_account_already_have_account,
                                style: SioTextStyles.bodyPrimary.copyWith(
                                    color: SioColorsDark.secondary7, height: 1),
                              ),
                              Gaps.gap8,
                              Text(
                                context.locale.common_log_in_button_label,
                                style: SioTextStyles.bodyPrimary.copyWith(
                                  color: SioColorsDark.mentolGreen,
                                  height: 1,
                                ),
                              ),
                              const Icon(
                                SioIcons.arrow_right,
                                size: 14,
                                color: SioColorsDark.mentolGreen,
                              ),
                            ],
                          ),
                          onTap: () {
                            GoRouter.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
