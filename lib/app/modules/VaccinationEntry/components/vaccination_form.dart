import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field%20.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_cancel_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/utils/validator.dart';
import 'package:provider/provider.dart';

class VaccinationForm extends StatefulWidget {
  const VaccinationForm({Key? key}) : super(key: key);

  @override
  State<VaccinationForm> createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VaccinationEntryController>(context);

    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListView(
          children: [
            CustomTextFormField(
              icon: Icon(Icons.badge),
              label: FormLabels.cnsPatient,
              validatorType: ValidatorType.CNS,
              onSaved: (value) => {controller.patientCNSValue = value!},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.local_shipping),
              label: FormLabels.batchNumber,
              validatorType: ValidatorType.NumericalString,
              onSaved: (value) => {controller.batchValue = value!},
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: Icon(Icons.vaccines),
              label: FormLabels.dose,
              items: VaccineDose.values,
              onChanged: (VaccineDose? value) =>
                  {controller.doseValue = value!.name},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.badge),
              label: FormLabels.cnsApplier,
              validatorType: ValidatorType.CNS,
              onSaved: (value) => {controller.applierCNSValue = value!},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.calendar_month),
              label: FormLabels.date,
              validatorType: ValidatorType.PastDate,
              onSaved: (value) => {controller.dateValue = value!},
            ),
            Divider(color: Colors.black),
            CustomTextFormField(
              icon: Icon(Icons.group),
              label: FormLabels.group,
              validatorType: ValidatorType.Name,
              onSaved: (value) => {controller.groupValue = value!},
            ),
            Divider(color: Colors.black),
            CustomDropdownButtonFormField(
              icon: Icon(Icons.pregnant_woman),
              label: FormLabels.maternalCondition,
              items: MaternalCondition.values,
              onChanged: (MaternalCondition? value) =>
                  {controller.doseValue = value!.name},
            ),
          ],
        ),
      ),
    );
  }

  // Future<bool?> showConfirmationRequestDialog(BuildContext ctx) {
  //   return showDialog(
  //     context: ctx,
  //     builder: (context) {
  //       final controller = Provider.of<VaccinationEntryController>(context);

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
