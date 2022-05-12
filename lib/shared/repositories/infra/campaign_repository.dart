import 'package:nurse/shared/models/infra/campaign_model.dart';

abstract class CampaignRepository {
  Future<int> createCampaign(Campaign campaign);
  Future<int> deleteCampaign(int id);
  Future<Campaign> getCampaignById(int id);
  Future<List<Campaign>> getCampaigns();
  Future<int> updateCampaign(Campaign campaign);
}
