import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/decorations/underlined_text_form_field_decoration.dart';
import 'package:simplio_app/view/themes/constants.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';
import 'package:simplio_app/view/themes/sio_colors_dark.dart';
import 'package:sio_glyphs/sio_icons.dart';

class PasswordTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool Function(String password) passwordComplexityCondition;
  final bool autofocus;
  final String? labelText;
  final IconData displayedIcon;
  final IconData icon;
  final FormFieldValidator<String>? validator;

  const PasswordTextField({
    super.key,
    required this.passwordComplexityCondition,
    this.onChanged,
    this.autofocus = false,
    this.labelText,
    this.displayedIcon = SioIcons.eye,
    this.icon = Icons.visibility_off_outlined,
    this.onTap,
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isDisplayed = true;
  bool isComplexitySatisfied = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('password-text-field'),
      controller: controller,
      obscureText: _isDisplayed,
      autofocus: widget.autofocus,
      validator: widget.validator,
      onChanged: (String? password) {
        if (password != null) {
          widget.onChanged?.call(password);
          setState(() => isComplexitySatisfied =
              widget.passwordComplexityCondition(password));
        }
      },
      style: TextStyle(
        color:
            isComplexitySatisfied ? SioColors.whiteBlue : SioColors.attention,
      ),
      obscuringCharacter: '⦁',
      cursorColor: SioColorsDark.whiteBlue,
      decoration: UnderLinedTextFormFieldDecoration(
        errorStyle: const TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText:
            widget.labelText ?? context.locale.common_password_input_label,
        hintText:
            widget.labelText ?? context.locale.common_password_input_label,
        iconColor: SioColorsDark.black,
        suffixIcon: IconButton(
            padding: Paddings.top20,
            icon: Icon(
              _isDisplayed ? widget.displayedIcon : widget.icon,
              color: controller.text.isNotEmpty
                  ? SioColorsDark.whiteBlue
                  : SioColorsDark.secondary5,
            ),
            onPressed: () {
              setState(() {
                _isDisplayed = !_isDisplayed;
              });
            }),
      ),
      onTap: widget.onTap,
    );
  }
}
