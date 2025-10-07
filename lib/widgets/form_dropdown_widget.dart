import 'package:flutter/material.dart';

class FormDropdown<T> extends StatelessWidget {
  final String label;
  final String? errorText;
  final IconData icon;
  final Map<T, String> items; // Changed to List<dynamic>
  final T? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String?>? validator;

  const FormDropdown({
    super.key,
    required this.label,
    required this.errorText,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value?.toString(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      items: items.keys
          .map((key) => DropdownMenuItem<String>(
                value: key.toString(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      items[key]!,
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
