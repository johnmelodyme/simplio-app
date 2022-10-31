import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/password_change_form/password_change_form_cubit.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/password_rules_row.dart';
import 'package:simplio_app/view/widgets/password_text_field.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordKey = const Key('old-password.key');
  final newPasswordKey = const Key('new-password-key');
  final confirmPasswordKey = const Key('confirm-password-key');

  @override
  Widget build(BuildContext context) {
    PasswordChangeFormCubit cubit = context.read<PasswordChangeFormCubit>();

    return SioScaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: BlocListener<PasswordChangeFormCubit, PasswordChangeFormState>(
            listener: (context, state) {
              // TODO: handle responses
            },
            child: Column(
              children: [
                const ColorizedAppBar(
                    key: Key('update-password-screen-app-bar'),
                    firstPart: '',
                    secondPart: ''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: SioColors.mentolGreen.withOpacity(0.1),
                          spreadRadius: 70 / 6,
                          blurRadius: 70 / 2,
                          offset: const Offset(0, 0),
                        ),
                      ]),
                      child: Icon(
                        SioIcons.lock, //TODO.. change icon
                        color: SioColors.mentolGreen,
                        size: 70,
                      ),
                    ),
                  ],
                ),
                Gaps.gap14,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${context.locale.password_change_screen_update_label} ',
                        style: SioTextStyles.h1.apply(
                          color: SioColors.whiteBlue,
                        ),
                      ),
                      TextSpan(
                        text: context
                            .locale.password_change_screen_password_label,
                        style: SioTextStyles.h1
                            .apply(color: SioColors.mentolGreen),
                      ),
                    ],
                  ),
                ),
                Gaps.gap10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                        padding: Paddings.horizontal16,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              PasswordTextField(
                                key: oldPasswordKey,
                                labelText: context.locale
                                    .password_change_screen_current_password_input_label,
                                validator: (pass) => cubit.state.oldPassword
                                    .passwordValidator(pass,
                                        errorMsg: context.locale
                                            .common_password_validation_error),
                                passwordComplexityCondition: (pass) =>
                                    cubit.state.oldPassword.isValid,
                                onChanged: (password) {
                                  cubit.changeFormValue(
                                    oldPassword: password,
                                  );
                                },
                              ),
                              Gaps.gap10,
                              PasswordTextField(
                                key: newPasswordKey,
                                labelText: context.locale
                                    .password_change_screen_new_password_input_label,
                                validator: (pass) => cubit.state.newPassword
                                    .passwordValidator(pass,
                                        errorMsg: context.locale
                                            .password_change_screen_enter_new_password_label),
                                passwordComplexityCondition: (pass) =>
                                    cubit.state.newPassword.isValid,
                                onChanged: (password) {
                                  cubit.changeFormValue(
                                    newPassword: password,
                                  );
                                },
                              ),
                              Gaps.gap10,
                              PasswordTextField(
                                key: confirmPasswordKey,
                                labelText: context.locale
                                    .password_change_screen_confirm_new_password_input_label,
                                validator: (pass) => cubit
                                    .state.newConfirmedPassword
                                    .passworMatchValidator(
                                        pass, cubit.state.newPassword.value,
                                        errorMsg: context.locale
                                            .password_change_screen_confirm_new_password_label),
                                passwordComplexityCondition: (pass) =>
                                    cubit.state.newConfirmedPassword.isValid &&
                                    cubit.state.newPassword.value ==
                                        cubit.state.newConfirmedPassword.value,
                                onChanged: (password) {
                                  cubit.changeFormValue(
                                    newConfirmedPassword: password,
                                  );
                                },
                              ),
                              if (cubit.state.newPassword.value.isNotEmpty &&
                                  !cubit.state.newPassword.isValid) ...[
                                Gaps.gap20,
                                Column(
                                  children: [
                                    PasswordRulesRow(
                                        text: context.locale
                                            .common_password_rule_atleast_8_chars,
                                        passed: cubit.state.newPassword
                                                .missingValue['length'] ??
                                            false),
                                    PasswordRulesRow(
                                        text: context.locale
                                            .common_password_rule_num_char,
                                        passed: cubit.state.newPassword
                                                .missingValue['numberChar'] ??
                                            false),
                                    PasswordRulesRow(
                                        text: context.locale
                                            .common_password_rule_special_char,
                                        passed: cubit.state.newPassword
                                                .missingValue['specialChar'] ??
                                            false),
                                    PasswordRulesRow(
                                        text: context.locale
                                            .common_password_rule_upper_char,
                                        passed: cubit.state.newPassword
                                                .missingValue['upperChar'] ??
                                            false),
                                  ],
                                )
                              ],
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: HighlightedElevatedButton(
                          onPressed: () {
                            setState(() {});
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (formKey.currentState!.validate()) {
                              cubit.submitForm();
                            }
                          },
                          label: context
                              .locale.password_change_screen_sumbit_button,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
