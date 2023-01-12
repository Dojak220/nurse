import "package:flutter/material.dart";
import "package:nurse/app/components/form_padding.dart";
import "package:nurse/app/modules/VaccinationEntry/Forms/ApplicationEntry/application_form_controller.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart";
import "package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart";
import "package:nurse/app/utils/form_labels.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";
import "package:nurse/shared/utils/validator.dart";

class ApplicationForm extends StatefulWidget {
  final ApplicationFormController controller;

  const ApplicationForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            CustomDropdownButtonFormField(
              icon: const Icon(Icons.vaccines_rounded),
              label: FormLabels.dose,
              items: VaccineDose.values,
              onChanged: (VaccineDose? value) =>
                  {widget.controller.selectedDose = value!.name},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.calendar_month_rounded),
              label: FormLabels.applicationDate,
              textEditingController: widget.controller.date,
              validatorType: ValidatorType.pastDate,
              onTap: () async => widget.controller.selectDate(context),
              readOnly: true,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.person_rounded),
              label: FormLabels.applierName,
              textEditingController: widget.controller.applierName,
              validatorType: ValidatorType.name,
              readOnly: true,
              enabled: false,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.vaccines_rounded),
              label: FormLabels.vaccineBatch,
              validatorType: null,
              readOnly: true,
              enabled: false,
              textEditingController: widget.controller.vaccineBatchNumber,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.person_rounded),
              label: FormLabels.patientName,
              validatorType: ValidatorType.name,
              readOnly: true,
              enabled: false,
              textEditingController: widget.controller.patientName,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.campaign_rounded),
              label: FormLabels.campaignName,
              validatorType: ValidatorType.name,
              readOnly: true,
              enabled: false,
              textEditingController: widget.controller.campaignTitle,
              onSaved: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  // Future<bool?> showConfirmationRequestDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (context) {
  //       final controller = Provider.of<VaccinationEntryController>(context);

  //       return AlertDialog(
  //         title: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Icon(
  //               Icons.question_mark_rounded,
  //               size: 120.0,
  //             ),
  //             const Text(
  //               'Deseja finalizar o cadastro?',
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           DialogConfirmButton(onPressed: () {
  //             controller.submitForm();
  //             Navigator.pop(context, controller.formKey.currentState!.validate());
  //           }),
  //           DialogCancelButton(),
  //         ],
  //         actionsAlignment: MainAxisAlignment.spaceAround,
  //       );
  //     },
  //   );
  // }

  // Future<bool?> showConfirmationDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Icon(Icons.check_rounded, size: 120.0),
  //             const Text(
  //               'Cadastro realizado com sucesso!',
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //         content: const Text(
  //           'Deseja fazer outro cadastro?',
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: [
  //           DialogConfirmButton(),
  //           DialogCancelButton(onPressed: () {
  //             Navigator.pushReplacementNamed(context, "/");
  //           }),
  //         ],
  //         actionsAlignment: MainAxisAlignment.spaceAround,
  //       );
  //     },
  //   );
  // }
}
