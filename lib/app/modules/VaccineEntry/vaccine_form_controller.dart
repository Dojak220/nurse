import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';

class VaccineFormController extends FormController {
  final VaccineBatchRepository _batchRepository;
  final _vaccineBatches = List<VaccineBatch>.empty(growable: true);
  List<VaccineBatch> get vaccineBatches => _vaccineBatches;

  Vaccine? vaccine;

  late String? sipniCode;
  late String? name;
  late String? laboratory;
  late VaccineBatch? selectedBatch;

  VaccineFormController([
    VaccineBatchRepository? batchRepository,
  ]) : _batchRepository = batchRepository ?? DatabaseVaccineBatchRepository() {
    _getVaccineBatches();
  }

  void _getVaccineBatches() async {
    _vaccineBatches.addAll(await _batchRepository.getVaccineBatches());
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();

    vaccine = Vaccine(
      sipniCode: sipniCode!,
      name: name!,
      laboratory: laboratory!,
    );
  }
}
