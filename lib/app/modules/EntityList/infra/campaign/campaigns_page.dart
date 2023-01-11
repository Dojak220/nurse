import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign/campaign_page_controller.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:nurse/shared/utils/helper.dart';

class Campaigns extends StatelessWidget {
  final CampaignsPageController controller;
  const Campaigns(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final campaigns = controller.entities.toList();

      return EntityList<Campaign>(
        title: "Campanhas",
        entities: campaigns,
        onCallback: () => controller.getCampaigns(),
        newPage: "/campaigns/new",
        buttonText: "Nova Campanha",
        isLoading: controller.isLoading,
        itemBuilder: (_, index) {
          final campaign = campaigns[index];

          final campaignStatus = DateTime.now().isBefore(campaign.startDate)
              ? "Não iniciada"
              : DateTime.now().isBetween(campaign.startDate, campaign.endDate)
                  ? "Em andamento"
                  : "Finalizada";

          return CustomCard(
              title: campaign.title,
              upperTitle: campaignStatus,
              startInfo: DatePicker.formatDateDDMMYYYY(campaign.startDate),
              endInfo: DatePicker.formatDateDDMMYYYY(campaign.endDate),
              onEditPressed: () => Navigator.of(context)
                  .pushNamed("/campaigns/new", arguments: campaign)
                  .whenComplete(
                    () => controller.getCampaigns(),
                  ));
        },
      );
    });
  }
}
