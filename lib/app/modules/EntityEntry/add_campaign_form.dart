import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/components/save_form_button.dart';
import 'package:nurse/app/modules/EntityEntry/add_campaign_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddCampaignForm extends StatefulWidget {
  final AddCampaignFormController controller;

  const AddCampaignForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddCampaignForm> createState() => _AddCampaignFormState();
}

class _AddCampaignFormState extends State<AddCampaignForm> {
  void tryToSave(AddCampaignFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(entityName: "campaign");
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
              child: _CampaignFormFields(controller: widget.controller),
            ),
            SaveFormButton(onPressed: () => tryToSave(widget.controller)),
          ],
        ),
      ),
    );
  }
}

class _CampaignFormFields extends StatefulWidget {
  final AddCampaignFormController controller;

  const _CampaignFormFields({Key? key, required this.controller})
      : super(key: key);

  @override
  State<_CampaignFormFields> createState() => _CampaignFormFieldsState();
}

class _CampaignFormFieldsState extends State<_CampaignFormFields> {
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
              label: FormLabels.campaignName,
              textEditingController: widget.controller.title,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.description),
              label: FormLabels.campaignDescription,
              textEditingController: widget.controller.description,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.today),
              label: FormLabels.campaignStartDate,
              textEditingController: widget.controller.startDate,
              validatorType: ValidatorType.pastDate,
              onTap: () async => widget.controller.selectStartDate(context),
              readOnly: true,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.event),
              label: FormLabels.campaignEndDate,
              textEditingController: widget.controller.endDate,
              validatorType: ValidatorType.date,
              onTap: () async => widget.controller.selectEndDate(context),
              readOnly: true,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
