import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine_batch_page_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:provider/provider.dart';

class VaccineBatches extends StatelessWidget {
  const VaccineBatches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VaccineBatchesPageController>(context);
    final vaccineBatches = controller.entities;

    return EntityList<VaccineBatch>(
      title: "Lote de Vacinas",
      controller: controller,
      onCallback: () =>
          context.read<VaccineBatchesPageController>().getVaccineBatches(),
      newPage: "/vaccineBatches/new",
      buttonText: "Novo Lote de Vacina",
      itemBuilder: (_, index) {
        final vaccineBatch = vaccineBatches[index];

        return CustomCard(
            title: vaccineBatch.vaccine.name,
            upperTitle: vaccineBatch.number,
            startInfo: "${vaccineBatch.quantity} unidades",
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/vaccineBatches/new", arguments: vaccineBatch)
                .whenComplete(
                  () => context
                      .read<VaccineBatchesPageController>()
                      .getVaccineBatches(),
                ));
      },
    );
  }
}
