import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/components/sex_icon.dart";
import "package:nurse/app/modules/EntityList/patient/patient/add_patient_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/utils/validator.dart";

class PatientFormFields extends StatelessWidget {
  final AddPatientFormController controller;

  const PatientFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.abc_rounded),
                  label: FormLabels.patientName,
                  validatorType: ValidatorType.name,
                  initialValue: controller.patientStore.name,
                  onChanged: (String? value) =>
                      controller.patientStore.name = value,
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.badge_rounded),
                  label: FormLabels.patientCns,
                  validatorType: ValidatorType.cns,
                  initialValue: controller.patientStore.cns,
                  onChanged: (String? value) =>
                      controller.patientStore.cns = value,
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.badge_rounded),
                  label: FormLabels.patientCpf,
                  validatorType: ValidatorType.cpf,
                  initialValue: controller.patientStore.cpf,
                  onChanged: (String? value) =>
                      controller.patientStore.cpf = value,
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.calendar_month_rounded),
                  label: FormLabels.birthDate,
                  validatorType: ValidatorType.birthDate,
                  initialValue: controller.patientStore.birthDate,
                  onTap: () async =>
                      controller.patientStore.selectDate(context),
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomDropdownButtonFormField<Locality>(
                  icon: const Icon(Icons.pin_rounded),
                  label: FormLabels.localityName,
                  items: controller.localities.toList(),
                  value: controller.patientStore.selectedLocality,
                  onChanged: (Locality? value) =>
                      controller.patientStore.selectedLocality = value,
                  onSaved: (Locality? value) =>
                      controller.patientStore.selectedLocality = value,
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomDropdownButtonFormField<PriorityCategory>(
                  icon: const Icon(Icons.category_rounded),
                  label: FormLabels.categoryName,
                  items: controller.categories.toList(),
                  value: controller.patientStore.selectedPriorityCategory,
                  onChanged: (PriorityCategory? value) =>
                      controller.patientStore.selectedPriorityCategory = value,
                  onSaved: (PriorityCategory? value) =>
                      controller.patientStore.selectedPriorityCategory = value,
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomDropdownButtonFormField<Sex>(
                  icon: SexIcon(controller.patientStore.selectedSex),
                  label: FormLabels.sex,
                  items: Sex.values,
                  value: controller.patientStore.selectedSex,
                  isEnum: true,
                  onChanged: (Sex? value) =>
                      controller.patientStore.selectedSex = value!,
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomDropdownButtonFormField<MaternalCondition>(
                  icon: controller.patientStore.selectedMaternalCondition ==
                          MaternalCondition.nenhum
                      ? const Icon(Icons.question_mark_rounded)
                      : controller.patientStore.selectedMaternalCondition ==
                              MaternalCondition.gestante
                          ? const Icon(Icons.pregnant_woman_rounded)
                          : const Icon(Icons.baby_changing_station_rounded),
                  label: FormLabels.maternalCondition,
                  items: controller.patientStore.selectedSex == Sex.male
                      ? [MaternalCondition.nenhum]
                      : MaternalCondition.values,
                  value: controller.patientStore.selectedSex == Sex.male
                      ? MaternalCondition.nenhum
                      : controller.patientStore.selectedMaternalCondition,
                  isEnum: true,
                  onChanged: (MaternalCondition? value) => controller
                      .patientStore.selectedMaternalCondition = value!,
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.abc_rounded),
                  label: FormLabels.motherName,
                  validatorType: ValidatorType.optionalName,
                  initialValue: controller.patientStore.motherName,
                  onChanged: (String? value) =>
                      controller.patientStore.motherName = value,
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.abc_rounded),
                  label: FormLabels.fatherName,
                  validatorType: ValidatorType.optionalName,
                  initialValue: controller.patientStore.fatherName,
                  onChanged: (String? value) =>
                      controller.patientStore.fatherName = value,
                  onSaved: (_) {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
