import "package:flutter/material.dart";
import "package:mobx/mobx.dart";
import "package:nurse/app/utils/date_picker.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";

part "campaign_store.g.dart";

class CampaignStore = _CampaignStoreBase with _$CampaignStore;

abstract class _CampaignStoreBase with Store {
  @observable
  String? title;

  @observable
  String? description;

  @observable
  DateTime? selectedStartDate;

  @observable
  DateTime? selectedEndDate;

  @computed
  TextEditingController? get startDate => selectedStartDate != null
      ? TextEditingController(
          text: DatePicker.formatDateDDMMYYYY(selectedStartDate!),
        )
      : null;

  @computed
  TextEditingController? get endDate => selectedEndDate != null
      ? TextEditingController(
          text: DatePicker.formatDateDDMMYYYY(selectedEndDate!),
        )
      : null;

  @action
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? newSelectedDate = await DatePicker.getNewDate(
      context,
      selectedStartDate,
      lastDate: selectedEndDate,
    );

    if (newSelectedDate != null) {
      selectedStartDate = newSelectedDate;
    }
  }

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) => description = value;

  @action
  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? newSelectedDate = await DatePicker.getNewDate(
      context,
      selectedEndDate,
      firstDate: selectedStartDate,
    );

    if (newSelectedDate != null) {
      selectedEndDate = newSelectedDate;
    }
  }

  @action
  void setInfo(Campaign campaign) {
    title = campaign.title;
    description = campaign.description;

    selectedStartDate = campaign.startDate;
    selectedEndDate = campaign.endDate;
  }

  @action
  void clearAllInfo() {
    title = null;
    description = null;

    selectedStartDate = null;
    selectedEndDate = null;
  }
}
