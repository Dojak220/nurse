import "package:nurse/shared/models/vaccination/vaccine_model.dart";

abstract class VaccineRepository {
  Future<int> createVaccine(Vaccine vaccine);
  Future<int> deleteVaccine(int id);
  Future<Vaccine> getVaccineById(int id);
  Future<Vaccine> getVaccineBySipniCode(String code);
  Future<List<Vaccine>> getVaccines();
  Future<int> updateVaccine(Vaccine vaccine);
}
