import 'package:flutter/material.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/app/utils/add_form_controller.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class AddCampaignFormController extends AddFormController {
  final CampaignRepository _repository;

  final _campaigns = List<Campaign>.empty(growable: true);
  List<Campaign> get campaigns => _campaigns;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  AddCampaignFormController([CampaignRepository? campaignRepository])
      : _repository = campaignRepository ?? DatabaseCampaignRepository();

  @override
  void clearAllInfo() {
    title.clear();
    description.clear();
    startDate.clear();
    endDate.clear();

    notifyListeners();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final newSelectedDate = await DatePicker.getNewDate(
      context,
      selectedStartDate,
      lastDate: selectedEndDate,
    );

    if (newSelectedDate != null) {
      selectedStartDate = newSelectedDate;
      _updateDateText(startDate, selectedStartDate!);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final newSelectedDate = await DatePicker.getNewDate(
      context,
      selectedEndDate,
      firstDate: selectedStartDate,
    );

    if (newSelectedDate != null) {
      selectedEndDate = newSelectedDate;
      _updateDateText(endDate, selectedEndDate!);
    }
  }

  void _updateDateText(TextEditingController controller, DateTime date) {
    controller
      ..text = DatePicker.formatDateDDMMYYYY(date)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: controller.text.length, affinity: TextAffinity.upstream));
  }

  @override
  Future<bool> saveInfo() async {
    submitForm();
    final allFieldsValid = super.formKey.currentState!.validate();

    if (allFieldsValid) {
      try {
        if (selectedStartDate == null) throw Exception("Start date is null");
        final id = await _repository.createCampaign(
          Campaign(
              title: title.text,
              description: description.text,
              startDate: selectedStartDate!,
              endDate: selectedEndDate),
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
