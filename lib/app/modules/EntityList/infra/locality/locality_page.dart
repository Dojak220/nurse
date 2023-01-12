import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:nurse/app/components/custom_card.dart";
import "package:nurse/app/modules/EntityList/entity_list_page.dart";
import "package:nurse/app/modules/EntityList/infra/locality/locality_page_controller.dart";
import "package:nurse/shared/models/infra/locality_model.dart";

class Localities extends StatelessWidget {
  final LocalitiesPageController controller;
  const Localities(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final localities = controller.entities.toList();

        return EntityList<Locality>(
          title: "Localidades",
          entities: localities,
          onCallback: () async => controller.getLocalities(),
          newPage: "/localities/new",
          buttonText: "Nova Localidade",
          isLoading: controller.isLoading,
          itemBuilder: (_, int index) {
            final Locality locality = localities[index];

            return CustomCard(
              title: locality.name,
              upperTitle: locality.ibgeCode,
              startInfo: "${locality.city} - ${locality.state}",
              onEditPressed: () async => Navigator.of(context)
                  .pushNamed("/localities/new", arguments: locality)
                  .whenComplete(
                    () => controller.getLocalities(),
                  ),
            );
          },
        );
      },
    );
  }
}
