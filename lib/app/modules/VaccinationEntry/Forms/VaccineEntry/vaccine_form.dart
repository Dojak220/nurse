import "package:flutter/material.dart";
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/VaccineEntry/vaccine_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_model.dart";

class VaccineForm extends StatefulWidget {
  final VaccineFormController controller;

  const VaccineForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<VaccineForm> createState() => _VaccineFormState();
}

class _VaccineFormState extends State<VaccineForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.vaccines_rounded),
              label: FormLabels.vaccineName,
              items: widget.controller.vaccines,
              onChanged: (Vaccine? value) =>
                  setState(() => widget.controller.selectedVaccine = value),
              onSaved: (Vaccine? value) =>
                  widget.controller.selectedVaccine = value,
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.batch_prediction_rounded),
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
