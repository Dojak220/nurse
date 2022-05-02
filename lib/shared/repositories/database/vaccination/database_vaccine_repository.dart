import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class DatabaseVaccineRepository extends DatabaseInterface
    implements VaccineRepository {
  static const String TABLE = "Vaccine";
  final DatabaseManager dbManager;

  DatabaseVaccineRepository(this.dbManager) : super(dbManager, TABLE);

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
      final vaccineMap = await get(id);

      final vaccineBatch = await _getVaccineBatch(vaccineMap["vaccineBatch"]);

      vaccineMap["vaccineBatch"] = vaccineBatch.toMap();

      final vaccine = Vaccine.fromMap(vaccineMap);

      return vaccine;
    } catch (e) {
      rethrow;
    }
  }

  Future<VaccineBatch> _getVaccineBatch(int id) async {
    final dbRepo = DatabaseVaccineBatchRepository(dbManager);
    final vaccineBatch = await dbRepo.getVaccineBatchById(id);

    return vaccineBatch;
  }

  @override
  Future<List<Vaccine>> getVaccines() async {
    try {
      final vaccineMaps = await getAll();
      final vaccineBatches = await _getVaccineBatches();

      vaccineMaps.forEach((v) {
        final vaccineBatch = vaccineBatches.firstWhere((b) {
          return b.id == v["vaccineBatch"];
        });

        v["vaccineBatch"] = vaccineBatch;
      });

      final vaccines = vaccineMaps.map((vaccine) {
        return Vaccine.fromMap(vaccine);
      }).toList();

      return vaccines;
    } catch (e) {
      return List<Vaccine>.empty();
    }
  }

  Future<List<VaccineBatch>> _getVaccineBatches() async {
    final dbRepo = DatabaseVaccineBatchRepository(dbManager);
    final vaccineBatches = await dbRepo.getVaccineBatches();

    return vaccineBatches;
  }

  @override
  Future<int> updateVaccine(Vaccine vaccine) async {
    final int updatedCount = await update(vaccine.toMap());

    return updatedCount;
  }
}
