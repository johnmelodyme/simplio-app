import 'package:flutter/material.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/themes/sio_colors.dart';

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
    this.displayedIcon = Icons.visibility_outlined,
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('password-text-field'),
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
            isComplexitySatisfied ? SioColors.attention : SioColors.whiteBlue,
      ),
      obscuringCharacter: '⦁',
      // obscuringCharacter: '●',
      // obscuringCharacter: '﹡',
      // obscuringCharacter: '⁕',
      decoration: InputDecoration(
        labelText:
            widget.labelText ?? context.locale.common_password_input_label,
        hintText:
            widget.labelText ?? context.locale.common_password_input_label,
        fillColor: SioColors.whiteBlue,
        labelStyle: TextStyle(color: SioColors.whiteBlue),
        iconColor: SioColors.black,
        hintStyle: TextStyle(fontSize: 16.0, color: SioColors.black),
        border: InputBorder.none,
        suffixIcon: IconButton(
            icon: Icon(
              _isDisplayed ? widget.displayedIcon : widget.icon,
              color: SioColors.whiteBlue,
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
