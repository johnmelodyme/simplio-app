import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/logic/cubit/password_reset_form/password_reset_form_cubit.dart';
import 'package:simplio_app/view/decorations/underlined_text_form_field_decoration.dart';
import 'package:simplio_app/view/dialogs/dialog_content.dart';
import 'package:simplio_app/view/extensions/localized_build_context_extension.dart';
import 'package:simplio_app/view/mixins/snackbar_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/button/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/sio_text_form_field.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordResetScreen extends StatelessWidget with SnackBarMixin {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PasswordResetFormCubit cubit = context.read<PasswordResetFormCubit>();

    return SioScaffold(
      resizeToAvoidBottomInset: false,
      backgroundGradient: BackgroundGradient.backGradientDark4,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                onVerticalDragDown: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                child: BlocConsumer<PasswordResetFormCubit,
                    PasswordResetFormState>(
                  bloc: cubit,
                  listenWhen: ((prev, curr) => prev.response != curr.response),
                  listener: (context, state) {
                    final response = state.response;
                    if (response is PasswordResetFormSuccess) {
                      showSnackBar(
                        context,
                        content: DialogContent.regular(
                          message: response.resend
                              ? context.locale
                                  .password_reset_screen_link_resent(
                                      state.email.value)
                              : context.locale.password_reset_screen_link_sent(
                                  state.email.value),
                          icon: Icon(
                            SioIcons.verified,
                            size: 50,
                            color: SioColors.softBlack,
                          ),
                        ),
                      );
                    }
                    if (response is PasswordResetFormFailure) {
                      showSnackBar(
                        context,
                        content: DialogContent.error(
                          message: response.exception.toString(),
                        ),
                      );
                    }
                  },
                  buildWhen: (prev, curr) => prev != curr,
                  builder: (context, state) {
                    return Column(
                      children: [
                        const ColorizedAppBar(
                          key: Key('password-reset-screen-app-bar'),
                          title: '',
                        ),
                        Padding(
                          padding: Paddings.horizontal16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: SioColors.mentolGreen
                                            .withOpacity(0.1),
                                        spreadRadius: 70 / 6,
                                        blurRadius: 70 / 2,
                                        offset: const Offset(0, 0),
                                      ),
                                    ]),
                                    child: Stack(
                                      children: [
                                        Icon(
                                          SioIcons.lock,
                                          color: SioColors.mentolGreen,
                                          size: 70,
                                        ),
                                      ],
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
                                          '${context.locale.password_reset_screen_forgot_password_label1} ',
                                      style: SioTextStyles.h1.apply(
                                        color: SioColors.whiteBlue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: context.locale
                                          .password_reset_screen_forgot_password_label2,
                                      style: SioTextStyles.h1
                                          .apply(color: SioColors.mentolGreen),
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.gap14,
                              Text(
                                context.locale
                                    .password_reset_screen_forgot_password_hint,
                                textAlign: TextAlign.center,
                                style: SioTextStyles.bodyPrimary.apply(
                                  color: SioColors.secondary7,
                                ),
                              ),
                              Gaps.gap32,
                              SioTextFormField(
                                key: const Key(
                                    'password-reset-screen-email-text-field'),
                                focusedStyle: SioTextStyles.bodyPrimary
                                    .apply(color: SioColorsDark.whiteBlue),
                                unfocusedStyle: SioTextStyles.bodyPrimary
                                    .apply(color: SioColorsDark.secondary7),
                                decoration: UnderLinedTextFormFieldDecoration(
                                  labelText: context.locale.common_email,
                                  hintText: context.locale.common_email,
                                ),
                                cursorColor: SioColors.whiteBlue,
                                onChanged: (String? email) {
                                  cubit.changeFormValue(email: email);
                                },
                                autofocus: true,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Gaps.gap40,
                        Padding(
                          padding: Paddings.horizontal16,
                          child: SizedBox(
                            width: double.infinity,
                            child: state.isValid
                                ? HighlightedElevatedButton.primary(
                                    key: const Key(
                                      'password-reset-screen-submit-button',
                                    ),
                                    // TODO - refactor this block implementation.
                                    onPressed: (state.response
                                                is! PasswordResetFormPending &&
                                            state.response
                                                is! PasswordResetFormSuccess &&
                                            state.response
                                                is! PasswordResetFormFailure)
                                        ? () {
                                            cubit.submitForm();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          }
                                        : null,
                                    label: context.locale.common_send_btn_label,
                                  )
                                : HighlightedElevatedButton.disabled(
                                    key: const Key(
                                      'password-reset-screen-dialled-button',
                                    ),
                                    label: context.locale.common_send_btn_label,
                                  ),
                          ),
                        ),
                        if (state.response is PasswordResetFormSuccess ||
                            state.response is PasswordResetFormFailure) ...[
                          Gaps.gap20,
                          GestureDetector(
                            onTap: () {
                              if (state.isValid &&
                                  state.response is! PasswordResetFormPending) {
                                cubit.submitForm(resend: true);
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.locale
                                      .password_reset_screen_did_not_receive_link_label,
                                  style: SioTextStyles.bodyPrimary.copyWith(
                                      color: SioColors.whiteBlue, height: 1),
                                ),
                                Text(
                                  context.locale
                                      .password_reset_screen_resend_label,
                                  style: SioTextStyles.bodyPrimary.copyWith(
                                    color: SioColors.mentolGreen,
                                    height: 1,
                                  ),
                                ),
                                Gaps.gap8,
                                Icon(
                                  SioIcons.arrow_right,
                                  size: 14,
                                  color: SioColors.mentolGreen,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
