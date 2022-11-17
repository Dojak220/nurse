import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';

class EstablishmentsPageController extends EntityPageController<Establishment> {
  final EstablishmentRepository establishmentRepository;

  EstablishmentsPageController()
      : establishmentRepository = DatabaseEstablishmentRepository() {
    getEstablishments();
  }

  Future<List<Establishment>> getEstablishments() async {
    final result = await establishmentRepository.getEstablishments();

    entities
      ..clear()
      ..addAll(result);

    return entities;
  }
}
