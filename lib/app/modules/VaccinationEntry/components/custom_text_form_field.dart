import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/shared/utils/validator.dart';

class CustomTextFormField extends CustomFormField {
  final ValidatorType validatorType;
  final TextEditingController? textEditingController;
  final bool readOnly;
  final void Function()? onTap;
  final ValueChanged<String?>? onChanged;
  final void Function(String?) onSaved;

  CustomTextFormField({
    Key? key,
    required Icon icon,
    required FormLabels label,
    this.readOnly = false,
    required this.validatorType,
    this.textEditingController,
    this.onTap,
    this.onChanged,
    required this.onSaved,
  }) : super(
          icon: icon,
          hint: label.hint,
          description: label.description,
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: icon,
        border: OutlineInputBorder(),
        hintText: hint,
        labelText: description,
      ),
      controller: textEditingController,
      validator: (String? value) => validate(value, validatorType),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }

  String? validate(String? value, ValidatorType type) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    try {
      return Validator.validate(type, value)
          ? null
          : "Please enter a valid value";
    } catch (e) {
      return "Please enter a valid value";
    }
  }
}
