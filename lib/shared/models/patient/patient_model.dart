import 'package:nurse/shared/models/infra/locality_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/utils/validator.dart';

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
        ) {
    Validator.validate(ValidatorType.Id, id);
    Validator.validate(ValidatorType.CNS, cns);
  }
}

enum MaternalCondition { NENHUM, GESTANTE, PUERPERA }
