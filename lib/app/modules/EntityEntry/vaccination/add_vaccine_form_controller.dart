import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class AddVaccineFormController extends AddFormController {
  final VaccineRepository _repository;

  TextEditingController sipniCode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController laboratory = TextEditingController();

  AddVaccineFormController([VaccineRepository? vaccineRepository])
      : _repository = vaccineRepository ?? DatabaseVaccineRepository();

  @override
  Future<bool> saveInfo() async {
    final newVaccine = Vaccine(
      sipniCode: sipniCode.text,
      name: name.text,
      laboratory: laboratory.text,
    );

    return super.createEntity<Vaccine>(
      newVaccine,
      _repository.createVaccine,
    );
  }

  @override
  void clearAllInfo() {
    sipniCode.clear();
    name.clear();
    laboratory.clear();

    notifyListeners();
  }
}
