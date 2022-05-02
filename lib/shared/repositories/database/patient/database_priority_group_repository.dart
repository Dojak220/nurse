import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class DatabasePriorityGroupRepository extends DatabaseInterface
    implements PriorityGroupRepository {
  static const String TABLE = "Priority_Group";
  final DatabaseManager dbManager;

  DatabasePriorityGroupRepository(this.dbManager) : super(dbManager, TABLE);

  @override
  Future<int> createPriorityGroup(PriorityGroup priorityGroup) async {
    final int result = await create(priorityGroup.toMap());

    return result;
  }

  @override
  Future<int> deletePriorityGroup(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<PriorityGroup> getPriorityGroupById(int id) async {
    try {
      final priorityGroupMap = await get(id);
      final priorityGroup = PriorityGroup.fromMap(priorityGroupMap);

      return priorityGroup;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PriorityGroup>> getPriorityGroups() async {
    try {
      final priorityGroupMaps = await getAll();

      final List<PriorityGroup> priorityGroups = List<PriorityGroup>.generate(
        priorityGroupMaps.length,
        (index) {
          return PriorityGroup.fromMap(priorityGroupMaps[index]);
        },
      );

      return priorityGroups;
    } catch (e) {
      return List<PriorityGroup>.empty();
    }
  }

  @override
  Future<int> updatePriorityGroup(PriorityGroup priorityGroup) async {
    final int updatedCount = await update(priorityGroup.toMap());

    return updatedCount;
  }
}
