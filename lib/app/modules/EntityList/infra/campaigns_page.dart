import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/components/registration_button.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign_page_controller.dart';
import 'package:nurse/app/components/titled_list_view.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:provider/provider.dart';

class Campaigns extends StatelessWidget {
  final String title;

  const Campaigns({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NurseAppBar(title: title),
      body: const _CampaignsList(),
      floatingActionButton: RegistrationButton(
        text: "Nova Campanha",
        newPage: "/campaigns/new",
        onCallback: () =>
            context.read<CampaignsPageController>().getCampaigns(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _CampaignsList extends StatelessWidget {
  const _CampaignsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampaignsPageController>(context);
    final campaigns = controller.campaigns;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Observer(
        builder: (_) => TitledListView(
          "Campanhas cadastradas",
          itemCount: campaigns.length,
          itemBuilder: (_, index) {
            final campaign = campaigns[index];

            return CustomCard(
              title: campaign.title,
              upperTitle: "",
              startInfo: DatePicker.formatDateDDMMYYYY(campaign.startDate),
              centerInfo: "",
              endInfo: DatePicker.formatDateDDMMYYYY(campaign.endDate),
              onEditPressed: () {
                /// TODO: Jump to edit page and return to this page
              },
            );
          },
        ),
      ),
    );
  }
}
