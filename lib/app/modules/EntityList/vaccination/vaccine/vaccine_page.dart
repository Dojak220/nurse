import 'package:flutter/material.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/vaccine_page_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:provider/provider.dart';

class Vaccines extends StatelessWidget {
  const Vaccines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VaccinesPageController>(context);
    final vaccines = controller.entities;

    return EntityList<Vaccine>(
      title: "Vacinas",
      controller: controller,
      onCallback: () => context.read<VaccinesPageController>().getVaccines(),
      newPage: "/vaccines/new",
      buttonText: "Nova Vacina",
      itemBuilder: (_, index) {
        final vaccine = vaccines[index];

        return CustomCard(
            title: vaccine.name,
            upperTitle: vaccine.sipniCode,
            startInfo: vaccine.laboratory,
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/vaccines/new", arguments: vaccine)
                .whenComplete(
                  () => context.read<VaccinesPageController>().getVaccines(),
                ));
      },
    );
  }
}
