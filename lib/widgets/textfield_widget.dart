import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? errorText;
  final FormFieldSetter<String> onSave;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  TextFieldWidget({
    required this.label,
    required this.icon,
    required this.onSave,
		required this.errorText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          errorText: errorText),
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      onChanged: onSave,
      validator: validator,
    );
  }
}
