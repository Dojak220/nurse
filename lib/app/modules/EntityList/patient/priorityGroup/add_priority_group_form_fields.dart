import "package:flutter/material.dart";
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/add_priority_group_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/utils/validator.dart";

class PriorityGroupFormFields extends StatefulWidget {
  final AddPriorityGroupFormController controller;

  const PriorityGroupFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PriorityGroupFormFields> createState() =>
      PriorityGroupFormFieldsState();
}

class PriorityGroupFormFieldsState extends State<PriorityGroupFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.group_rounded),
              label: FormLabels.groupCode,
              textEditingController: widget.controller.code,
              validatorType: ValidatorType.name,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.groupName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.description_rounded),
              label: FormLabels.groupDescription,
              textEditingController: widget.controller.description,
              validatorType: ValidatorType.description,
              onSaved: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
