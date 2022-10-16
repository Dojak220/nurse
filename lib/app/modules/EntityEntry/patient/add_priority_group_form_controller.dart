import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class AddPriorityGroupFormController extends AddFormController {
  final PriorityGroupRepository _repository;

  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  AddPriorityGroupFormController([
    PriorityGroupRepository? priorityGroupRepository,
  ]) : _repository =
            priorityGroupRepository ?? DatabasePriorityGroupRepository();

  @override
  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createPriorityGroup(
          PriorityGroup(
            code: code.text,
            name: name.text,
            description: description.text,
          ),
        );

        if (id != 0) {
          clearAllInfo();
          return true;
        } else {
          return false;
        }
      } catch (error) {
        print(error);
        return false;
      }
    }

    return false;
  }

  @override
  void clearAllInfo() {
    code.clear();
    name.clear();
    description.clear();

    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
