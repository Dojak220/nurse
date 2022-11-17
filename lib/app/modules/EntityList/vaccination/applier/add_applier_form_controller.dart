import 'package:flutter/material.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
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

class AddApplierFormController extends AddFormController {
  final LocalityRepository _localityRepository;
  final EstablishmentRepository _establishmentRepository;
  final ApplierRepository _repository;
  final Applier? initialApplierInfo;

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

  AddApplierFormController(
    this.initialApplierInfo, [
    LocalityRepository? localityRepository,
    EstablishmentRepository? establishmentRepository,
    ApplierRepository? applierRepository,
  ])  : _localityRepository =
            localityRepository ?? DatabaseLocalityRepository(),
        _establishmentRepository =
            establishmentRepository ?? DatabaseEstablishmentRepository(),
        _repository = applierRepository ?? DatabaseApplierRepository() {
    if (initialApplierInfo != null) {
      setInfo(initialApplierInfo!);
    }
  }

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

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newApplier = Applier(
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
      );

      return super.createEntity<Applier>(
        newApplier,
        _repository.createApplier,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialApplierInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedApplier = initialApplierInfo!.copyWith(
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
      );

      return super.updateEntity<Applier>(
        updatedApplier,
        _repository.updateApplier,
      );
    } else {
      return false;
    }
  }

  void setInfo(Applier applier) {
    cns.text = applier.cns;

    name.text = applier.person.name;
    cpf.text = applier.person.cpf;
    selectedLocality = applier.person.locality;
    selectedSex = applier.person.sex;

    selectedBirthDate = applier.person.birthDate;
    birthDate.text = DatePicker.formatDateDDMMYYYY(selectedBirthDate!);

    fatherName.text = applier.person.fatherName;
    motherName.text = applier.person.motherName;

    selectedEstablishment = applier.establishment;
  }

  @override
  void clearAllInfo() {
    selectedLocality = null;
    selectedEstablishment = null;
    selectedSex = Sex.none;
    selectedBirthDate = null;

    cns.clear();
    cpf.clear();
    name.clear();
    birthDate.clear();
    motherName.clear();
    fatherName.clear();

    notifyListeners();
  }
}
