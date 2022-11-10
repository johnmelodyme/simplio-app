import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/password_reset_form/password_reset_form_cubit.dart';
import 'package:simplio_app/view/decorations/underlined_text_form_field_decoration.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/back_gradient4.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/sio_text_form_field.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordResetScreen extends StatelessWidget with PopupDialogMixin {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PasswordResetFormCubit cubit = context.read<PasswordResetFormCubit>();

    return SioScaffold(
      body: SafeArea(
        top: true,
        child: BackGradient4(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              onVerticalDragDown: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              child:
                  BlocConsumer<PasswordResetFormCubit, PasswordResetFormState>(
                bloc: cubit,
                listener: (context, state) {
                  final response = state.response;
                  if (response is PasswordResetFormSuccess) {
                    showPopup(
                      context,
                      message: response.resend
                          ? context.locale.password_reset_screen_link_resent(
                              state.email.value)
                          : context.locale.password_reset_screen_link_sent(
                              state.email.value),
                      icon: Icon(
                        SioIcons.verified,
                        size: 50,
                        color: SioColors.softBlack,
                      ),
                    );
                  }
                },
                buildWhen: (prev, curr) =>
                    prev.response != curr.response ||
                    prev.isValid != curr.isValid,
                builder: (context, state) {
                  return Column(
                    children: [
                      const ColorizedAppBar(
                          key: Key('reset-screen-app-bar'),
                          firstPart: '',
                          secondPart: ''),
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
                              key: const Key('reset-screen-email-text-field'),
                              autofocus: true,
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
                            ),
                          ],
                        ),
                      ),
                      Gaps.gap40,
                      Padding(
                        padding: Paddings.horizontal16,
                        child: SizedBox(
                          width: double.infinity,
                          child: HighlightedElevatedButton(
                            key: const Key('reset-screen-submit-button'),
                            onPressed: (state.isValid &&
                                    state.response
                                        is! PasswordResetFormPending &&
                                    state.response is! PasswordResetFormSuccess)
                                ? () {
                                    cubit.submitForm();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  }
                                : null,
                            label: context.locale.common_send_btn_label,
                          ),
                        ),
                      ),
                      if (state.response is PasswordResetFormSuccess) ...[
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
                                context
                                    .locale.password_reset_screen_resend_label,
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
                      ]
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
