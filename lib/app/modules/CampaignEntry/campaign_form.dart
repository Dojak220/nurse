import 'package:flutter/material.dart';
import 'package:nurse/app/modules/CampaignEntry/campaign_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';

class CampaignForm extends StatefulWidget {
  final CampaignFormController controller;

  CampaignForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<CampaignForm> createState() => _CampaignFormState();
}

class _CampaignFormState extends State<CampaignForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: Icon(Icons.campaign),
              label: FormLabels.campaign,
              items: widget.controller.campaigns,
              onChanged: (Campaign? value) =>
                  setState(() => widget.controller.selectedCampaign = value),
            ),
          ],
        ),
      ),
    );
  }
}
