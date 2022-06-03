import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_cancel_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/dialog_confirm_button.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class VaccinationForm extends StatefulWidget {
  const VaccinationForm({Key? key}) : super(key: key);

  @override
  State<VaccinationForm> createState() => _VaccinationFormState();
}

class _VaccinationFormState extends State<VaccinationForm> {
  final controller = VaccinationEntryController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.76,
            child: ListView.separated(
              itemCount: controller.fields.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.black),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: controller.fields[i],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                showConfirmationRequestDialog(context).then((value) {
                  if (value != null && value) {
                    showConfirmationDialog(context);
                  }
                });
              },
              style: AppTheme.mainButtonStyle(context),
              child: Text(
                "Cadastrar",
                style: AppTheme.titleTextStyle.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> showConfirmationRequestDialog(BuildContext ctx) {
    return showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.question_mark_rounded,
                size: 120.0,
              ),
              Text(
                'Deseja finalizar o cadastro?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            DialogConfirmButton(onPressed: () {
              controller.submitForm();
              Navigator.pop(ctx, controller.formKey.currentState!.validate());
            }),
            DialogCancelButton(),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
  }

  Future<bool?> showConfirmationDialog(BuildContext ctx) {
    return showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.check_sharp, size: 120.0),
              Text(
                'Cadastro realizado com sucesso!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            'Deseja fazer outro cadastro?',
            textAlign: TextAlign.center,
          ),
          actions: [
            DialogConfirmButton(),
            DialogCancelButton(onPressed: () {
              Navigator.pushReplacementNamed(ctx, "/");
            }),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
  }
}
