import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/entity_page_controller.dart";
import "package:nurse/shared/models/vaccination/applier_model.dart";
import "package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart";
import "package:nurse/shared/repositories/vaccination/applier_repository.dart";

part "applier_page_controller.g.dart";

class AppliersPageController = _AppliersPageControllerBase
    with _$AppliersPageController;

abstract class _AppliersPageControllerBase extends EntityPageController<Applier>
    with Store {
  final ApplierRepository applierRepository;

  @observable
  bool isLoading = true;

  _AppliersPageControllerBase()
      : applierRepository = DatabaseApplierRepository() {
    getAppliers();
  }

  @action
  Future<List<Applier>> getAppliers() async {
    final result = await applierRepository.getAppliers();

    entities
      ..clear()
      ..addAll(
        result
          ..sort(
            (Applier a, Applier b) => a.person.name.compareTo(b.person.name),
          ),
      );

    isLoading = false;

    return entities;
  }
}
