import 'package:mobx/mobx.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class VaccinesPageController extends EntityPageController<Vaccine> {
  final VaccineRepository vaccineRepository;

  late final fetchVaccines = Action(getVaccines);

  VaccinesPageController() : vaccineRepository = DatabaseVaccineRepository() {
    getVaccines();
  }

  Future<List<Vaccine>> getVaccines() async {
    final result = await vaccineRepository.getVaccines();

    entities
      ..clear()
      ..addAll(result..sort((a, b) => a.name.compareTo(b.name)));

    return entities;
  }
}
