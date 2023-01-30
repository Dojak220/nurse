import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/EntityList/infra/campaign/add_campaign_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/utils/validator.dart";

class CampaignFormFields extends StatelessWidget {
  final AddCampaignFormController controller;

  const CampaignFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: FormPadding(
        child: ListView(
          shrinkWrap: true,
          semanticChildCount: 4,
          children: [
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.abc_rounded),
                  label: FormLabels.campaignName,
                  initialValue: controller.campaignStore.title,
                  validatorType: ValidatorType.name,
                  onChanged: (String? value) =>
                      controller.campaignStore.title = value,
                  onSaved: (_) {},
                );
              },
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.description_rounded),
                  label: FormLabels.campaignDescription,
                  initialValue: controller.campaignStore.description,
                  validatorType: ValidatorType.optionalName,
                  onChanged: (String? value) =>
                      controller.campaignStore.description = value,
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.today_rounded),
                  label: FormLabels.campaignStartDate,
                  readOnly: true,
                  textEditingController: controller.campaignStore.startDate,
                  validatorType: ValidatorType.date,
                  onTap: () async =>
                      controller.campaignStore.selectStartDate(context),
                  onSaved: (_) {},
                );
              },
            ),
            const Divider(color: Colors.black),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.event_rounded),
                  label: FormLabels.campaignEndDate,
                  textEditingController: controller.campaignStore.endDate,
                  validatorType: ValidatorType.optionalDate,
                  onTap: () async =>
                      controller.campaignStore.selectEndDate(context),
                  readOnly: true,
                  onSaved: (_) {},
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
