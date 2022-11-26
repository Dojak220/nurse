import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/form_padding.dart';
import 'package:nurse/app/components/sex_icon.dart';
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
      child: FormPadding(
        child: ListView(
          children: [
            Observer(builder: (_) {
              return CustomTextFormField(
                icon: const Icon(Icons.abc_rounded),
                label: FormLabels.patientName,
                validatorType: ValidatorType.name,
                initialValue: widget.controller.patientStore.name,
                onChanged: (value) =>
                    widget.controller.patientStore.name = value,
                onSaved: (value) => {},
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomTextFormField(
                icon: const Icon(Icons.badge_rounded),
                label: FormLabels.patientCns,
                validatorType: ValidatorType.cns,
                initialValue: widget.controller.patientStore.cns,
                onChanged: (value) =>
                    widget.controller.patientStore.cns = value,
                onSaved: (value) => {},
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomTextFormField(
                icon: const Icon(Icons.badge_rounded),
                label: FormLabels.patientCpf,
                validatorType: ValidatorType.cpf,
                initialValue: widget.controller.patientStore.cpf,
                onChanged: (value) =>
                    widget.controller.patientStore.cpf = value,
                onSaved: (value) => {},
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomTextFormField(
                icon: const Icon(Icons.calendar_month_rounded),
                label: FormLabels.birthDate,
                validatorType: ValidatorType.birthDate,
                initialValue: widget.controller.patientStore.birthDate,
                onTap: () async =>
                    widget.controller.patientStore.selectDate(context),
                readOnly: true,
                onSaved: (value) => {},
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon: const Icon(Icons.pin_rounded),
                label: FormLabels.localityName,
                items: _localities,
                value: widget.controller.patientStore.selectedLocality,
                onChanged: (Locality? value) =>
                    widget.controller.patientStore.selectedLocality = value,
                onSaved: (Locality? value) =>
                    widget.controller.patientStore.selectedLocality = value,
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon: const Icon(Icons.category_rounded),
                label: FormLabels.categoryName,
                items: _categories,
                value: widget.controller.patientStore.selectedPriorityCategory,
                onChanged: (PriorityCategory? value) => widget
                    .controller.patientStore.selectedPriorityCategory = value,
                onSaved: (PriorityCategory? value) => widget
                    .controller.patientStore.selectedPriorityCategory = value,
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon: SexIcon(widget.controller.patientStore.selectedSex),
                label: FormLabels.sex,
                items: Sex.values,
                value: widget.controller.patientStore.selectedSex,
                isEnum: true,
                onChanged: (Sex? value) =>
                    widget.controller.patientStore.selectedSex = value!,
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon:
                    widget.controller.patientStore.selectedMaternalCondition ==
                            MaternalCondition.nenhum
                        ? const Icon(Icons.question_mark_rounded)
                        : widget.controller.patientStore
                                    .selectedMaternalCondition ==
                                MaternalCondition.gestante
                            ? const Icon(Icons.pregnant_woman_rounded)
                            : const Icon(Icons.baby_changing_station_rounded),
                label: FormLabels.maternalCondition,
                items: widget.controller.patientStore.selectedSex == Sex.male
                    ? [MaternalCondition.nenhum]
                    : MaternalCondition.values,
                value: widget.controller.patientStore.selectedSex == Sex.male
                    ? MaternalCondition.nenhum
                    : widget.controller.patientStore.selectedMaternalCondition,
                isEnum: true,
                onChanged: (MaternalCondition? value) => widget
                    .controller.patientStore.selectedMaternalCondition = value!,
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomTextFormField(
                icon: const Icon(Icons.abc_rounded),
                label: FormLabels.motherName,
                validatorType: ValidatorType.optionalName,
                initialValue: widget.controller.patientStore.motherName,
                onChanged: (value) =>
                    widget.controller.patientStore.motherName = value,
                onSaved: (value) => {},
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomTextFormField(
                icon: const Icon(Icons.abc_rounded),
                label: FormLabels.fatherName,
                validatorType: ValidatorType.optionalName,
                initialValue: widget.controller.patientStore.fatherName,
                onChanged: (value) =>
                    widget.controller.patientStore.fatherName = value,
                onSaved: (value) => {},
              );
            }),
          ],
        ),
      ),
    );
  }
}
