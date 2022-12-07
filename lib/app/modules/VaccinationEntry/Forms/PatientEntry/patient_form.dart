import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/form_padding.dart';
import 'package:nurse/app/components/sex_icon.dart';
import 'package:nurse/app/modules/VaccinationEntry/Forms/PatientEntry/patient_form_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_dropdown_button_form_field.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/custom_text_form_field.dart';
import 'package:nurse/app/utils/form_labels.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/utils/validator.dart';

class PatientForm extends StatefulWidget {
  final PatientFormController controller;

  const PatientForm(this.controller, {Key? key}) : super(key: key);

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: FormPadding(
        child: ListView(
          children: [
            CustomTextFormField(
              icon: const Icon(Icons.badge_rounded),
              label: FormLabels.patientCns,
              textEditingController: widget.controller.cns,
              validatorType: ValidatorType.cns,
              onChanged: (String? value) async {
                await widget.controller.findPatientByCns(value);
              },
              onSaved: (value) =>
                  setState(() => widget.controller.cns.text = value ?? ""),
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.badge_rounded),
              label: FormLabels.patientCpf,
              textEditingController: widget.controller.cpf,
              validatorType: ValidatorType.cpf,
              onChanged: (String? value) async {
                await widget.controller.findPatientByCpf(value);
              },
              onSaved: (value) =>
                  setState(() => widget.controller.cpf.text = value ?? ""),
            ),
            const Divider(color: Colors.black),
            CustomTextFormField(
              icon: const Icon(Icons.abc_rounded),
              label: FormLabels.patientName,
              textEditingController: widget.controller.name,
              validatorType: ValidatorType.name,
              onSaved: (value) {},
            ),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon: SexIcon(widget.controller.sex),
                label: FormLabels.sex,
                items: Sex.values,
                value: widget.controller.sex,
                isEnum: true,
                onChanged: (Sex? value) => widget.controller.sex = value,
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon: const Icon(Icons.category_rounded),
                label: FormLabels.categoryName,
                items: widget.controller.categories,
                value: widget.controller.selectedCategory,
                onChanged: (PriorityCategory? value) =>
                    widget.controller.selectedCategory = value,
              );
            }),
            const Divider(color: Colors.black),
            Observer(builder: (_) {
              return CustomDropdownButtonFormField(
                icon: const Icon(Icons.pregnant_woman_rounded),
                label: FormLabels.maternalCondition,
                items: widget.controller.sex == Sex.male
                    ? [MaternalCondition.nenhum]
                    : MaternalCondition.values,
                value: widget.controller.maternalCondition,
                isEnum: true,
                onChanged: (MaternalCondition? value) => widget.controller
                    .maternalCondition = value ?? MaternalCondition.nenhum,
              );
            }),
          ],
        ),
      ),
    );
  }

  // Future<bool?> showConfirmationRequestDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
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
  //           children: <Widget>[
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
