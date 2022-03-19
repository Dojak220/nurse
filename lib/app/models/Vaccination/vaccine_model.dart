import 'package:nurse/app/models/vaccination/vaccine_batch_model.dart';

class Vaccine {
  final String sipniCode;
  final String name;
  final String laboratory;
  final VaccineBatchModel vaccineBatch;

  Vaccine(
    this.sipniCode,
    this.name,
    this.laboratory,
    this.vaccineBatch,
  );
}
