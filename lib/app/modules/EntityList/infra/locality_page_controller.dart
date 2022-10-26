import 'package:mobx/mobx.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class LocalitiesPageController extends EntityPageController<Locality> {
  final LocalityRepository localityRepository;

  late final fetchLocalities = Action(getLocalities);

  LocalitiesPageController()
      : localityRepository = DatabaseLocalityRepository() {
    getLocalities();
  }

  Future<List<Locality>> getLocalities() async {
    final result = await localityRepository.getLocalities();

    entities
      ..clear()
      ..addAll(result);

    return entities;
  }
}
