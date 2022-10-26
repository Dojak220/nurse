import 'package:flutter/material.dart';
import 'package:nurse/app/components/registration_failed_alert_dialog.dart';
import 'package:nurse/app/utils/add_form_controller.dart';

void tryToSave(
  AddFormController controller, {
  required BuildContext context,
  required bool mounted,
  required String entityName,
  required bool isEditing,
}) async {
  final wasSaved =
      await (isEditing ? controller.updateInfo() : controller.saveInfo());

  if (wasSaved) {
    if (!mounted) return;
    Navigator.of(context).pop();
  } else {
    showDialog<void>(
      context: context,
      builder: (_) {
        return RegistrationFailedAlertDialog(entityName: entityName);
      },
    );
  }
}
