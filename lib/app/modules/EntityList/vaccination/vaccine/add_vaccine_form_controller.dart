import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class AddVaccineFormController extends AddFormController {
  final VaccineRepository _repository;
  final Vaccine? initialVaccineInfo;

  TextEditingController sipniCode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController laboratory = TextEditingController();

  AddVaccineFormController(this.initialVaccineInfo,
      [VaccineRepository? vaccineRepository])
      : _repository = vaccineRepository ?? DatabaseVaccineRepository() {
    if (initialVaccineInfo != null) {
      setInfo(initialVaccineInfo!);
    }
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newVaccine = Vaccine(
        sipniCode: sipniCode.text,
        name: name.text,
        laboratory: laboratory.text,
      );

      return super.createEntity<Vaccine>(
        newVaccine,
        _repository.createVaccine,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialVaccineInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedVaccine = initialVaccineInfo!.copyWith(
        sipniCode: sipniCode.text,
        name: name.text,
        laboratory: laboratory.text,
      );

      return super.updateEntity<Vaccine>(
        updatedVaccine,
        _repository.updateVaccine,
      );
    } else {
      return false;
    }
  }

  void setInfo(Vaccine vaccine) {
    sipniCode.text = vaccine.sipniCode;
    name.text = vaccine.name;
    laboratory.text = vaccine.laboratory;
  }

  @override
  void clearAllInfo() {
    sipniCode.clear();
    name.clear();
    laboratory.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    sipniCode.dispose();
    name.dispose();
    laboratory.dispose();
  }
}
