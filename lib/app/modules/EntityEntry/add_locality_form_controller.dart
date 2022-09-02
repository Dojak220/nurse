import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class AddLocalityFormController extends FormController {
  final LocalityRepository _repository;

  final _localities = List<Locality>.empty(growable: true);
  List<Locality> get localities => _localities;

  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController ibgeCode = TextEditingController();

  Locality? locality;

  AddLocalityFormController([LocalityRepository? localityRepository])
      : _repository = localityRepository ?? DatabaseLocalityRepository();

  @override
  void clearAllInfo() {
    name.clear();
    city.clear();
    state.clear();
    ibgeCode.clear();

    locality = null;

    notifyListeners();
  }

  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createLocality(
          Locality(
            name: name.text,
            city: city.text,
            state: state.text,
            ibgeCode: ibgeCode.text,
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
  void submitForm() async {
    formKey.currentState!.save();
  }
}
