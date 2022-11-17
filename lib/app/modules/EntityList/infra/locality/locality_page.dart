import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/infra/locality/locality_page_controller.dart';
import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:provider/provider.dart';

class Localities extends StatelessWidget {
  const Localities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LocalitiesPageController>(context);
    final localities = controller.entities;

    return EntityList<Locality>(
      title: "Localidades",
      controller: controller,
      onCallback: () =>
          context.read<LocalitiesPageController>().getLocalities(),
      newPage: "/localities/new",
      buttonText: "Nova Localidade",
      itemBuilder: (_, index) {
        final locality = localities[index];

        return CustomCard(
            title: locality.name,
            upperTitle: locality.ibgeCode,
            startInfo: "${locality.city} - ${locality.state}",
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/localities/new", arguments: locality)
                .whenComplete(
                  () =>
                      context.read<LocalitiesPageController>().getLocalities(),
                ));
      },
    );
  }
}
