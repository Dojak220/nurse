import 'package:nurse/app/models/Infra/locality_model.dart';
import 'package:nurse/app/models/Patient/priority_group_model.dart';
import 'package:nurse/app/models/Patient/person_model.dart';

class PatientModel extends PersonModel {
  final String cns;
  final PriorityGroupModel priorityGroup;
  final MaternalCondition maternalCondition;

  PatientModel({
    required this.cns,
    required this.priorityGroup,
    required this.maternalCondition,
    required String cpf,
    required String name,
    required DateTime birthDate,
    required LocalityModel locality,
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