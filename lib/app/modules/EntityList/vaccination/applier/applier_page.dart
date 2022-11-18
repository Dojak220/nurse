import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/applier/applier_page_controller.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:provider/provider.dart';

class Appliers extends StatelessWidget {
  const Appliers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppliersPageController>(context);
    final appliers = controller.entities;

    return EntityList<Applier>(
      title: "Aplicantes",
      controller: controller,
      onCallback: () => context.read<AppliersPageController>().getAppliers(),
      newPage: "/appliers/new",
      buttonText: "Novo(a) Aplicante",
      itemBuilder: (_, index) {
        final applier = appliers[index];

        return CustomCard(
            title: applier.person.name,
            upperTitle: applier.cns,
            startInfo: applier.establishment.name,
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/appliers/new", arguments: applier)
                .whenComplete(
                  () => context.read<AppliersPageController>().getAppliers(),
                ));
      },
    );
  }
}
