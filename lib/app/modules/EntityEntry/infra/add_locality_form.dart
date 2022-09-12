import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/components/save_form_button.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_locality_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddLocalityForm extends StatefulWidget {
  final AddLocalityFormController controller;

  const AddLocalityForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddLocalityForm> createState() => _AddLocalityFormState();
}

class _AddLocalityFormState extends State<AddLocalityForm> {
  void tryToSave(AddLocalityFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(entityName: "localidade");
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
              child: _LocalityFormFields(controller: widget.controller),
            ),
            SaveFormButton(onPressed: () => tryToSave(widget.controller)),
          ],
        ),
      ),
    );
  }
}

class _LocalityFormFields extends StatefulWidget {
  final AddLocalityFormController controller;

  const _LocalityFormFields({Key? key, required this.controller})
      : super(key: key);

  @override
  State<_LocalityFormFields> createState() => _LocalityFormFieldsState();
}

class _LocalityFormFieldsState extends State<_LocalityFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          semanticChildCount: 4,
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.abc),
              label: FormLabels.localityName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.location_city),
              label: FormLabels.localityCity,
              textEditingController: widget.controller.city,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.map),
              label: FormLabels.localityState,
              textEditingController: widget.controller.state,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.numbers),
              label: FormLabels.localityCode,
              textEditingController: widget.controller.ibgeCode,
              validatorType: ValidatorType.ibgeCode,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
