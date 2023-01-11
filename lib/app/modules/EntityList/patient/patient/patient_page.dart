import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/custom_card.dart';
import 'package:nurse/app/modules/EntityList/entity_list_page.dart';
import 'package:nurse/app/modules/EntityList/patient/patient/patient_page_controller.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';

class Patients extends StatelessWidget {
  final PatientsPageController controller;
  const Patients(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final patients = controller.entities;

      return EntityList<Patient>(
        title: "Pacientes",
        entities: patients,
        onCallback: () => {},
        newPage: "/patients/new",
        buttonText: "Novo(a) Paciente",
        isLoading: controller.isLoading,
        itemBuilder: (_, index) {
          final patient = patients[index];

          return CustomCard(
            title: patient.person.name,
            upperTitle: patient.cns,
            startInfo: patient.priorityCategory.name,
            endInfo: patient.maternalCondition.name,
            onEditPressed: () => Navigator.of(context)
                .pushNamed("/patients/new", arguments: patient)
                .whenComplete(
                  () => controller.getPatients(),
                ),
          );
        },
      );
    });
  }
}
