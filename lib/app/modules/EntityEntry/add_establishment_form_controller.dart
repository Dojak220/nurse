import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class AddEstablishmentFormController extends FormController {
  final EstablishmentRepository _repository;
  final LocalityRepository _localityRepository;

  final _localityCities = List<Locality>.empty(growable: true);
  List<Locality> get localityCities => _localityCities;

  TextEditingController cnes = TextEditingController();
  TextEditingController name = TextEditingController();
  Locality? locality;

  AddEstablishmentFormController([
    EstablishmentRepository? establishmentRepository,
    LocalityRepository? localityRepository,
  ])  : _repository =
            establishmentRepository ?? DatabaseEstablishmentRepository(),
        _localityRepository =
            localityRepository ?? DatabaseLocalityRepository();

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
  void clearAllInfo() {
    cnes.clear();
    name.clear();
    locality = null;

    notifyListeners();
  }

  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createEstablishment(Establishment(
          cnes: cnes.text,
          name: name.text,
          locality: locality!,
        ));

        if (id != 0) {
          clearAllInfo();
          return true;
        } else {
          return false;
        }
      } catch (error) {
        print(error);
        return false;
      }
    }

    return false;
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
