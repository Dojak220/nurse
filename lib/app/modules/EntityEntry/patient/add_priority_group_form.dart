import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/modules/EntityEntry/patient/add_priority_group_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddPriorityGroupForm extends StatefulWidget {
  final AddPriorityGroupFormController controller;

  const AddPriorityGroupForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddPriorityGroupForm> createState() => _AddPriorityGroupFormState();
}

class _AddPriorityGroupFormState extends State<AddPriorityGroupForm> {
  void tryToSave(AddPriorityGroupFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(
            entityName: "grupo prioritário",
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
              child: _PriorityGroupFormFields(
                controller: widget.controller,
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

class _PriorityGroupFormFields extends StatefulWidget {
  final AddPriorityGroupFormController controller;

  const _PriorityGroupFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<_PriorityGroupFormFields> createState() =>
      _PriorityGroupFormFieldsState();
}

class _PriorityGroupFormFieldsState extends State<_PriorityGroupFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.group),
              label: FormLabels.groupCode,
              textEditingController: widget.controller.code,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.groupName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.description),
              label: FormLabels.groupDescription,
              textEditingController: widget.controller.description,
              validatorType: ValidatorType.description,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
