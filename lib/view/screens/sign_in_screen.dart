import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/bloc/auth/auth_bloc.dart';
import 'package:simplio_app/logic/cubit/sign_in_form/sign_in_form_cubit.dart';
import 'package:simplio_app/view/decorations/underlined_text_form_field_decoration.dart';
import 'package:simplio_app/view/routes/unauthenticated_router.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/password_text_field.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/sio_text_form_field.dart';
import 'package:sio_glyphs/sio_icons.dart';

class SignInScreen extends StatelessWidget with PopupDialogMixin {
  SignInScreen({super.key});

  final TextEditingController _emailEditingController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();
  static final _emailFieldKey = GlobalKey<FormFieldState>();
  static final _passwordFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return SioScaffold(
      resizeToAvoidBottomInset: false,
      backgroundGradient: BackgroundGradient.backGradientDark4,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        onVerticalDragDown: (_) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ColorizedAppBar(
                      key: const Key('sign-in-screen-app-bar-button'),
                      firstPart: context.locale.sign_in_screen_log,
                      secondPart: context.locale.sign_in_screen_in),
                  Padding(
                    padding: Paddings.horizontal20,
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
                              .read<SignInFormCubit>()
                              .state
                              .login
                              .emailValidator(
                                email,
                                errorMessage: context
                                    .locale.common_email_validation_error,
                              ),
                          focusedStyle: SioTextStyles.bodyPrimary
                              .apply(color: SioColorsDark.whiteBlue),
                          unfocusedStyle: SioTextStyles.bodyPrimary
                              .apply(color: SioColorsDark.secondary7),
                          decoration: UnderLinedTextFormFieldDecoration(
                            labelText: context.locale.common_email,
                            hintText: context.locale.common_email,
                          ),
                          cursorColor: SioColorsDark.whiteBlue,
                          onChanged: (String? email) {
                            context
                                .read<SignInFormCubit>()
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
                        ),
                        Gaps.gap10,
                        PasswordTextField(
                          passwordFieldKey: _passwordFieldKey,
                          validator: (pass) => context
                              .read<SignInFormCubit>()
                              .state
                              .password
                              .passwordValidator(
                                pass,
                                errorMsg: context
                                    .locale.common_password_validation_error,
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
                            _passwordFieldKey.currentState?.validate();
                          },
                        ),
                      ],
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
                          GoRouter.of(context).pushNamed(
                            UnauthenticatedRouter.passwordReset,
                          );
                        }
                      },
                      child: Text(
                        key: const Key('sign-in-screen-reset-password-button'),
                        context
                            .locale.sign_in_screen_forgot_password_button_label,
                        style: SioTextStyles.bodyS.apply(
                          color: SioColors.mentolGreen,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Padding(
                    padding: Paddings.horizontal20,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: BlocConsumer<SignInFormCubit, SignInFormState>(
                            listenWhen: ((prev, curr) =>
                                prev.response != curr.response),
                            listener: (context, state) {
                              final res = state.response;

                              if (res is SignInFormSuccess) {
                                context.read<AuthBloc>().add(GotAuthenticated(
                                    accountId: res.account.id));
                              }

                              if (res is SignInFormFailure) {
                                showError(context,
                                    message:
                                        state.response!.props.first.toString());
                              }
                            },
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
                                            color: SioColorsDark.whiteBlue,
                                          ),
                                        ),
                                        Padding(
                                          padding: Paddings.all20,
                                          child: Text(
                                            context.locale
                                                .sign_in_screen_signing_in_label,
                                            style:
                                                SioTextStyles.bodyPrimary.apply(
                                              color: SioColorsDark.whiteBlue,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }
                              return HighlightedElevatedButton(
                                  key: const Key(
                                      'sign-in-screen-sign-in-button'),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await context
                                          .read<SignInFormCubit>()
                                          .submitForm();
                                    }
                                  },
                                  label: context
                                      .locale.common_sign_in_button_label);
                            },
                          ),
                        ),
                        Gaps.gap20,
                        Padding(
                          padding: Paddings.horizontal16,
                          child: GestureDetector(
                            child: Row(
                              key: const Key(
                                  'sign-in-screen-create-account-button'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.locale
                                      .sign_in_screen_dont_have_account_yet_label,
                                  style: SioTextStyles.bodyPrimary.copyWith(
                                      color: SioColorsDark.secondary7,
                                      height: 1),
                                ),
                                Gaps.gap8,
                                Text(
                                  context.locale.sign_in_screen_sign_up,
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
                              final res = context
                                  .read<SignInFormCubit>()
                                  .state
                                  .response;
                              if (res is! SignInFormPending) {
                                GoRouter.of(context)
                                    .replaceNamed(UnauthenticatedRouter.signUp);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
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
      ),
    );
  }
}
