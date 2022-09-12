import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class AddVaccineFormController extends FormController {
  final VaccineRepository _repository;

  TextEditingController sipniCode = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController laboratory = TextEditingController();

  AddVaccineFormController([VaccineRepository? vaccineRepository])
      : _repository = vaccineRepository ?? DatabaseVaccineRepository();

  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createVaccine(Vaccine(
          sipniCode: sipniCode.text,
          name: name.text,
          laboratory: laboratory.text,
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
  void clearAllInfo() {
    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
