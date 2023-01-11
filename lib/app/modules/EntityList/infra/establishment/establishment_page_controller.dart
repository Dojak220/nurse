import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';

import 'package:mobx/mobx.dart';
part 'establishment_page_controller.g.dart';

class EstablishmentsPageController = _EstablishmentsPageControllerBase
    with _$EstablishmentsPageController;

abstract class _EstablishmentsPageControllerBase
    extends EntityPageController<Establishment> with Store {
  final EstablishmentRepository establishmentRepository;

  @observable
  bool isLoading = true;

  _EstablishmentsPageControllerBase()
      : establishmentRepository = DatabaseEstablishmentRepository() {
    getEstablishments();
  }

  @action
  Future<List<Establishment>> getEstablishments() async {
    final result = await establishmentRepository.getEstablishments();

    entities
      ..clear()
      ..addAll(result);

    isLoading = false;

    return entities;
  }
}
