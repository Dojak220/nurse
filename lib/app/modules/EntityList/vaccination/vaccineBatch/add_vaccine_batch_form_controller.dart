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
  final VaccineBatch? initialVaccineBatchInfo;

  Vaccine? selectedVaccine;
  TextEditingController number = TextEditingController();
  TextEditingController quantity = TextEditingController();

  AddVaccineBatchFormController(
    this.initialVaccineBatchInfo, [
    VaccineRepository? vaccineRepository,
    VaccineBatchRepository? vaccineBatchRepository,
  ])  : _vaccineRepository = vaccineRepository ?? DatabaseVaccineRepository(),
        _repository =
            vaccineBatchRepository ?? DatabaseVaccineBatchRepository() {
    if (initialVaccineBatchInfo != null) {
      setInfo(initialVaccineBatchInfo!);
    }
  }

  Future<List<Vaccine>> getLocalities() async {
    final vaccines = await _vaccineRepository.getVaccines();

    return vaccines;
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newVaccineBatch = VaccineBatch(
        number: number.text,
        quantity: int.parse(quantity.text),
        vaccine: selectedVaccine!,
      );

      return super.createEntity<VaccineBatch>(
        newVaccineBatch,
        _repository.createVaccineBatch,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialVaccineBatchInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedVaccineBatch = initialVaccineBatchInfo!.copyWith(
        number: number.text,
        quantity: int.parse(quantity.text),
        vaccine: selectedVaccine!,
      );

      return super.updateEntity<VaccineBatch>(
        updatedVaccineBatch,
        _repository.updateVaccineBatch,
      );
    } else {
      return false;
    }
  }

  void setInfo(VaccineBatch vaccineBatch) {
    selectedVaccine = vaccineBatch.vaccine;
    number.text = vaccineBatch.number;
    quantity.text = vaccineBatch.quantity.toString();
  }

  @override
  void clearAllInfo() {
    selectedVaccine = null;

    number.clear();
    quantity.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    number.dispose();
    quantity.dispose();
  }
}
