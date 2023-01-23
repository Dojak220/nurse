import "package:flutter/material.dart";
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/add_priority_group_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/utils/validator.dart";

class PriorityGroupFormFields extends StatelessWidget {
  final AddPriorityGroupFormController controller;

  const PriorityGroupFormFields({
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
            CustomTextFormField(
              icon: const Icon(Icons.group_rounded),
              label: FormLabels.groupCode,
              initialValue: controller.priorityGroupStore.code,
              validatorType: ValidatorType.name,
              onChanged: (String? value) =>
                  controller.priorityGroupStore.code = value,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.groupName,
              initialValue: controller.priorityGroupStore.name,
              validatorType: ValidatorType.optionalName,
              onChanged: (String? value) =>
                  controller.priorityGroupStore.name = value,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.description_rounded),
              label: FormLabels.groupDescription,
              initialValue: controller.priorityGroupStore.description,
              validatorType: ValidatorType.description,
              onChanged: (String? value) =>
                  controller.priorityGroupStore.description = value,
              onSaved: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
