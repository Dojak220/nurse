import "package:flutter/material.dart";
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/EntityList/patient/priorityCategory/add_priority_category_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";
import "package:nurse/shared/utils/validator.dart";

class PriorityCategoryFormFields extends StatelessWidget {
  final AddPriorityCategoryFormController controller;

  const PriorityCategoryFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  // List<PriorityGroup> _groups = List<PriorityGroup>.empty(growable: true);

  // @override
  // void initState() {
  //   _getPriorityGroups();
  //   super.initState();
  // }

  // Future<void> _getPriorityGroups() async {
  //   _groups = await widget.controller.getPriorityGroups();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            Observer(
              builder: (_) {
                return CustomDropdownButtonFormField(
                  icon: const Icon(Icons.group_rounded),
                  label: FormLabels.categoryGroup,
                  items: controller.groups.toList(),
                  value: controller.priorityCategoryStore.selectedPriorityGroup,
                  onChanged: (PriorityGroup? value) => controller
                      .priorityCategoryStore.selectedPriorityGroup = value,
                  onSaved: (PriorityGroup? value) => controller
                      .priorityCategoryStore.selectedPriorityGroup = value,
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.category_rounded),
                  label: FormLabels.categoryCode,
                  initialValue: controller.priorityCategoryStore.code,
                  validatorType: ValidatorType.name,
                  onChanged: (String? value) =>
                      controller.priorityCategoryStore.code = value,
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.abc_rounded),
                  label: FormLabels.categoryName,
                  initialValue: controller.priorityCategoryStore.name,
                  validatorType: ValidatorType.optionalName,
                  onChanged: (String? value) =>
                      controller.priorityCategoryStore.name = value,
                  onSaved: (value) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.description_rounded),
                  label: FormLabels.categoryDescription,
                  initialValue: controller.priorityCategoryStore.description,
                  validatorType: ValidatorType.description,
                  onChanged: (String? value) =>
                      controller.priorityCategoryStore.description = value,
                  onSaved: (value) {},
                );
              },
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
