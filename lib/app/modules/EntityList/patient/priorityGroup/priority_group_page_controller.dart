import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class PriorityGroupsPageController extends EntityPageController<PriorityGroup> {
  final PriorityGroupRepository priorityGroupRepository;

  PriorityGroupsPageController()
      : priorityGroupRepository = DatabasePriorityGroupRepository() {
    getPriorityGroups();
  }

  Future<List<PriorityGroup>> getPriorityGroups() async {
    final result = await priorityGroupRepository.getPriorityGroups();
    entities
      ..clear()
      ..addAll(result);

    return entities;
  }
}
