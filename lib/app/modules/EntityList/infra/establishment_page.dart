import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/infra/establishment_page_controller.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:provider/provider.dart';

class Establishments extends StatelessWidget {
  const Establishments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EstablishmentsPageController>(context);
    final establishments = controller.entities;

    return EntityList<Establishment>(
      title: "Estabelecimentos",
      controller: controller,
      onCallback: () =>
          context.read<EstablishmentsPageController>().getEstablishments(),
      newPage: "/establishments/new",
      buttonText: "Novo Estabelecimento",
      itemBuilder: (_, index) {
        final establishment = establishments[index];

        return CustomCard(
            title: establishment.name,
            upperTitle: establishment.cnes,
            startInfo:
                "${establishment.locality.city} - ${establishment.locality.state}",
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/establishments/new", arguments: establishment)
                .whenComplete(
                  () => context
                      .read<EstablishmentsPageController>()
                      .getEstablishments(),
                ));
      },
    );
  }
}
