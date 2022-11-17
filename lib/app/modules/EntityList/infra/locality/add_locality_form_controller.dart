import 'package:flutter/material.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';

class AddLocalityFormController extends AddFormController {
  final LocalityRepository _repository;
  final Locality? initialLocalityInfo;

  final _localities = List<Locality>.empty(growable: true);
  List<Locality> get localities => _localities;

  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController ibgeCode = TextEditingController();

  AddLocalityFormController(this.initialLocalityInfo,
      [LocalityRepository? localityRepository])
      : _repository = localityRepository ?? DatabaseLocalityRepository() {
    if (initialLocalityInfo != null) {
      setInfo(initialLocalityInfo!);
    }
  }

  @override
  Future<bool> saveInfo() async {
    final newLocality = Locality(
      name: name.text,
      city: city.text,
      state: state.text,
      ibgeCode: ibgeCode.text,
    );

    return super.createEntity<Locality>(
      newLocality,
      _repository.createLocality,
    );
  }

  @override
  Future<bool> updateInfo() async {
    if (initialLocalityInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedLocality = initialLocalityInfo!.copyWith(
        name: name.text,
        city: city.text,
        state: state.text,
        ibgeCode: ibgeCode.text,
      );

      return super.updateEntity<Locality>(
        updatedLocality,
        _repository.updateLocality,
      );
    } else {
      return false;
    }
  }

  void setInfo(Locality campaign) {
    name.text = campaign.name;
    city.text = campaign.city;
    state.text = campaign.state;
    ibgeCode.text = campaign.ibgeCode;
  }

  @override
  void clearAllInfo() {
    name.clear();
    city.clear();
    state.clear();
    ibgeCode.clear();

    notifyListeners();
  }
}
