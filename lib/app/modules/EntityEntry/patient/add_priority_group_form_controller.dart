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
    final newPriorityGroup = PriorityGroup(
      code: code.text,
      name: name.text,
      description: description.text,
    );

    return super.createEntity<PriorityGroup>(
      newPriorityGroup,
      _repository.createPriorityGroup,
    );
  }

  @override
  void clearAllInfo() {
    code.clear();
    name.clear();
    description.clear();

    notifyListeners();
  }
}
