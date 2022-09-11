import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class DatabaseVaccineRepository extends DatabaseInterface
    implements VaccineRepository {
  // ignore: constant_identifier_names
  static const String TABLE = "Vaccine";

  DatabaseVaccineRepository({DatabaseManager? dbManager})
      : super(TABLE, dbManager);

  @override
  Future<int> createVaccine(Vaccine vaccine) async {
    final int result = await create(vaccine.toMap());

    return result;
  }

  @override
  Future<int> deleteVaccine(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<Vaccine> getVaccineById(int id) async {
    try {
      final vaccineMap = await getById(id);

      return Vaccine.fromMap(vaccineMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Vaccine> getVaccineBySipniCode(String code) async {
    try {
      final vaccineMap = await get(objs: [code], where: "sipni_code = ?");

      return Vaccine.fromMap(vaccineMap.single);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Vaccine>> getVaccines() async {
    try {
      final vaccineMaps = await getAll();

      final vaccines = List<Vaccine>.generate(vaccineMaps.length, (index) {
        return Vaccine.fromMap(vaccineMaps[index]);
      });

      return vaccines;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateVaccine(Vaccine vaccine) async {
    final int updatedCount = await update(vaccine.toMap());

    return updatedCount;
  }
}
