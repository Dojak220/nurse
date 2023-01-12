import "package:flutter/material.dart";
import "package:nurse/app/utils/add_form_controller.dart";
import "package:nurse/app/utils/date_picker.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";
import "package:nurse/shared/repositories/database/infra/database_campaign_repository.dart";
import "package:nurse/shared/repositories/infra/campaign_repository.dart";

class AddCampaignFormController extends AddFormController {
  final CampaignRepository _repository;
  final Campaign? initialCampaignInfo;

  final _campaigns = List<Campaign>.empty(growable: true);
  List<Campaign> get campaigns => _campaigns;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  AddCampaignFormController(
    this.initialCampaignInfo, [
    CampaignRepository? campaignRepository,
  ]) : _repository = campaignRepository ?? DatabaseCampaignRepository() {
    if (initialCampaignInfo != null) {
      setInfo(initialCampaignInfo!);
    }
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final newCampaign = Campaign(
        title: title.text,
        description: description.text,
        startDate: selectedStartDate!,
        endDate: selectedEndDate,
      );

      return super.createEntity<Campaign>(
        newCampaign,
        _repository.createCampaign,
      );
    } else {
      return false;
    }
  }

  @override
  Future<bool> updateInfo() async {
    if (initialCampaignInfo == null) return false;

    if (submitForm(formKey)) {
      final updatedCampaign = initialCampaignInfo!.copyWith(
        title: title.text,
        description: description.text,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      );

      return super.updateEntity<Campaign>(
        updatedCampaign,
        _repository.updateCampaign,
      );
    } else {
      return false;
    }
  }

  void setInfo(Campaign campaign) {
    title.text = campaign.title;
    description.text = campaign.description;
    selectedStartDate = campaign.startDate;
    selectedEndDate = campaign.endDate;
    startDate.text = DatePicker.formatDateDDMMYYYY(campaign.startDate);
    endDate.text = DatePicker.formatDateDDMMYYYY(campaign.endDate);
  }

  @override
  void clearAllInfo() {
    title.clear();
    description.clear();
    startDate.clear();
    endDate.clear();

    notifyListeners();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? newSelectedDate = await DatePicker.getNewDate(
      context,
      selectedStartDate,
      lastDate: selectedEndDate,
    );

    if (newSelectedDate != null) {
      selectedStartDate = newSelectedDate;
      _updateDateText(startDate, selectedStartDate!);
    }

    notifyListeners();
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? newSelectedDate = await DatePicker.getNewDate(
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
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: controller.text.length,
          affinity: TextAffinity.upstream,
        ),
      );
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    startDate.dispose();
    endDate.dispose();
  }
}
