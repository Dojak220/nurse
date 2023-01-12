import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:nurse/app/components/custom_card.dart";
import "package:nurse/app/modules/EntityList/entity_list_page.dart";
import "package:nurse/app/modules/EntityList/infra/establishment/establishment_page_controller.dart";
import "package:nurse/shared/models/infra/establishment_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";

class Establishments extends StatelessWidget {
  final EstablishmentsPageController controller;
  const Establishments(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final establishments = controller.entities.toList();

        return EntityList<Establishment>(
          title: "Estabelecimentos",
          entities: establishments,
          onCallback: () async => controller.getEstablishments(),
          newPage: "/establishments/new",
          buttonText: "Novo Estabelecimento",
          isLoading: controller.isLoading,
          itemBuilder: (_, int index) {
            final Establishment establishment = establishments[index];
            final Locality locality = establishment.locality;

            return CustomCard(
              title: establishment.name,
              upperTitle: establishment.cnes,
              startInfo: "${locality.city} - ${locality.state}",
              onEditPressed: () async => Navigator.of(context)
                  .pushNamed("/establishments/new", arguments: establishment)
                  .whenComplete(
                    () => controller.getEstablishments(),
                  ),
            );
          },
        );
      },
    );
  }
}
