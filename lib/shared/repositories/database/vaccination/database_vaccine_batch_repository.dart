import 'package:nurse/shared/models/vaccination/vaccine_batch_model.dart';
import 'package:nurse/shared/models/vaccination/vaccine_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_vaccine_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_batch_repository.dart';
import 'package:nurse/shared/repositories/vaccination/vaccine_repository.dart';

class DatabaseVaccineBatchRepository extends DatabaseInterface
    implements VaccineBatchRepository {
  // ignore: constant_identifier_names
  static const String TABLE = "Vaccine_Batch";
  final VaccineRepository _vaccineRepo;

  DatabaseVaccineBatchRepository([
    DatabaseManager? dbManager,
    VaccineRepository? vaccineRepo,
  ])  : _vaccineRepo = vaccineRepo ?? DatabaseVaccineRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createVaccineBatch(VaccineBatch vaccineBatch) async {
    final map = vaccineBatch.toMap();

    map['vaccine'] = await _vaccineRepo
        .getVaccineBySipniCode(vaccineBatch.vaccine.sipniCode)
        .then((vaccine) => vaccine.id!);

    final int result = await create(map);

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
      return _getVaccineBatchFromMap(await getById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VaccineBatch> getVaccineBatchByNumber(String number) async {
    try {
      return _getVaccineBatchFromMap(
        await get(objs: [number], where: "number = ?").then(
          (maps) => maps.single,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<VaccineBatch> _getVaccineBatchFromMap(
      Map<String, dynamic> vaccineBatchMap) async {
    final vaccine = await _getVaccine(vaccineBatchMap["vaccine"] as int);

    final updatedVaccineBatchMap = Map.of(vaccineBatchMap);
    updatedVaccineBatchMap["vaccine"] = vaccine.toMap();

    return VaccineBatch.fromMap(updatedVaccineBatchMap);
  }

  Future<Vaccine> _getVaccine(int id) async {
    final vaccine = await _vaccineRepo.getVaccineById(id);

    return vaccine;
  }

  @override
  Future<List<VaccineBatch>> getVaccineBatches() async {
    try {
      final vaccineBatchMaps = await getAll();
      final vaccines = await _getVaccines();

      for (final vaccineBatchMap in vaccineBatchMaps) {
        final vaccine = vaccines.firstWhere((vaccine) {
          return vaccine.id == vaccineBatchMap["vaccine"];
        });

        vaccineBatchMap["vaccine"] = vaccine.toMap();
      }

      final vaccineBatches = vaccineBatchMaps.map((batch) {
        return VaccineBatch.fromMap(batch);
      }).toList();

      return vaccineBatches;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Vaccine>> _getVaccines() async {
    final vaccines = await _vaccineRepo.getVaccines();

    return vaccines;
  }

  @override
  Future<int> updateVaccineBatch(VaccineBatch vaccineBatch) async {
    int count = await update(vaccineBatch.toMap());
    count += await _vaccineRepo.updateVaccine(vaccineBatch.vaccine);

    return count;
  }
}
