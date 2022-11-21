import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityList/infra/establishment/add_establishment_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class EstablishmentFormFields extends StatefulWidget {
  final AddEstablishmentFormController controller;

  const EstablishmentFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<EstablishmentFormFields> createState() =>
      EstablishmentFormFieldsState();
}

class EstablishmentFormFieldsState extends State<EstablishmentFormFields> {
  List<Locality> _localityCities = List<Locality>.empty(growable: true);

  @override
  void initState() {
    _getCities();
    super.initState();
  }

  Future<void> _getCities() async {
    _localityCities = await widget.controller.getCitiesFromLocalities();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: ListView(
          shrinkWrap: true,
          semanticChildCount: 3,
          children: [
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.pin_rounded),
              label: FormLabels.establishmentLocalityName,
              items:
                  _localityCities.map<String>((Locality l) => l.city).toList(),
              value: widget.controller.locality?.city,
              onChanged: (String? city) => setState(
                () => widget.controller.locality =
                    _localityCities.singleWhere((lc) => lc.city == city),
              ),
              onSaved: (String? city) => widget.controller.locality =
                  _localityCities.singleWhere((lc) => lc.city == city),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.local_hospital_rounded),
              label: FormLabels.establishmentCNES,
              textEditingController: widget.controller.cnes,
              validatorType: ValidatorType.cnes,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.establishmentName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
