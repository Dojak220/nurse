import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';

class AppliersPageController extends EntityPageController<Applier> {
  final ApplierRepository applierRepository;

  AppliersPageController() : applierRepository = DatabaseApplierRepository() {
    getAppliers();
  }

  Future<List<Applier>> getAppliers() async {
    final result = await applierRepository.getAppliers();

    entities
      ..clear()
      ..addAll(result..sort((a, b) => a.person.name.compareTo(b.person.name)));

    return entities;
  }
}
