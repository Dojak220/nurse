import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/establishment_store.dart";
import "package:nurse/app/utils/add_form_controller.dart";
import "package:nurse/shared/models/infra/establishment_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";
import "package:nurse/shared/repositories/database/infra/database_establishment_repository.dart";
import "package:nurse/shared/repositories/database/infra/database_locality_repository.dart";
import "package:nurse/shared/repositories/infra/establishment_repository.dart";
import "package:nurse/shared/repositories/infra/locality_repository.dart";

part "add_establishment_form_controller.g.dart";

class AddEstablishmentFormController = _AddEstablishmentFormControllerBase
    with _$AddEstablishmentFormController;

abstract class _AddEstablishmentFormControllerBase extends AddFormController
    with Store {
  final EstablishmentRepository _repository;
  final LocalityRepository _localityRepository;

  final Establishment? initialEstablishmentInfo;

  @observable
  ObservableList<Locality> localityCities =
      ObservableList.of(List<Locality>.empty(growable: true));

  @observable
  EstablishmentStore establishmentStore = EstablishmentStore();

  _AddEstablishmentFormControllerBase(
    this.initialEstablishmentInfo, [
    EstablishmentRepository? establishmentRepository,
    LocalityRepository? localityRepository,
  ])  : _repository =
            establishmentRepository ?? DatabaseEstablishmentRepository(),
        _localityRepository =
            localityRepository ?? DatabaseLocalityRepository() {
    if (initialEstablishmentInfo != null) {
      establishmentStore.setInfo(initialEstablishmentInfo!);
    }

    getCitiesFromLocalities();
  }

  @action
  Future<List<Locality>> getCitiesFromLocalities() async {
    final localities = await _localityRepository.getLocalities();
    final oneLocalityByCity = List<Locality>.empty(growable: true);

    for (final Locality locality in localities) {
      final bool isCityAlreadyAdded = oneLocalityByCity.any(
        (Locality city) {
          return city.city == locality.city;
        },
      );

      if (isCityAlreadyAdded) continue;

      oneLocalityByCity.add(locality);
    }

    localityCities
      ..clear()
      ..addAll(oneLocalityByCity);

    return localityCities;
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newEstablishment = Establishment(
        cnes: establishmentStore.cnes!,
        name: establishmentStore.name!,
        locality: establishmentStore.selectedLocality!,
      );

      return super.createEntity<Establishment>(
        newEstablishment,
        _repository.createEstablishment,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialEstablishmentInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedEstablishment = initialEstablishmentInfo!.copyWith(
        cnes: establishmentStore.cnes,
        name: establishmentStore.name,
        locality: establishmentStore.selectedLocality,
      );

      return super.updateEntity<Establishment>(
        updatedEstablishment,
        _repository.updateEstablishment,
      );
    } else {
      return false;
    }
  }

  @override
  void clearAllInfo() {
    establishmentStore.clearAllInfo();
  }

  @override
  void dispose() {
    /// Não tem o que ser desalocado aqui
  }
}
