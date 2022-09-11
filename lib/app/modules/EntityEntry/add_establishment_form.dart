import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/components/save_form_button.dart';
import 'package:nurse/app/modules/EntityEntry/add_establishment_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class AddEstablishmentForm extends StatefulWidget {
  final AddEstablishmentFormController controller;

  const AddEstablishmentForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<AddEstablishmentForm> createState() => _AddEstablishmentFormState();
}

class _AddEstablishmentFormState extends State<AddEstablishmentForm> {
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

  void tryToSave(AddEstablishmentFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      showDialog<void>(
        context: context,
        builder: (_) {
          return const RegistrationFailedAlertDialog(
              entityName: "estabelecimento");
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
              child: _EstablishmentFormFields(
                controller: widget.controller,
                localityCities: _localityCities,
              ),
            ),
            SaveFormButton(onPressed: () => tryToSave(widget.controller)),
          ],
        ),
      ),
    );
  }
}

class _EstablishmentFormFields extends StatefulWidget {
  final AddEstablishmentFormController controller;
  final List<Locality> localityCities;

  const _EstablishmentFormFields(
      {Key? key, required this.controller, required this.localityCities})
      : super(key: key);

  @override
  State<_EstablishmentFormFields> createState() =>
      _EstablishmentFormFieldsState();
}

class _EstablishmentFormFieldsState extends State<_EstablishmentFormFields> {
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
              icon: const Icon(Icons.pin),
              label: FormLabels.establishmentLocalityName,
              items: widget.localityCities
                  .map<String>((Locality l) => l.city)
                  .toList(),
              value: widget.controller.locality?.city,
              onChanged: (String? city) => setState(
                () => widget.controller.locality =
                    widget.localityCities.singleWhere((lc) => lc.city == city),
              ),
              onSaved: (String? city) => widget.controller.locality =
                  widget.localityCities.singleWhere((lc) => lc.city == city),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.local_hospital),
              label: FormLabels.establishmentCNES,
              textEditingController: widget.controller.cnes,
              validatorType: ValidatorType.cnes,
              onSaved: (value) => {},
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              icon: const Icon(Icons.abc),
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
