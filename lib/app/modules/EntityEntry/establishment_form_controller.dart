import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class EstablishmentFormController extends FormController {
  final LocalityRepository _localityRepository;

  final _localities = List<Locality>.empty(growable: true);

  TextEditingController cnes = TextEditingController();
  TextEditingController name = TextEditingController();
  Locality? locality;

  EstablishmentFormController([
    EstablishmentRepository? establishmentRepository,
    LocalityRepository? localityRepository,
  ]) : _localityRepository = localityRepository ?? DatabaseLocalityRepository();

  void getLocalities(String state, String city) async {
    _localities.addAll(
      await _localityRepository.getLocalitiesByStateAndCity(state, city),
    );

    notifyListeners();
  }

  void clearAllInfo() {
    cnes.clear();
    name.clear();
    locality = null;
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
