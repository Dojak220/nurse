import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class AddVaccineBatchFormController extends AddFormController {
  final VaccineRepository _vaccineRepository;
  final VaccineBatchRepository _repository;

  Vaccine? selectedVaccine;
  TextEditingController number = TextEditingController();
  TextEditingController quantity = TextEditingController();

  AddVaccineBatchFormController([
    VaccineRepository? vaccineRepository,
    VaccineBatchRepository? vaccineBatchRepository,
  ])  : _vaccineRepository = vaccineRepository ?? DatabaseVaccineRepository(),
        _repository =
            vaccineBatchRepository ?? DatabaseVaccineBatchRepository();

  Future<List<Vaccine>> getLocalities() async {
    final vaccines = await _vaccineRepository.getVaccines();

    return vaccines;
  }

  @override
  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createVaccineBatch(
          VaccineBatch(
            number: number.text,
            quantity: int.parse(quantity.text),
            vaccine: selectedVaccine!,
          ),
        );

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
  void clearAllInfo() {
    selectedVaccine = null;
    selectedVaccine = null;

    number.clear();
    quantity.clear();

    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
