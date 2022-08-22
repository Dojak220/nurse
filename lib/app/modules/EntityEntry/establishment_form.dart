import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityEntry/establishment_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class EstablishmentForm extends StatefulWidget {
  final EstablishmentFormController controller;

  EstablishmentForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<EstablishmentForm> createState() => _EstablishmentFormState();
}

class _EstablishmentFormState extends State<EstablishmentForm> {
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

  void tryToSave(EstablishmentFormController controller) async {
    final wasSaved = await controller.saveInfo();

    if (wasSaved) {
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return RegistrationFailedAlertDialog(entityName: "estabelecimento");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args["title"],
          style: TextStyle(
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                child: ElevatedButton(
                  style: AppTheme.stepButtonStyle,
                  onPressed: () => tryToSave(widget.controller),
                  child: Text("Salvar"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstablishmentFormFields extends StatefulWidget {
  final EstablishmentFormController controller;
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
              icon: Icon(Icons.pin),
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
            SizedBox(height: 16),
            CustomTextFormField(
              icon: Icon(Icons.local_hospital),
              label: FormLabels.establishmentCNES,
              textEditingController: widget.controller.cnes,
              validatorType: ValidatorType.CNES,
              onSaved: (value) => {},
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              icon: Icon(Icons.abc),
              label: FormLabels.establishmentName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.Name,
              onSaved: (value) => {},
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationFailedAlertDialog extends StatelessWidget {
  final String entityName;

  const RegistrationFailedAlertDialog({
    Key? key,
    required this.entityName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.warning, size: 120.0),
          Text(
            'Falha ao cadastrar novo(a) $entityName!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Text(
        'Cadastro já existia no banco de dados!',
        textAlign: TextAlign.center,
      ),
      actions: [DialogConfirmButton(text: "Ok")],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
