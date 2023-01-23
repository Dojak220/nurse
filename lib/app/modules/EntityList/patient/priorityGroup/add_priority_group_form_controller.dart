import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/patient/priorityGroup/priority_group_store.dart";
import "package:nurse/app/utils/add_form_controller.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";
import "package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart";
import "package:nurse/shared/repositories/patient/priority_group_repository.dart";

part "add_priority_group_form_controller.g.dart";

class AddPriorityGroupFormController = _AddPriorityGroupFormControllerBase
    with _$AddPriorityGroupFormController;

abstract class _AddPriorityGroupFormControllerBase extends AddFormController
    with Store {
  final PriorityGroupRepository _repository;
  final PriorityGroup? initialPriorityGroupInfo;

  @observable
  PriorityGroupStore priorityGroupStore = PriorityGroupStore();

  _AddPriorityGroupFormControllerBase(
    this.initialPriorityGroupInfo, [
    PriorityGroupRepository? priorityGroupRepository,
  ]) : _repository =
            priorityGroupRepository ?? DatabasePriorityGroupRepository() {
    if (initialPriorityGroupInfo != null) {
      priorityGroupStore.setInfo(initialPriorityGroupInfo!);
    }
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final PriorityGroupStore gStore = priorityGroupStore;

      final newPriorityGroup = PriorityGroup(
        code: gStore.code!,
        name: gStore.name!,
        description: gStore.description!,
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
      final PriorityGroupStore gStore = priorityGroupStore;

      final updatedPriorityGroup = initialPriorityGroupInfo!.copyWith(
        code: gStore.code,
        name: gStore.name,
        description: gStore.description,
      );

      return super.updateEntity<PriorityGroup>(
        updatedPriorityGroup,
        _repository.updatePriorityGroup,
      );
    } else {
      return false;
    }
  }

  @override
  void clearAllInfo() {
    priorityGroupStore.clearAllInfo();
  }

  @override
  void dispose() {
    /// Não tem o que ser desalocado aqui
  }
}
