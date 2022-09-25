import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_category_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddPriorityCategoryForm extends StatefulWidget {
  final AddPriorityCategoryFormController controller;

  const AddPriorityCategoryForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddPriorityCategoryForm> createState() =>
      _AddPriorityCategoryFormState();
}

class _AddPriorityCategoryFormState extends State<AddPriorityCategoryForm> {
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

  void tryToSave(AddPriorityCategoryFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(
            entityName: "categoria prioritária",
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args["title"]!,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _PriorityCategoryFormFields(
                controller: widget.controller,
                groups: _groups,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.stepButtonStyle,
                  onPressed: () => tryToSave(widget.controller),
                  child: const Text("Salvar"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class _PriorityCategoryFormFields extends StatefulWidget {
  final AddPriorityCategoryFormController controller;
  final List<PriorityGroup> groups;

  const _PriorityCategoryFormFields({
    Key? key,
    required this.controller,
    required this.groups,
  }) : super(key: key);

  @override
  State<_PriorityCategoryFormFields> createState() =>
      _PriorityCategoryFormFieldsState();
}

class _PriorityCategoryFormFieldsState
    extends State<_PriorityCategoryFormFields> {
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
              items: widget.groups,
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
