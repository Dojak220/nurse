import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class AddPriorityCategoryFormController extends AddFormController {
  final PriorityGroupRepository _priorityGroupRepository;
  final PriorityCategoryRepository _repository;
  final PriorityCategory? initialPriorityCategoryInfo;

  PriorityGroup? selectedPriorityGroup;
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  AddPriorityCategoryFormController(
    this.initialPriorityCategoryInfo, [
    PriorityGroupRepository? priorityGroupRepository,
    PriorityCategoryRepository? priorityCategoryRepository,
  ])  : _priorityGroupRepository =
            priorityGroupRepository ?? DatabasePriorityGroupRepository(),
        _repository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository() {
    if (initialPriorityCategoryInfo != null) {
      setInfo(initialPriorityCategoryInfo!);
    }
  }

  Future<List<PriorityGroup>> getPriorityGroups() async {
    final priorityGroups = await _priorityGroupRepository.getPriorityGroups();

    return priorityGroups;
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newPriorityCategory = PriorityCategory(
        priorityGroup: selectedPriorityGroup!,
        code: code.text,
        name: name.text,
        description: description.text,
      );

      return super.createEntity<PriorityCategory>(
        newPriorityCategory,
        _repository.createPriorityCategory,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialPriorityCategoryInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedPriorityCategory = initialPriorityCategoryInfo!.copyWith(
        priorityGroup: selectedPriorityGroup!,
        code: code.text,
        name: name.text,
        description: description.text,
      );

      return super.updateEntity<PriorityCategory>(
        updatedPriorityCategory,
        _repository.updatePriorityCategory,
      );
    } else {
      return false;
    }
  }

  void setInfo(PriorityCategory priorityCategory) {
    selectedPriorityGroup = priorityCategory.priorityGroup;
    code.text = priorityCategory.code;
    name.text = priorityCategory.name;
    description.text = priorityCategory.description;
  }

  @override
  void clearAllInfo() {
    selectedPriorityGroup = null;

    code.clear();
    name.clear();
    description.clear();

    notifyListeners();
  }
}
