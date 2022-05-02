import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';

abstract class VaccineBatchRepository {
  Future<int> createVaccineBatch(VaccineBatch vaccineBatch);
  Future<void> deleteVaccineBatch(int id);
  Future<VaccineBatch> getVaccineBatchById(int id);
  Future<List<VaccineBatch>> getVaccineBatches();
  Future<int> updateVaccineBatch(VaccineBatch vaccineBatch);
}
