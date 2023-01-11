import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/patient/priorityGroup/priority_group_page_controller.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';

class PriorityGroups extends StatelessWidget {
  final PriorityGroupsPageController controller;
  const PriorityGroups(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final priorityGroups = controller.entities;

      return EntityList<PriorityGroup>(
        title: "Grupos Prioritários",
        entities: priorityGroups,
        onCallback: () => controller.getPriorityGroups(),
        newPage: "/priorityGroups/new",
        buttonText: "Novo Grupo Prioritário",
        isLoading: controller.isLoading,
        itemBuilder: (_, index) {
          final priorityGroup = priorityGroups[index];

          return CustomCard(
              title: priorityGroup.name,
              upperTitle: priorityGroup.code,
              startInfo: priorityGroup.description,
              onEditPressed: () => Navigator.of(context)
                  .pushNamed("/priorityGroups/new", arguments: priorityGroup)
                  .whenComplete(
                    () => controller.getPriorityGroups(),
                  ));
        },
      );
    });
  }
}
