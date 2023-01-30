import "package:flutter/material.dart";
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/add_establishment_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/utils/validator.dart";

class EstablishmentFormFields extends StatelessWidget {
  final AddEstablishmentFormController controller;

  const EstablishmentFormFields({
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
          semanticChildCount: 3,
          children: [
            Observer(
              builder: (_) {
                return CustomDropdownButtonFormField<String>(
                  icon: const Icon(Icons.pin_rounded),
                  label: FormLabels.establishmentLocalityName,
                  items: controller.localityCities
                      .map<String>((Locality l) => l.city)
                      .toList(),
                  value: controller.establishmentStore.selectedLocality?.city,
                  onChanged: (String? city) =>
                      controller.establishmentStore.selectedLocality =
                          controller.localityCities
                              .singleWhere((Locality lc) => lc.city == city),
                  onSaved: (String? city) =>
                      controller.establishmentStore.selectedLocality =
                          controller.localityCities
                              .singleWhere((Locality lc) => lc.city == city),
                );
              },
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.local_hospital_rounded),
                  label: FormLabels.establishmentCNES,
                  initialValue: controller.establishmentStore.cnes,
                  validatorType: ValidatorType.cnes,
                  onChanged: (String? value) =>
                      controller.establishmentStore.cnes = value,
                  onSaved: (_) {},
                );
              },
            ),
            const SizedBox(height: 16),
            Observer(
              builder: (_) {
                return CustomTextFormField(
                  icon: const Icon(Icons.abc_rounded),
                  label: FormLabels.establishmentName,
                  initialValue: controller.establishmentStore.name,
                  validatorType: ValidatorType.name,
                  onChanged: (String? value) =>
                      controller.establishmentStore.name = value,
                  onSaved: (_) {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
