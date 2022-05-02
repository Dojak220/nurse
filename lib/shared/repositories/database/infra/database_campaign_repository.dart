import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class DatabaseCampaignRepository extends DatabaseInterface
    implements CampaignRepository {
  static const String TABLE = "Campaign";
  final DatabaseManager dbManager;

  DatabaseCampaignRepository(this.dbManager) : super(dbManager, TABLE);

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
      final campaignMap = await get(id);
      final campaign = Campaign.fromMap(campaignMap);

      return campaign;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Campaign>> getCampaigns() async {
    try {
      final campaignMaps = await getAll();

      final List<Campaign> campaigns = List<Campaign>.generate(
        campaignMaps.length,
        (index) {
          return Campaign.fromMap(campaignMaps[index]);
        },
      );

      return campaigns;
    } catch (e) {
      return List<Campaign>.empty();
    }
  }

  @override
  Future<int> updateCampaign(Campaign campaign) async {
    final int count = await update(campaign.toMap());

    return count;
  }
}
