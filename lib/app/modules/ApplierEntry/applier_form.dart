import 'package:flutter/material.dart';
import 'package:nurse/app/modules/ApplierEntry/applier_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';

class ApplierForm extends StatefulWidget {
  final ApplierFormController controller;

  ApplierForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<ApplierForm> createState() => _ApplierFormState();
}

class _ApplierFormState extends State<ApplierForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: Icon(Icons.local_hospital),
              label: FormLabels.establishment,
              items: widget.controller.establishments,
              onChanged: (Establishment? value) => setState(
                  () => widget.controller.selectedEstablishment = value),
              onSaved: (Establishment? value) =>
                  widget.controller.selectedEstablishment = value,
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: Icon(Icons.person),
              label: FormLabels.applierName,
              items: widget.controller.appliers,
              onChanged: (Applier? value) =>
                  setState(() => widget.controller.selectedApplier = value),
              onSaved: (Applier? value) =>
                  widget.controller.selectedApplier = value,
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
