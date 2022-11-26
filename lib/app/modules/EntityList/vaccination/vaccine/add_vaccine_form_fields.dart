import 'package:flutter/material.dart';
import 'package:nurse/app/components/form_padding.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/add_vaccine_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccineFormFields extends StatefulWidget {
  final AddVaccineFormController controller;

  const VaccineFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<VaccineFormFields> createState() => VaccineFormFieldsState();
}

class VaccineFormFieldsState extends State<VaccineFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.local_pharmacy_rounded),
              label: FormLabels.vaccineLaboratory,
              textEditingController: widget.controller.laboratory,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.vaccineName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.numbers_rounded),
              label: FormLabels.vaccineSipniCode,
              textEditingController: widget.controller.sipniCode,
              validatorType: ValidatorType.numericalString,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
