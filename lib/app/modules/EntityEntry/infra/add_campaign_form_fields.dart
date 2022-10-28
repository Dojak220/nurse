import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityEntry/infra/add_campaign_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/utils/validator.dart';

class CampaignFormFields extends StatefulWidget {
  final AddCampaignFormController controller;

  const CampaignFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<CampaignFormFields> createState() => _CampaignFormFieldsState();
}

class _CampaignFormFieldsState extends State<CampaignFormFields> {
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
              validatorType: ValidatorType.date,
              onTap: () async => widget.controller.selectStartDate(context),
              readOnly: true,
              onSaved: (_) => widget.controller.selectedStartDate != null,
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.event),
              label: FormLabels.campaignEndDate,
              textEditingController: widget.controller.endDate,
              validatorType: ValidatorType.optionalDate,
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
