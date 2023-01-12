import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:nurse/app/components/custom_card.dart";
import "package:nurse/app/modules/EntityList/entity_list_page.dart";
import "package:nurse/app/modules/EntityList/vaccination/applier/applier_page_controller.dart";
import "package:nurse/shared/models/vaccination/applier_model.dart";

class Appliers extends StatelessWidget {
  final AppliersPageController controller;
  const Appliers(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final appliers = controller.entities;

        return EntityList<Applier>(
          title: "Aplicantes",
          entities: appliers,
          onCallback: () => controller.getAppliers(),
          newPage: "/appliers/new",
          buttonText: "Novo(a) Aplicante",
          isLoading: controller.isLoading,
          itemBuilder: (_, index) {
            final applier = appliers[index];

            return CustomCard(
              title: applier.person.name,
              upperTitle: applier.cns,
              startInfo: applier.establishment.name,
              onEditPressed: () async => Navigator.of(context)
                  .pushNamed("/appliers/new", arguments: applier)
                  .whenComplete(
                    () => controller.getAppliers(),
                  ),
            );
          },
        );
      },
    );
  }
}
