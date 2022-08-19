import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityEntry/establishment_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/shared/utils/validator.dart';

class EstablishmentForm extends StatefulWidget {
  final EstablishmentFormController controller;

  EstablishmentForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<EstablishmentForm> createState() => _EstablishmentFormState();
}

class _EstablishmentFormState extends State<EstablishmentForm> {
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
        child: Form(
          key: widget.controller.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListView(
              children: [
                CustomTextFormField(
                  icon: Icon(Icons.local_hospital),
                  label: FormLabels.establishmentCNES,
                  textEditingController: widget.controller.cnes,
                  validatorType: ValidatorType.CNES,
                  onSaved: (value) => {},
                ),
                Divider(color: Colors.black),
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
        ),
      ),
    );
  }
}
