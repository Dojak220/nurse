import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/vaccination/vaccine/vaccine_page_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';

class Vaccines extends StatelessWidget {
  final VaccinesPageController controller;
  const Vaccines(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final vaccines = controller.entities;

      return EntityList<Vaccine>(
        title: "Vacinas",
        entities: vaccines,
        onCallback: () => controller.getVaccines(),
        newPage: "/vaccines/new",
        buttonText: "Nova Vacina",
        isLoading: controller.isLoading,
        itemBuilder: (_, index) {
          final vaccine = vaccines[index];

          return CustomCard(
              title: vaccine.name,
              upperTitle: vaccine.sipniCode,
              startInfo: vaccine.laboratory,
              onEditPressed: () => Navigator.of(context)
                  .pushNamed("/vaccines/new", arguments: vaccine)
                  .whenComplete(
                    () => controller.getVaccines(),
                  ));
        },
      );
    });
  }
}
