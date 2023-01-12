import "package:nurse/shared/models/vaccination/vaccine_batch_model.dart";

abstract class VaccineBatchRepository {
  Future<int> createVaccineBatch(VaccineBatch vaccineBatch);
  Future<int> deleteVaccineBatch(int id);
  Future<VaccineBatch> getVaccineBatchById(int id);
  Future<VaccineBatch> getVaccineBatchByNumber(String number);
  Future<List<VaccineBatch>> getVaccineBatches();
  Future<int> updateVaccineBatch(VaccineBatch vaccineBatch);
}
