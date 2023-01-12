import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/entity_page_controller.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";
import "package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart";
import "package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart";

part "vaccine_batch_page_controller.g.dart";

class VaccineBatchesPageController = _VaccineBatchesPageControllerBase
    with _$VaccineBatchesPageController;

abstract class _VaccineBatchesPageControllerBase
    extends EntityPageController<VaccineBatch> with Store {
  final VaccineBatchRepository vaccineBatchRepository;

  @observable
  bool isLoading = true;

  _VaccineBatchesPageControllerBase()
      : vaccineBatchRepository = DatabaseVaccineBatchRepository() {
    getVaccineBatches();
  }

  @action
  Future<List<VaccineBatch>> getVaccineBatches() async {
    final result = await vaccineBatchRepository.getVaccineBatches();

    entities
      ..clear()
      ..addAll(result);

    isLoading = false;

    return entities;
  }
}
