import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class AddEstablishmentFormController extends AddFormController {
  final EstablishmentRepository _repository;
  final LocalityRepository _localityRepository;
  final Establishment? initialEstablishmentInfo;

  final _localityCities = List<Locality>.empty(growable: true);
  List<Locality> get localityCities => _localityCities;

  TextEditingController cnes = TextEditingController();
  TextEditingController name = TextEditingController();
  Locality? locality;

  AddEstablishmentFormController(
    this.initialEstablishmentInfo, [
    EstablishmentRepository? establishmentRepository,
    LocalityRepository? localityRepository,
  ])  : _repository =
            establishmentRepository ?? DatabaseEstablishmentRepository(),
        _localityRepository =
            localityRepository ?? DatabaseLocalityRepository() {
    if (initialEstablishmentInfo != null) {
      setInfo(initialEstablishmentInfo!);
    }
  }

  Future<List<Locality>> getCitiesFromLocalities() async {
    final localities = await _localityRepository.getLocalities();
    final oneLocalityByCity = List<Locality>.empty(growable: true);

    for (final locality in localities) {
      final isCityAlreadyAdded = oneLocalityByCity.any((city) {
        return city.city == locality.city;
      });

      if (isCityAlreadyAdded) continue;

      oneLocalityByCity.add(locality);
    }

    _localityCities.addAll(oneLocalityByCity);

    return _localityCities;
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newEstablishment = Establishment(
        cnes: cnes.text,
        name: name.text,
        locality: locality!,
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
        cnes: cnes.text,
        name: name.text,
        locality: locality!,
      );

      return super.updateEntity<Establishment>(
        updatedEstablishment,
        _repository.updateEstablishment,
      );
    } else {
      return false;
    }
  }

  void setInfo(Establishment campaign) {
    cnes.text = campaign.cnes;
    name.text = campaign.name;
    locality = campaign.locality;
  }

  @override
  void clearAllInfo() {
    cnes.clear();
    name.clear();
    locality = null;

    notifyListeners();
  }

  @override
  void dispose() {
    cnes.dispose();
    name.dispose();
  }
}
