import 'package:mobx/mobx.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';

class VaccineBatchesPageController extends EntityPageController<VaccineBatch> {
  final VaccineBatchRepository vaccineBatchRepository;

  late final fetchVaccineBatches = Action(getVaccineBatches);

  VaccineBatchesPageController()
      : vaccineBatchRepository = DatabaseVaccineBatchRepository() {
    getVaccineBatches();
  }

  Future<List<VaccineBatch>> getVaccineBatches() async {
    final result = await vaccineBatchRepository.getVaccineBatches();

    entities
      ..clear()
      ..addAll(result);

    return entities;
  }
}
