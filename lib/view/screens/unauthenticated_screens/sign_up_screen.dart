import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/sign_up_form/sign_up_form_cubit.dart';
import 'package:simplio_app/view/decorations/underlined_text_form_field_decoration.dart';
import 'package:simplio_app/view/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/routers/unauthenticated_routes/sign_in_route.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/password_rules_row.dart';
import 'package:simplio_app/view/widgets/password_text_field.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/sio_text_form_field.dart';
import 'package:sio_glyphs/sio_icons.dart';

class SignUpScreen extends StatelessWidget with PopupDialogMixin {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      resizeToAvoidBottomInset: false,
      backgroundGradient: BackgroundGradient.backGradientDark4,
      body: Stack(
        children: [
          Column(
            children: [
              ColorizedAppBar(
                key: const Key('sign-in-screen-app-bar-button'),
                title: context.locale.sign_up_screen_create_new_account_sign_up,
              ),
              Padding(
                padding: Paddings.horizontal20,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SioTextFormField(
                        textFormKey: _emailFieldKey,
                        controller: _emailEditingController,
                        inputFormatters: [
                          LowerCaseTextFormatter(),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) => context
                            .read<SignUpFormCubit>()
                            .state
                            .login
                            .emailValidator(
                              email,
                              errorMessage:
                                  context.locale.common_email_validation_error,
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
                          context
                              .read<SignUpFormCubit>()
                              .changeFormValue(login: email);
                        },
                        onFocusChange: (focused) {
                          if (!focused &&
                              _emailEditingController.text.isNotEmpty) {
                            _emailEditingController.text =
                                _emailEditingController.text
                                    .toLowerCase()
                                    .trim()
                                    .replaceAll(RegExp(r'\s'), '');

                            _emailFieldKey.currentState?.validate();
                          }
                        },
                        maxLines: 1,
                      ),
                      Gaps.gap10,
                      PasswordTextField(
                        passwordFieldKey: _passwordFieldKey,
                        passwordComplexityCondition: (pass) => context
                            .read<SignUpFormCubit>()
                            .state
                            .password
                            .isValid,
                        onChanged: (password) {
                          context
                              .read<SignUpFormCubit>()
                              .changeFormValue(password: password);
                          _passwordFieldKey.currentState?.validate();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.gap10,
              Padding(
                padding: Paddings.horizontal20,
                child: BlocBuilder<SignUpFormCubit, SignUpFormState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) => Column(
                    children: [
                      PasswordRulesRow(
                          key: const Key('sign-up-screen-length-password-rule'),
                          text: context
                              .locale.common_password_rule_atleast_8_chars,
                          passed:
                              state.password.missingValue['length'] ?? false),
                      Gaps.gap5,
                      PasswordRulesRow(
                          key: const Key('sign-up-screen-number-password-rule'),
                          text: context.locale.common_password_rule_num_char,
                          passed: state.password.missingValue['numberChar'] ??
                              false),
                      Gaps.gap5,
                      PasswordRulesRow(
                          key: const Key(
                              'sign-up-screen-special-char-password-rule'),
                          text:
                              context.locale.common_password_rule_special_char,
                          passed: state.password.missingValue['specialChar'] ??
                              false),
                      Gaps.gap5,
                      PasswordRulesRow(
                          key: const Key(
                              'sign-up-screen-upper-char-password-rule'),
                          text: context.locale.common_password_rule_upper_char,
                          passed: state.password.missingValue['upperChar'] ??
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
                      child: BlocConsumer<SignUpFormCubit, SignUpFormState>(
                        listenWhen: ((prev, curr) =>
                            prev.response != curr.response),
                        listener: (context, state) {
                          final r = state.response;

                          if (r is SignUpFormSuccess) {
                            context
                                .read<AuthBloc>()
                                .add(GotAuthenticated(account: r.account));
                          }

                          if (r is SignUpFormFailure) {
                            showError(context,
                                message:
                                    state.response!.props.first.toString());
                          }
                        },
                        builder: (context, state) {
                          return state.isValid
                              ? HighlightedElevatedButton.primary(
                                  key: const Key(
                                    'sign-up-screen-sign-up-button',
                                  ),
                                  onPressed: context
                                      .read<SignUpFormCubit>()
                                      .submitForm,
                                  label: context.locale.common_continue,
                                )
                              : HighlightedElevatedButton.disabled(
                                  key: const Key(
                                    'sign-up-screen-disabled-sign-up-button',
                                  ),
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
                        context.locale.common_sign_in_button_label,
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
                    GoRouter.of(context).pushReplacementNamed(
                      SignInRoute.name,
                    );
                    // GoRouter.of(context)
                    //     .replaceNamed(UnauthenticatedRouter.signIn);
                  },
                ),
              ),
              Gaps.gap10,
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 3,
                      child: Image.asset(
                        'assets/images/simpliona_login.png',
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 0,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SioColorsDark.vividBlue.withOpacity(0.2),
                    spreadRadius: MediaQuery.of(context).size.width / 4,
                    blurRadius: MediaQuery.of(context).size.width / 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
