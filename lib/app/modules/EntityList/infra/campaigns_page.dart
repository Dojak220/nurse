import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/infra/campaign_page_controller.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:provider/provider.dart';

class Campaigns extends StatelessWidget {
  const Campaigns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CampaignsPageController>(context);
    final campaigns = controller.entities;

    return EntityList(
      title: "Campanhas",
      onCallback: () => context.read<CampaignsPageController>().getCampaigns(),
      newPage: "/campaigns/new",
      buttonText: "Nova Campanha",
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
    );
  }
}

// class _CampaignsList extends StatelessWidget {
//   const _CampaignsList({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Provider.of<CampaignsPageController>(context);
//     final campaigns = controller.campaigns;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Observer(
//         builder: (_) => TitledListView(
//           "Campanhas cadastradas",
//           itemCount: campaigns.length,
//           itemBuilder: (_, index) {
//             final campaign = campaigns[index];

//             return CustomCard(
//               title: campaign.title,
//               upperTitle: "",
//               startInfo: DatePicker.formatDateDDMMYYYY(campaign.startDate),
//               centerInfo: "",
//               endInfo: DatePicker.formatDateDDMMYYYY(campaign.endDate),
//               onEditPressed: () {
//                 /// TODO: Jump to edit page and return to this page
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
