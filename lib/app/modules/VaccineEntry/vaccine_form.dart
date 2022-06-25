import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';

class VaccineForm extends StatefulWidget {
  final VaccineFormController controller;

  VaccineForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<VaccineForm> createState() => _VaccineFormState();
}

class _VaccineFormState extends State<VaccineForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: Icon(Icons.vaccines),
              label: FormLabels.vaccine,
              items: widget.controller.vaccines,
              onChanged: (Vaccine? value) =>
                  setState(() => widget.controller.selectedVaccine = value),
              onSaved: (Vaccine? value) =>
                  widget.controller.selectedVaccine = value,
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: Icon(Icons.batch_prediction),
              label: FormLabels.vaccineBatch,
              items: widget.controller.vaccineBatches,
              onChanged: (VaccineBatch? value) =>
                  setState(() => widget.controller.selectedBatch = value),
              onSaved: (VaccineBatch? value) =>
                  widget.controller.selectedBatch = value,
            ),
          ],
        ),
      ),
    );
  }
}
