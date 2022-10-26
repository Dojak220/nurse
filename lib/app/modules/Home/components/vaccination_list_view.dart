import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/titled_list_view.dart';
import 'package:nurse/app/modules/Home/components/vaccination_card.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';

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
            onEditPressed: () async {
              /// TODO: Jump to edit page and return to this page
              // await controller.updateApplication(entityList[i]);
            },
          );
        }),
      ),
    );
  }
}
