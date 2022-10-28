import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_category_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PriorityCategoryFormFields extends StatefulWidget {
  final AddPriorityCategoryFormController controller;

  const PriorityCategoryFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PriorityCategoryFormFields> createState() =>
      PriorityCategoryFormFieldsState();
}

class PriorityCategoryFormFieldsState
    extends State<PriorityCategoryFormFields> {
  List<PriorityGroup> _groups = List<PriorityGroup>.empty(growable: true);

  @override
  void initState() {
    _getPriorityCategories();
    super.initState();
  }

  Future<void> _getPriorityCategories() async {
    _groups = await widget.controller.getPriorityGroups();
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
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.group),
              label: FormLabels.categoryGroup,
              items: _groups,
              value: widget.controller.selectedPriorityGroup,
              onChanged: (PriorityGroup? value) => setState(
                  () => widget.controller.selectedPriorityGroup = value),
              onSaved: (PriorityGroup? value) =>
                  widget.controller.selectedPriorityGroup = value,
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.category),
              label: FormLabels.categoryCode,
              textEditingController: widget.controller.code,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.categoryName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.description),
              label: FormLabels.categoryDescription,
              textEditingController: widget.controller.description,
              validatorType: ValidatorType.description,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
