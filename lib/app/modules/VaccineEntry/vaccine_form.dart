import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/modules/VaccineEntry/vaccine_form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class VaccineForm extends StatefulWidget {
  final VaccineFormController controller;

  VaccineForm({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<VaccineForm> createState() => _VaccineFormState();
}

class _VaccineFormState extends State<VaccineForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomTextFormField(
              icon: Icon(Icons.code),
              label: FormLabels.vaccineSipniCode,
              validatorType: ValidatorType.NumericalString,
              onSaved: (value) =>
                  setState(() => widget.controller.sipniCode = value),
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.abc),
              label: FormLabels.vaccineName,
              validatorType: ValidatorType.Name,
              onSaved: (value) =>
                  setState(() => widget.controller.name = value),
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.local_pharmacy),
              label: FormLabels.vaccineLaboratory,
              validatorType: ValidatorType.Name,
              onSaved: (value) =>
                  setState(() => widget.controller.laboratory = value),
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: Icon(Icons.batch_prediction),
              label: FormLabels.vaccineBatch,
              items: widget.controller.vaccineBatches,
              onChanged: (VaccineBatch? value) =>
                  setState(() => widget.controller.selectedBatch = value),
            ),
          ],
        ),
      ),
    );
  }

  // Future<bool?> showConfirmationRequestDialog(BuildContext ctx) {
  //   return showDialog(
  //     context: ctx,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             const Icon(
  //               Icons.question_mark_rounded,
  //               size: 120.0,
  //             ),
  //             Text(
  //               'Deseja finalizar o cadastro?',
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           DialogConfirmButton(onPressed: () {
  //             controller.submitForm();
  //             Navigator.pop(ctx, controller.formKey.currentState!.validate());
  //           }),
  //           DialogCancelButton(),
  //         ],
  //         actionsAlignment: MainAxisAlignment.spaceAround,
  //       );
  //     },
  //   );
  // }

  // Future<bool?> showConfirmationDialog(BuildContext ctx) {
  //   return showDialog(
  //     context: ctx,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             const Icon(Icons.check_sharp, size: 120.0),
  //             Text(
  //               'Cadastro realizado com sucesso!',
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //         content: Text(
  //           'Deseja fazer outro cadastro?',
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: [
  //           DialogConfirmButton(),
  //           DialogCancelButton(onPressed: () {
  //             Navigator.pushReplacementNamed(ctx, "/");
  //           }),
  //         ],
  //         actionsAlignment: MainAxisAlignment.spaceAround,
  //       );
  //     },
  //   );
  // }
}
