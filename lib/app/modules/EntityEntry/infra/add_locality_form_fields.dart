import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_locality_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class LocalityFormFields extends StatefulWidget {
  final AddLocalityFormController controller;

  const LocalityFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<LocalityFormFields> createState() => LocalityFormFieldsState();
}

class LocalityFormFieldsState extends State<LocalityFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          semanticChildCount: 4,
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.localityName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.location_city),
              label: FormLabels.localityCity,
              textEditingController: widget.controller.city,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.map),
              label: FormLabels.localityState,
              textEditingController: widget.controller.state,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.numbers),
              label: FormLabels.localityCode,
              textEditingController: widget.controller.ibgeCode,
              validatorType: ValidatorType.ibgeCode,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
