import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/logic/cubit/password_reset_form/password_reset_form_cubit.dart';
import 'package:simplio_app/view/themes/common_theme.dart';
import 'package:simplio_app/view/widgets/text_header.dart';
import 'package:simplio_app/view/widgets/themed_text_form_field.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        key: const Key('reset-screen-app-bar'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: CommonTheme.paddingAll,
                child: Column(
                  children: [
                    TextHeader(title: context.locale.forgotPasswordLabel),
                    Form(
                      key: formKey,
                      child: ThemedTextFormFiled(
                        key: const Key('reset-screen-email-text-field'),
                        autofocus: true,
                        validator: (email) => context
                            .read<PasswordResetFormCubit>()
                            .state
                            .email
                            .emailValidator(
                              email,
                              errorMessage: context.locale.emailValidationError,
                            ),
                        decoration: InputDecoration(
                          labelText: context.locale.email,
                          hintText: context.locale.email,
                        ),
                        onChanged: (String? email) {
                          context
                              .read<PasswordResetFormCubit>()
                              .changeFormValue(email: email);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: CommonTheme.paddingAll,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('reset-screen-submit-button'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<PasswordResetFormCubit>().submitForm();
                    }
                  },
                  child: Text(context.locale.submitBtnLabel),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
