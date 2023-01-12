import "package:nurse/shared/models/patient/patient_model.dart";
import "package:nurse/shared/models/patient/person_model.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";

String enumToName(Enum enumValue) {
  final type = enumValue.runtimeType;
  switch (type) {
    case Sex:
      return (enumValue as Sex).name;
    case MaternalCondition:
      return (enumValue as MaternalCondition).name;
    case VaccineDose:
      return (enumValue as VaccineDose).name;

    default:
      throw Exception("Invalid enum type");
  }
}
