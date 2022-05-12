import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class DatabaseVaccineRepository extends DatabaseInterface
    implements VaccineRepository {
  static const String TABLE = "Vaccine";
  final VaccineBatchRepository vaccineBatchRepo;

  DatabaseVaccineRepository({
    DatabaseManager? dbManager,
    required this.vaccineBatchRepo,
  }) : super(TABLE, dbManager);

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

      final vaccineBatch = await _getVaccineBatch(vaccineMap["batch"]);

      vaccineMap["batch"] = vaccineBatch.toMap();

      final vaccine = Vaccine.fromMap(vaccineMap);

      return vaccine;
    } catch (e) {
      rethrow;
    }
  }

  Future<VaccineBatch> _getVaccineBatch(int id) async {
    final vaccineBatch = await vaccineBatchRepo.getVaccineBatchById(id);

    return vaccineBatch;
  }

  @override
  Future<List<Vaccine>> getVaccines() async {
    try {
      final vaccineMaps = await getAll();
      final vaccineBatches = await _getVaccineBatches();

      vaccineMaps.forEach((v) {
        final vaccineBatch = vaccineBatches.firstWhere((b) {
          return b.id == v["batch"];
        });

        v["batch"] = vaccineBatch.toMap();
      });

      final vaccines = vaccineMaps.map((vaccine) {
        return Vaccine.fromMap(vaccine);
      }).toList();

      return vaccines;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VaccineBatch>> _getVaccineBatches() async {
    final vaccineBatches = await vaccineBatchRepo.getVaccineBatches();

    return vaccineBatches;
  }

  @override
  Future<int> updateVaccine(Vaccine vaccine) async {
    final int updatedCount = await update(vaccine.toMap());

    return updatedCount;
  }
}
