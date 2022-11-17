import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';

class PriorityCategoriesPageController
    extends EntityPageController<PriorityCategory> {
  final PriorityCategoryRepository priorityCategoryRepository;

  PriorityCategoriesPageController()
      : priorityCategoryRepository = DatabasePriorityCategoryRepository() {
    getPriorityCategories();
  }

  Future<List<PriorityCategory>> getPriorityCategories() async {
    final result = await priorityCategoryRepository.getPriorityCategories();

    entities
      ..clear()
      ..addAll(result);

    return entities;
  }
}
