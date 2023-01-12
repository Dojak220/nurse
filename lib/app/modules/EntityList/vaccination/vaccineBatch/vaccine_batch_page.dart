import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:nurse/app/components/custom_card.dart";
import "package:nurse/app/modules/EntityList/entity_list_page.dart";
import "package:nurse/app/modules/EntityList/vaccination/vaccineBatch/vaccine_batch_page_controller.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";

class VaccineBatches extends StatelessWidget {
  final VaccineBatchesPageController controller;
  const VaccineBatches(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final vaccineBatches = controller.entities.toList();

        return EntityList<VaccineBatch>(
          title: "Lote de Vacinas",
          entities: vaccineBatches,
          onCallback: () => controller.getVaccineBatches(),
          newPage: "/vaccineBatches/new",
          buttonText: "Novo Lote de Vacina",
          isLoading: controller.isLoading,
          itemBuilder: (_, index) {
            final vaccineBatch = vaccineBatches[index];

            return CustomCard(
              title: vaccineBatch.vaccine.name,
              upperTitle: vaccineBatch.number,
              startInfo: "${vaccineBatch.quantity} unidades",
              onEditPressed: () async => Navigator.of(context)
                  .pushNamed("/vaccineBatches/new", arguments: vaccineBatch)
                  .whenComplete(
                    () => controller.getVaccineBatches(),
                  ),
            );
          },
        );
      },
    );
  }
}
