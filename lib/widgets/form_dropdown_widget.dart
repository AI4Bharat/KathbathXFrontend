import 'package:flutter/material.dart';

class FormDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<dynamic> items; // Changed to List<dynamic>
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String?>? validator;

  const FormDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item.toString(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      item.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ))
          .toList(),
      validator: validator,
    );
  }
}
