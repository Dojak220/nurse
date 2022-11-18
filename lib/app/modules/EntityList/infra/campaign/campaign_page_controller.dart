import 'package:nurse/app/modules/EntityList/entity_page_controller.dart';

import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class CampaignsPageController extends EntityPageController<Campaign> {
  final CampaignRepository campaignRepository;

  CampaignsPageController()
      : campaignRepository = DatabaseCampaignRepository() {
    getCampaigns();
  }

  Future<List<Campaign>> getCampaigns() async {
    final result = await campaignRepository.getCampaigns();
    entities.clear();

    result.sort((date1, date2) {
      final int comparisonByStartDate = _sortByStartDate(date1, date2);

      return comparisonByStartDate != 0
          ? comparisonByStartDate
          : _sortByEndDate(date1, date2);
    });

    entities.addAll(result);

    return entities;
  }

  int _sortByStartDate(Campaign a, Campaign b) =>
      a.startDate.compareTo(b.startDate);

  int _sortByEndDate(Campaign a, Campaign b) => a.endDate.compareTo(b.endDate);
}
