import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';

class CustomDropdownButtonFormField<T> extends CustomFormField {
  final List<T> items;
  final void Function(T?)? onChanged;

  CustomDropdownButtonFormField({
    Key? key,
    required Icon icon,
    required ApplicationLabels label,
    required this.items,
    required this.onChanged,
  }) : super(icon: icon, hint: label.hint, description: label.description);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        icon: icon,
        border: border,
        hintText: hint,
        labelText: description,
      ),
      items: items
          .map((item) =>
              DropdownMenuItem(value: item, child: Text(item.toString())))
          .toList(),
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
