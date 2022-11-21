import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityList/patient/patient/add_patient_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PatientFormFields extends StatefulWidget {
  final AddPatientFormController controller;

  const PatientFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PatientFormFields> createState() => PatientFormFieldsState();
}

class PatientFormFieldsState extends State<PatientFormFields> {
  List<Locality> _localities = List<Locality>.empty(growable: true);
  List<PriorityCategory> _categories =
      List<PriorityCategory>.empty(growable: true);

  @override
  void initState() {
    _getLocalities();
    _getPriorityCategories();
    super.initState();
  }

  Future<void> _getLocalities() async {
    _localities = await widget.controller.getLocalities();
    setState(() {});
  }

  Future<void> _getPriorityCategories() async {
    _categories = await widget.controller.getPriorityCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.patientName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge_rounded),
              label: FormLabels.patientCns,
              textEditingController: widget.controller.cns,
              validatorType: ValidatorType.cns,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge_rounded),
              label: FormLabels.patientCpf,
              textEditingController: widget.controller.cpf,
              validatorType: ValidatorType.cpf,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.calendar_month_rounded),
              label: FormLabels.birthDate,
              textEditingController: widget.controller.birthDate,
              validatorType: ValidatorType.birthDate,
              onTap: () async => widget.controller.selectDate(context),
              readOnly: true,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.pin_rounded),
              label: FormLabels.localityName,
              items: _localities,
              value: widget.controller.selectedLocality,
              onChanged: (Locality? value) =>
                  setState(() => widget.controller.selectedLocality = value),
              onSaved: (Locality? value) =>
                  setState(() => widget.controller.selectedLocality = value),
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.category_rounded),
              label: FormLabels.categoryName,
              items: _categories,
              value: widget.controller.selectedPriorityCategory,
              onChanged: (PriorityCategory? value) => setState(
                  () => widget.controller.selectedPriorityCategory = value),
              onSaved: (PriorityCategory? value) =>
                  widget.controller.selectedPriorityCategory = value,
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: widget.controller.selectedSex == Sex.none
                  ? const Icon(Icons.question_mark_rounded)
                  : widget.controller.selectedSex == Sex.female
                      ? const Icon(Icons.female_rounded)
                      : const Icon(Icons.male_rounded),
              label: FormLabels.sex,
              items: Sex.values,
              value: widget.controller.selectedSex,
              isEnum: true,
              onChanged: (Sex? value) => setState(() {
                widget.controller.selectedSex = value!;
              }),
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: widget.controller.selectedMaternalCondition ==
                      MaternalCondition.nenhum
                  ? const Icon(Icons.question_mark_rounded)
                  : widget.controller.selectedMaternalCondition ==
                          MaternalCondition.gestante
                      ? const Icon(Icons.pregnant_woman_rounded)
                      : const Icon(Icons.baby_changing_station_rounded),
              label: FormLabels.maternalCondition,
              items: widget.controller.selectedSex == Sex.male
                  ? [MaternalCondition.nenhum]
                  : MaternalCondition.values,
              value: widget.controller.selectedSex == Sex.male
                  ? MaternalCondition.nenhum
                  : widget.controller.selectedMaternalCondition,
              isEnum: true,
              onChanged: (MaternalCondition? value) => setState(() {
                widget.controller.selectedMaternalCondition = value!;
              }),
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.motherName,
              textEditingController: widget.controller.motherName,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.fatherName,
              textEditingController: widget.controller.fatherName,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
