import 'package:mobx/mobx.dart';

import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class CampaignsPageController {
  final CampaignRepository campaignRepository;

  final campaigns = ObservableList<Campaign>.of(
    List<Campaign>.empty(growable: true),
  );

  late final fetchCampaigns = Action(getCampaigns);

  CampaignsPageController()
      : campaignRepository = DatabaseCampaignRepository() {
    getCampaigns();
  }

  Future<List<Campaign>> getCampaigns() async {
    final result = await campaignRepository.getCampaigns();
    campaigns.clear();
    campaigns.addAll(result.reversed);

    return campaigns;
  }
}
