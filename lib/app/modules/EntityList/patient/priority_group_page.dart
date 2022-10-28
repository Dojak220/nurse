import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/patient/priority_group_page_controller.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:provider/provider.dart';

class PriorityGroups extends StatelessWidget {
  const PriorityGroups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PriorityGroupsPageController>(context);
    final priorityGroups = controller.entities;

    return EntityList<PriorityGroup>(
      title: "Grupos Prioritários",
      controller: controller,
      onCallback: () =>
          context.read<PriorityGroupsPageController>().getPriorityGroups(),
      newPage: "/priorityGroups/new",
      buttonText: "Novo Grupo Priritário",
      itemBuilder: (_, index) {
        final priorityGroup = priorityGroups[index];

        return CustomCard(
            title: priorityGroup.name,
            upperTitle: priorityGroup.code,
            startInfo: priorityGroup.description,
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/priorityGroups/new", arguments: priorityGroup)
                .whenComplete(
                  () => context
                      .read<PriorityGroupsPageController>()
                      .getPriorityGroups(),
                ));
      },
    );
  }
}
