import "package:nurse/app/utils/form_controller.dart";
import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";
import "package:nurse/shared/models/vaccination/vaccine_model.dart";
import "package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart";
import "package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart";

class VaccineFormController extends FormController {
  final VaccineBatchRepository _batchRepository;

  final _vaccineBatches = List<VaccineBatch>.empty(growable: true);
  List<VaccineBatch> get vaccineBatches => _vaccineBatches;
  List<Vaccine> get vaccines => List.of(
        vaccineBatches.map((batch) => batch.vaccine),
      );

  late Vaccine? selectedVaccine;
  late VaccineBatch? selectedBatch;

  VaccineFormController([
    VaccineBatchRepository? batchRepository,
  ]) : _batchRepository = batchRepository ?? DatabaseVaccineBatchRepository() {
    _getVaccineBatches();
    notifyListeners();
  }

  Future<void> _getVaccineBatches() async {
    _vaccineBatches.addAll(
      await _batchRepository.getVaccineBatches(),
    );
  }

  VaccineBatch? get vaccineBatch => selectedBatch;

  void setVaccineBatch(VaccineBatch vaccineBatch) {
    selectedBatch = vaccineBatch;
    selectedVaccine = vaccineBatch.vaccine;
    notifyListeners();
  }

  @override
  void clearAllInfo() {
    selectedVaccine = null;
    selectedBatch = null;
    notifyListeners();
  }

  @override
  void dispose() {
    /// Não tem o que desalocar aqui
  }
}
