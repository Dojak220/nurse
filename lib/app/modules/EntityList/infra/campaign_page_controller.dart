import 'package:mobx/mobx.dart';
import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class CampaignsPageController extends EntityPageController<Campaign> {
  final CampaignRepository campaignRepository;

  late final fetchCampaigns = Action(getCampaigns);

  CampaignsPageController()
      : campaignRepository = DatabaseCampaignRepository() {
    getCampaigns();
  }

  Future<List<Campaign>> getCampaigns() async {
    final result = await campaignRepository.getCampaigns();
    entities.clear();
    entities.addAll(result.reversed);

    return entities;
  }
}
