import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_campaign_repository.dart';
import 'package:nurse/shared/repositories/infra/campaign_repository.dart';

class CampaignFormController extends FormController {
  Campaign? selectedCampaign;

  final CampaignRepository _campaignRepository;

  final _campaigns = List<Campaign>.empty(growable: true);
  List<Campaign> get campaigns => _campaigns;

  CampaignFormController([
    CampaignRepository? campaignRepository,
  ]) : _campaignRepository =
            campaignRepository ?? DatabaseCampaignRepository() {
    // _getCampaigns();
  }

  Future<List<Campaign>> getCampaigns() async {
    return _campaigns..addAll(await _campaignRepository.getCampaigns());
    // notifyListeners();
  }

  void cleanAllInfo() {
    selectedCampaign = null;
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
