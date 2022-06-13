import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class DatabaseCampaignRepository extends DatabaseInterface
    implements CampaignRepository {
  static const String TABLE = "Campaign";

  DatabaseCampaignRepository([DatabaseManager? dbManager])
      : super(TABLE, dbManager);

  @override
  Future<int> createCampaign(Campaign campaign) async {
    final int result = await create(campaign.toMap());

    return result;
  }

  @override
  Future<int> deleteCampaign(int id) async {
    final int count = await delete(id);

    return count;
  }

  @override
  Future<Campaign> getCampaignById(int id) async {
    try {
      final campaignMap = await getById(id);

      return Campaign.fromMap(campaignMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Campaign> getCampaignByTitle(String title) async {
    try {
      final campaignMap = await get(title, where: "title = ?");

      return Campaign.fromMap(campaignMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Campaign>> getCampaigns() async {
    try {
      final campaignMaps = await getAll();

      final campaigns = List<Campaign>.generate(campaignMaps.length, (index) {
        return Campaign.fromMap(campaignMaps[index]);
      });

      return campaigns;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateCampaign(Campaign campaign) async {
    final int count = await update(campaign.toMap());

    return count;
  }
}
