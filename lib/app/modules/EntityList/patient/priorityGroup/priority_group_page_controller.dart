import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/entity_page_controller.dart";

import "package:nurse/shared/models/patient/priority_group_model.dart";
import "package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart";
import "package:nurse/shared/repositories/patient/priority_group_repository.dart";

part "priority_group_page_controller.g.dart";

class PriorityGroupsPageController = _PriorityGroupsPageControllerBase
    with _$PriorityGroupsPageController;

abstract class _PriorityGroupsPageControllerBase
    extends EntityPageController<PriorityGroup> with Store {
  final PriorityGroupRepository priorityGroupRepository;

  @observable
  bool isLoading = true;

  _PriorityGroupsPageControllerBase()
      : priorityGroupRepository = DatabasePriorityGroupRepository() {
    getPriorityGroups();
  }

  @action
  Future<List<PriorityGroup>> getPriorityGroups() async {
    final result = await priorityGroupRepository.getPriorityGroups();

    entities
      ..clear()
      ..addAll(result);

    isLoading = false;

    return entities;
  }
}
