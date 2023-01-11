import 'package:mobx/mobx.dart';

import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';
import 'package:nurse/app/utils/sort_campaign_by_date.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

part 'campaign_page_controller.g.dart';

class CampaignsPageController = _CampaignsPageControllerBase
    with _$CampaignsPageController;

abstract class _CampaignsPageControllerBase
    extends EntityPageController<Campaign> with Store {
  final CampaignRepository campaignRepository;

  @observable
  bool isLoading = true;

  _CampaignsPageControllerBase()
      : campaignRepository = DatabaseCampaignRepository() {
    getCampaigns();
  }

  @action
  Future<List<Campaign>> getCampaigns() async {
    final result = await campaignRepository.getCampaigns();

    result.sortByDate();

    entities
      ..clear()
      ..addAll(result);

    isLoading = false;

    return entities;
  }
}
