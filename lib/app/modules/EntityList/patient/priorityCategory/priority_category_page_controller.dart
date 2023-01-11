import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';

import 'package:mobx/mobx.dart';
part 'priority_category_page_controller.g.dart';

class PriorityCategoriesPageController = _PriorityCategoriesPageControllerBase
    with _$PriorityCategoriesPageController;

abstract class _PriorityCategoriesPageControllerBase
    extends EntityPageController<PriorityCategory> with Store {
  final PriorityCategoryRepository priorityCategoryRepository;

  @observable
  bool isLoading = true;

  _PriorityCategoriesPageControllerBase()
      : priorityCategoryRepository = DatabasePriorityCategoryRepository() {
    getPriorityCategories();
  }

  @action
  Future<List<PriorityCategory>> getPriorityCategories() async {
    final result = await priorityCategoryRepository.getPriorityCategories();

    entities
      ..clear()
      ..addAll(result);

    isLoading = false;

    return entities;
  }
}
