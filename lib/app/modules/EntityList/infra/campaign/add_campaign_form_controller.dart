import "package:flutter/material.dart";
import "package:mobx/mobx.dart";
import "package:nurse/app/modules/EntityList/infra/campaign/campaign_store.dart";
import "package:nurse/app/utils/add_form_controller.dart";
import "package:nurse/shared/models/infra/campaign_model.dart";
import "package:nurse/shared/repositories/database/infra/database_campaign_repository.dart";
import "package:nurse/shared/repositories/infra/campaign_repository.dart";
part "add_campaign_form_controller.g.dart";

class AddCampaignFormController = _AddCampaignFormControllerBase
    with _$AddCampaignFormController;

abstract class _AddCampaignFormControllerBase extends AddFormController
    with Store {
  final CampaignRepository _repository;
  final Campaign? initialCampaignInfo;

  @observable
  CampaignStore campaignStore = CampaignStore();

  _AddCampaignFormControllerBase(
    this.initialCampaignInfo, [
    CampaignRepository? campaignRepository,
  ]) : _repository = campaignRepository ?? DatabaseCampaignRepository() {
    if (initialCampaignInfo != null) {
      campaignStore.setInfo(initialCampaignInfo!);
    }
  }

  @override
  Future<bool> saveInfo() async {
    if (submitForm(formKey)) {
      final CampaignStore cStore = campaignStore;
      final newCampaign = Campaign(
        title: cStore.title!,
        description: cStore.description!,
        startDate: cStore.selectedStartDate!,
        endDate: cStore.selectedEndDate,
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
        title: campaignStore.title,
        description: campaignStore.description,
        startDate: campaignStore.selectedStartDate,
        endDate: campaignStore.selectedEndDate,
      );

      return super.updateEntity<Campaign>(
        updatedCampaign,
        _repository.updateCampaign,
      );
    } else {
      return false;
    }
  }

  @override
  void clearAllInfo() {
    campaignStore.clearAllInfo();
  }

  @override
  void dispose() {
    campaignStore.startDate?.dispose();
    campaignStore.endDate?.dispose();
  }
}
