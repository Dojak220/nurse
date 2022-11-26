import 'package:flutter/material.dart';
import 'package:nurse/app/components/sex_icon.dart';
import 'package:nurse/app/modules/EntityList/vaccination/applier/add_applier_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class ApplierFormFields extends StatefulWidget {
  final AddApplierFormController controller;

  const ApplierFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ApplierFormFields> createState() => ApplierFormFieldsState();
}

class ApplierFormFieldsState extends State<ApplierFormFields> {
  List<Locality> _localities = List<Locality>.empty(growable: true);
  List<Establishment> _establishments =
      List<Establishment>.empty(growable: true);

  @override
  void initState() {
    _getLocalities();
    _getEstablishments();
    super.initState();
  }

  Future<void> _getLocalities() async {
    _localities = await widget.controller.getLocalities();
    setState(() {});
  }

  Future<void> _getEstablishments() async {
    _establishments = await widget.controller.getEstablishments();
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
              icon: const Icon(Icons.local_hospital_rounded),
              label: FormLabels.establishmentCNES,
              items: _establishments,
              value: widget.controller.selectedEstablishment,
              onChanged: (Establishment? value) => setState(
                  () => widget.controller.selectedEstablishment = value),
              onSaved: (Establishment? value) =>
                  widget.controller.selectedEstablishment = value,
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.applierName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge_rounded),
              label: FormLabels.applierCns,
              textEditingController: widget.controller.cns,
              validatorType: ValidatorType.cns,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge_rounded),
              label: FormLabels.applierCpf,
              textEditingController: widget.controller.cpf,
              validatorType: ValidatorType.cpf,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.calendar_month_rounded),
              label: FormLabels.birthDate,
              textEditingController: widget.controller.birthDate,
              validatorType: ValidatorType.birthDate,
              onTap: () async => widget.controller.selectDate(context),
              readOnly: true,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.pin_rounded),
              label: FormLabels.establishmentLocalityName,
              items: _localities,
              value: widget.controller.selectedLocality,
              onChanged: (Locality? value) =>
                  setState(() => widget.controller.selectedLocality = value),
              onSaved: (Locality? value) =>
                  setState(() => widget.controller.selectedLocality = value),
            ),
            const Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: SexIcon(widget.controller.selectedSex),
              label: FormLabels.sex,
              items: Sex.values,
              value: widget.controller.selectedSex,
              isEnum: true,
              onChanged: (Sex? value) => setState(() {
                widget.controller.selectedSex = value!;
              }),
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.motherName,
              textEditingController: widget.controller.motherName,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.fatherName,
              textEditingController: widget.controller.fatherName,
              validatorType: ValidatorType.optionalName,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}
