import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/shared/utils/validator.dart';

class CustomTextFormField extends CustomFormField {
  final ValidatorType validatorType;
  final void Function(String?) onSaved;

  CustomTextFormField({
    Key? key,
    required Icon icon,
    required ApplicationLabels label,
    required this.validatorType,
    required this.onSaved,
  }) : super(icon: icon, hint: label.hint, description: label.description);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: icon,
        border: OutlineInputBorder(),
        hintText: hint,
        labelText: description,
      ),
      validator: (String? value) => validate(value, validatorType),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: onSaved,
    );
  }

  String? validate(String? value, ValidatorType type) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    try {
      return Validator.validate(validatorType, value)
          ? null
          : "Please enter a valid value";
    } catch (e) {
      return "Please enter a valid value";
    }
  }
}
