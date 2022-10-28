import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class AddPriorityGroupFormController extends AddFormController {
  final PriorityGroupRepository _repository;
  final PriorityGroup? initialPriorityGroupInfo;

  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  AddPriorityGroupFormController(
    this.initialPriorityGroupInfo, [
    PriorityGroupRepository? priorityGroupRepository,
  ]) : _repository =
            priorityGroupRepository ?? DatabasePriorityGroupRepository() {
    if (initialPriorityGroupInfo != null) {
      setInfo(initialPriorityGroupInfo!);
    }
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newPriorityGroup = PriorityGroup(
        code: code.text,
        name: name.text,
        description: description.text,
      );

      return super.createEntity<PriorityGroup>(
        newPriorityGroup,
        _repository.createPriorityGroup,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialPriorityGroupInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedPriorityGroup = initialPriorityGroupInfo!.copyWith(
        code: code.text,
        name: name.text,
        description: description.text,
      );

      return super.updateEntity<PriorityGroup>(
        updatedPriorityGroup,
        _repository.updatePriorityGroup,
      );
    } else {
      return false;
    }
  }

  void setInfo(PriorityGroup priorityGroup) {
    code.text = priorityGroup.code;
    name.text = priorityGroup.name;
    description.text = priorityGroup.description;
  }

  @override
  void clearAllInfo() {
    code.clear();
    name.clear();
    description.clear();

    notifyListeners();
  }
}
