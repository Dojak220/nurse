import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/entity_page_controller.dart";
import "package:nurse/shared/models/vaccination/vaccine_model.dart";
import "package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart";
import "package:nurse/shared/repositories/vaccination/vaccine_repository.dart";

part "vaccine_page_controller.g.dart";

class VaccinesPageController = _VaccinesPageControllerBase
    with _$VaccinesPageController;

abstract class _VaccinesPageControllerBase extends EntityPageController<Vaccine>
    with Store {
  final VaccineRepository vaccineRepository;

  @observable
  bool isLoading = true;

  _VaccinesPageControllerBase()
      : vaccineRepository = DatabaseVaccineRepository() {
    getVaccines();
  }

  @action
  Future<List<Vaccine>> getVaccines() async {
    final result = await vaccineRepository.getVaccines();

    entities
      ..clear()
      ..addAll(
        result..sort((Vaccine a, Vaccine b) => a.name.compareTo(b.name)),
      );

    isLoading = false;

    return entities;
  }
}
