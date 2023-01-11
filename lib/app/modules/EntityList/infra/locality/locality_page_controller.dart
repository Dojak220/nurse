import 'package:mobx/mobx.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

part 'locality_page_controller.g.dart';

class LocalitiesPageController = _LocalitiesPageControllerBase
    with _$LocalitiesPageController;

abstract class _LocalitiesPageControllerBase
    extends EntityPageController<Locality> with Store {
  final LocalityRepository localityRepository;

  @observable
  bool isLoading = true;

  _LocalitiesPageControllerBase()
      : localityRepository = DatabaseLocalityRepository() {
    getLocalities();
  }

  @action
  Future<List<Locality>> getLocalities() async {
    final result = await localityRepository.getLocalities();

    entities
      ..clear()
      ..addAll(result);

    isLoading = false;

    return entities;
  }
}
