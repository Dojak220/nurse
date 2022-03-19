import 'package:nurse/app/models/infra/locality_model.dart';
import 'package:nurse/app/models/patient/priority_group_model.dart';
import 'package:nurse/app/models/patient/person_model.dart';

class Patient extends PersonModel {
  final String cns;
  final PriorityGroupModel priorityGroup;
  final MaternalCondition maternalCondition;

  Patient({
    required this.cns,
    required this.priorityGroup,
    required this.maternalCondition,
    required String cpf,
    required String name,
    required DateTime birthDate,
    required Locality locality,
    String gender = "",
    String motherName = "",
    String fatherName = "",
  }) : super(
          cpf: cpf,
          name: name,
          birthDate: birthDate,
          locality: locality,
          gender: gender,
          motherName: motherName,
          fatherName: fatherName,
        );
}

enum MaternalCondition { NENHUM, GESTANTE, PUERPERA }
