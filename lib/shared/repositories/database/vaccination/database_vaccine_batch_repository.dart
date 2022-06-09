import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';

class DatabaseVaccineBatchRepository extends DatabaseInterface
    implements VaccineBatchRepository {
  static const String TABLE = "Vaccine_Batch";

  DatabaseVaccineBatchRepository([DatabaseManager? dbManager])
      : super(TABLE, dbManager);

  @override
  Future<int> createVaccineBatch(VaccineBatch vaccineBatch) async {
    final int result = await create(vaccineBatch.toMap());

    return result;
  }

  @override
  Future<int> deleteVaccineBatch(int id) async {
    final int count = await delete(id);

    return count;
  }

  @override
  Future<VaccineBatch> getVaccineBatchById(int id) async {
    try {
      final vaccineBatchMap = await getById(id);
      final vaccineBatch = VaccineBatch.fromMap(vaccineBatchMap);

      return vaccineBatch;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VaccineBatch> getVaccineBatchByNumber(String number) async {
    try {
      final vaccineBatchMap = await get(number, where: "number = ?");
      final vaccineBatch = VaccineBatch.fromMap(vaccineBatchMap);

      return vaccineBatch;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<VaccineBatch>> getVaccineBatches() async {
    try {
      final vaccineBatchMaps = await getAll();

      final List<VaccineBatch> vaccineBatches = List<VaccineBatch>.generate(
        vaccineBatchMaps.length,
        (index) {
          return VaccineBatch.fromMap(vaccineBatchMaps[index]);
        },
      );

      return vaccineBatches;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateVaccineBatch(VaccineBatch vaccineBatch) async {
    final int count = await update(vaccineBatch.toMap());

    return count;
  }
}
