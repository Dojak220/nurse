import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class CampaignFormController extends FormController {
  Campaign? selectedCampaign;

  final CampaignRepository _campaignRepository;

  List<Campaign> _campaigns = List.empty(growable: true);
  List<Campaign> get campaigns => _campaigns;

  CampaignFormController([
    CampaignRepository? campaignRepository,
  ]) : _campaignRepository = campaignRepository ?? DatabaseCampaignRepository();

  Future<List<Campaign>> getCampaigns() async {
    return _campaigns = await _campaignRepository.getCampaigns();
  }

  Campaign? get campaign => selectedCampaign;

  @override
  void clearAllInfo() {
    selectedCampaign = null;
  }

  @override
  void dispose() {
    /// Não tem o que desalocar aqui
  }
}
