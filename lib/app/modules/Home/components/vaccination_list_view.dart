import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/titled_list_view.dart';
import 'package:nurse/app/modules/Home/components/vaccination_card.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:provider/provider.dart';

class VaccinationListView extends StatelessWidget {
  const VaccinationListView(
    this.title, {
    Key? key,
    required this.applications,
  }) : super(key: key);

  final String title;
  final List<Application> applications;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => TitledListView(
        title,
        itemCount: applications.length,
        itemBuilder: ((_, i) {
          final application = applications[i];

          return VaccinationCard(
            cns: application.patient.cns,
            name: application.patient.person.name,
            vaccine: application.vaccineBatch.vaccine.name,
            group: application.patient.priorityCategory.priorityGroup.name,
            pregnant: application.patient.maternalCondition.name,

            /// TODO: Adicionar lógica no controller para adicionar a informação que vem de application.
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/vaccination/new", arguments: application)
                .whenComplete(
                  () => context.read<HomeController>().getApplications(),
                ),
          );
        }),
      ),
    );
  }
}
