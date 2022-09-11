import 'package:flutter/material.dart';
import 'package:nurse/app/modules/Forms/CampaignEntry/campaign_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';

class CampaignForm extends StatefulWidget {
  final CampaignFormController controller;

  const CampaignForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<CampaignForm> createState() => _CampaignFormState();
}

class _CampaignFormState extends State<CampaignForm> {
  List<Campaign> _campaigns = List<Campaign>.empty(growable: true);

  @override
  void initState() {
    getCampaigns();

    super.initState();
  }

  Future<void> getCampaigns() async {
    _campaigns = await widget.controller.getCampaigns();
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
              icon: const Icon(Icons.campaign),
              label: FormLabels.campaignName,
              items: _campaigns,
              onChanged: (Campaign? value) =>
                  setState(() => widget.controller.selectedCampaign = value),
              onSaved: (Campaign? value) =>
                  widget.controller.selectedCampaign = value,
            ),
          ],
        ),
      ),
    );
  }
}
