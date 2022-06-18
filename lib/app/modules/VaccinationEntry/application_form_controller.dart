import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';

class ApplicationFormController extends FormController {
  final ApplicationRepository _applicationRepository;

  final _applications = List<Application>.empty(growable: true);
  List<Application> get applications => _applications;

  String? doseValue;
  DateTime? selectedDate;
  TextEditingController date = TextEditingController();

  ApplicationFormController([
    ApplicationRepository? applicationRepository,
  ]) : _applicationRepository =
            applicationRepository ?? DatabaseApplicationRepository() {
    _getApplications();
  }

  Future<void> _getApplications() async {
    _applications.addAll(await _applicationRepository.getApplications());
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      date
        ..text = DateFormat("dd/MM/yyyy").format(selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: date.text.length, affinity: TextAffinity.upstream));
      notifyListeners();
    }
  }

  @override
  void cleanAllInfo() {
    doseValue = null;
    selectedDate = null;
    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
