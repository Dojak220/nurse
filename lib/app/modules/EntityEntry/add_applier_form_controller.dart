import 'package:flutter/material.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/database/infra/database_locality_repository.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/locality_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';

class AddApplierFormController extends FormController {
  final LocalityRepository _localityRepository;
  final EstablishmentRepository _establishmentRepository;
  final ApplierRepository _repository;

  Establishment? selectedEstablishment;
  Locality? selectedLocality;
  Sex selectedSex = Sex.none;
  DateTime? selectedBirthDate;
  TextEditingController cns = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController motherName = TextEditingController();
  TextEditingController fatherName = TextEditingController();

  AddApplierFormController([
    LocalityRepository? localityRepository,
    EstablishmentRepository? establishmentRepository,
    ApplierRepository? applierRepository,
  ])  : _localityRepository =
            localityRepository ?? DatabaseLocalityRepository(),
        _establishmentRepository =
            establishmentRepository ?? DatabaseEstablishmentRepository(),
        _repository = applierRepository ?? DatabaseApplierRepository();

  Future<List<Locality>> getLocalities() async {
    final localities = await _localityRepository.getLocalities();

    return localities;
  }

  Future<List<Establishment>> getEstablishments() async {
    final establishments = await _establishmentRepository.getEstablishments();

    return establishments;
  }

  Future<void> selectDate(BuildContext context) async {
    final newSelectedDate =
        await DatePicker.getNewDate(context, selectedBirthDate);

    if (newSelectedDate != null) {
      selectedBirthDate = newSelectedDate;
      birthDate
        ..text = DatePicker.formatDateDDMMYYYY(selectedBirthDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: birthDate.text.length, affinity: TextAffinity.upstream));
    }
  }

  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        final id = await _repository.createApplier(
          Applier(
            cns: cns.text,
            person: Person(
              cpf: cpf.text,
              name: name.text,
              locality: selectedLocality,
              sex: selectedSex,
              birthDate: selectedBirthDate,
              fatherName: fatherName.text,
              motherName: motherName.text,
            ),
            establishment: selectedEstablishment!,
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
    selectedLocality = null;
    selectedEstablishment = null;
    selectedSex = Sex.none;
    selectedBirthDate = null;

    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
