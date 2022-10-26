import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign_page_controller.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/shared/models/infra/campaign_model.dart';
import 'package:provider/provider.dart';
import 'package:nurse/shared/utils/helper.dart';

class Campaigns extends StatelessWidget {
  const Campaigns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampaignsPageController>(context);
    final campaigns = controller.entities;

    return EntityList<Campaign>(
      title: "Campanhas",
      controller: controller,
      onCallback: () => context.read<CampaignsPageController>().getCampaigns(),
      newPage: "/campaigns/new",
      buttonText: "Nova Campanha",
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
            centerInfo: "",
            endInfo: DatePicker.formatDateDDMMYYYY(campaign.endDate),
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/campaigns/new", arguments: campaign)
                .whenComplete(
                  () => context.read<CampaignsPageController>().getCampaigns(),
                ));
      },
    );
  }
}
