import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/patient/priorityCategory/priority_category_store.dart";
import "package:nurse/app/utils/add_form_controller.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";
import "package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart";
import "package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart";
import "package:nurse/shared/repositories/patient/priority_category_repository.dart";
import "package:nurse/shared/repositories/patient/priority_group_repository.dart";

part "add_priority_category_form_controller.g.dart";

class AddPriorityCategoryFormController = _AddPriorityCategoryFormControllerBase
    with _$AddPriorityCategoryFormController;

abstract class _AddPriorityCategoryFormControllerBase extends AddFormController
    with Store {
  final PriorityGroupRepository _priorityGroupRepository;
  final PriorityCategoryRepository _repository;

  @observable
  ObservableList<PriorityGroup> groups = ObservableList.of(
    List<PriorityGroup>.empty(growable: true),
  );

  final PriorityCategory? initialPriorityCategoryInfo;

  @observable
  PriorityCategoryStore priorityCategoryStore = PriorityCategoryStore();

  _AddPriorityCategoryFormControllerBase(
    this.initialPriorityCategoryInfo, [
    PriorityGroupRepository? priorityGroupRepository,
    PriorityCategoryRepository? priorityCategoryRepository,
  ])  : _priorityGroupRepository =
            priorityGroupRepository ?? DatabasePriorityGroupRepository(),
        _repository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository() {
    if (initialPriorityCategoryInfo != null) {
      priorityCategoryStore.setInfo(initialPriorityCategoryInfo!);
    }

    getPriorityGroups();
  }

  @action
  Future<List<PriorityGroup>> getPriorityGroups() async {
    final priorityGroups = await _priorityGroupRepository.getPriorityGroups();

    groups
      ..clear()
      ..addAll(priorityGroups);

    return priorityGroups;
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final PriorityCategoryStore cStore = priorityCategoryStore;
      final newPriorityCategory = PriorityCategory(
        priorityGroup: cStore.selectedPriorityGroup!,
        code: cStore.code!,
        name: cStore.name!,
        description: cStore.description!,
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
      final PriorityCategoryStore cStore = priorityCategoryStore;
      final updatedPriorityCategory = initialPriorityCategoryInfo!.copyWith(
        priorityGroup: cStore.selectedPriorityGroup,
        code: cStore.code,
        name: cStore.name,
        description: cStore.description,
      );

      return super.updateEntity<PriorityCategory>(
        updatedPriorityCategory,
        _repository.updatePriorityCategory,
      );
    } else {
      return false;
    }
  }

  @override
  void clearAllInfo() {
    priorityCategoryStore.clearAllInfo();
  }

  @override
  void dispose() {
    /// Não tem o que ser desalocado aqui
  }
}
