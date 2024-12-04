import 'package:flutter/material.dart';

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
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number.';
            }
            if (value.length != 10) {
              return 'Phone number must be exactly 10 digits.';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Phone number can only contain digits.';
            }
            return null;
          },
    );
  }
}
