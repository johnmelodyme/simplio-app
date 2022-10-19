import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/data/model/helpers/validated_email.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/password_reset_form/password_reset_form_cubit.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/simplio_text_styles.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:simplio_app/view/widgets/colorized_app_bar.dart';
import 'package:simplio_app/view/widgets/highlighted_elevated_button.dart';
import 'package:simplio_app/view/widgets/sio_scaffold.dart';
import 'package:simplio_app/view/widgets/themed_text_form_field.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordResetScreen extends StatelessWidget with PopupDialogMixin {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PasswordResetFormCubit cubit = context.read<PasswordResetFormCubit>();

    return SioScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<PasswordResetFormCubit, PasswordResetFormState>(
            bloc: cubit,
            listener: (context, state) {
              final response = state.response;
              if (response is PasswordResetFormSuccess) {
                showPopup(
                  context,
                  message: response.resend
                      ? context.locale
                          .password_reset_screen_link_resent(state.email.value)
                      : context.locale
                          .password_reset_screen_link_sent(state.email.value),
                  icon: const Icon(
                    SioIcons.verified,
                    size: 50,
                    color: SioColorsDark.softBlack,
                  ),
                );
              }
            },
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
                                  color: SioColorsDark.mentolGreen
                                      .withOpacity(0.1),
                                  spreadRadius: 70 / 6,
                                  blurRadius: 70 / 2,
                                  offset: const Offset(0, 0),
                                ),
                              ]),
                              child: Stack(
                                children: const [
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    color: SioColorsDark.mentolGreen,
                                    size: 70,
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 10,
                                    child: Icon(
                                      Icons.question_mark,
                                      color: SioColorsDark.nft,
                                      size: 30,
                                    ),
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
                                  color: SioColorsDark.whiteBlue,
                                ),
                              ),
                              TextSpan(
                                text: context.locale
                                    .password_reset_screen_forgot_password_label2,
                                style: SioTextStyles.h1
                                    .apply(color: SioColorsDark.mentolGreen),
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
                            color: SioColorsDark.secondary7,
                          ),
                        ),
                        Gaps.gap32,
                        ThemedTextFormField(
                          key: const Key('reset-screen-email-text-field'),
                          autofocus: true,
                          style:
                              const TextStyle(color: SioColorsDark.whiteBlue),
                          decoration: InputDecoration(
                            labelText: context.locale.common_email,
                            hintText: context.locale.common_email,
                            fillColor: SioColorsDark.whiteBlue,
                            labelStyle: const TextStyle(
                                color: SioColorsDark.transparent),
                            hintStyle: SioTextStyles.bodyPrimary.apply(
                              color: SioColorsDark.secondary5,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: SioColorsDark.whiteBlue),
                            ),
                            disabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: SioColorsDark.black),
                            ),
                            border: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: SioColorsDark.black),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: SioColorsDark.whiteBlue),
                            ),
                          ),
                          cursorColor: SioColorsDark.whiteBlue,
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
                        onPressed: ValidatedEmail(value: state.email.value)
                                    .isValid &&
                                state is! PasswordResetFormPending
                            ? () {
                                cubit.submitForm();
                                FocusManager.instance.primaryFocus?.unfocus();
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
                        if (ValidatedEmail(value: state.email.value).isValid &&
                            state is! PasswordResetFormPending) {
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
                                color: SioColorsDark.whiteBlue, height: 1),
                          ),
                          Text(
                            context.locale.password_reset_screen_resend_label,
                            style: SioTextStyles.bodyPrimary.copyWith(
                              color: SioColorsDark.mentolGreen,
                              height: 1,
                            ),
                          ),
                          Gaps.gap8,
                          const Icon(
                            SioIcons.arrow_right,
                            size: 14,
                            color: SioColorsDark.mentolGreen,
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
    );
  }
}
