import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/validator.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: validator ??
          (value) => validateRegistrationItem(value, "phone number"),
    );
  }
}
