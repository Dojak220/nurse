import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_group_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class DatabasePriorityCategoryRepository extends DatabaseInterface
    implements PriorityCategoryRepository {
  static const String TABLE = "Priority_Category";
  final PriorityGroupRepository _groupRepo;

  DatabasePriorityCategoryRepository({
    DatabaseManager? dbManager,
    PriorityGroupRepository? groupRepo,
  })  : _groupRepo = groupRepo ?? DatabasePriorityGroupRepository(),
        super(TABLE, dbManager);

  @override
  Future<int> createPriorityCategory(PriorityCategory priorityCategory) async {
    final map = priorityCategory.toMap();

    map['priority_group'] = await _groupRepo
        .getPriorityGroupByCode(priorityCategory.priorityGroup.code)
        .then((priorityGroup) => priorityGroup.id!);

    final int result = await create(map);

    return result;
  }

  @override
  Future<int> deletePriorityCategory(int id) async {
    final int deletedCount = await delete(id);

    return deletedCount;
  }

  @override
  Future<PriorityCategory> getPriorityCategoryById(int id) async {
    try {
      return _getPriorityCategoryFromMap(await getById(id));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PriorityCategory> getPriorityCategoryByCode(String code) async {
    try {
      return _getPriorityCategoryFromMap(
        await get(objs: [code], where: "code = ?").then(
          (map) => map.first,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<PriorityCategory> _getPriorityCategoryFromMap(
    Map<String, dynamic> categoryMap,
  ) async {
    final priorityGroup = await _getPriorityGroup(
      categoryMap["priority_group"],
    );

    final updatedPriorityCategoryMap = Map.of(categoryMap);
    updatedPriorityCategoryMap["priority_group"] = priorityGroup.toMap();

    return PriorityCategory.fromMap(updatedPriorityCategoryMap);
  }

  Future<PriorityGroup> _getPriorityGroup(int id) async {
    final priorityGroup = await _groupRepo.getPriorityGroupById(id);

    return priorityGroup;
  }

  @override
  Future<List<PriorityCategory>> getPriorityCategories() async {
    try {
      final priorityCategoryMaps = await getAll();
      final priorityGroups = await _getPriorityGroups();

      priorityCategoryMaps.forEach((c) {
        final priorityGroup = priorityGroups.firstWhere((g) {
          return g.id == c["priority_group"];
        });

        c["priority_group"] = priorityGroup.toMap();
      });

      final priorityCategories = priorityCategoryMaps
          .map((priorityCategory) => PriorityCategory.fromMap(priorityCategory))
          .toList();

      return priorityCategories;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PriorityGroup>> _getPriorityGroups() async {
    final priorityGroups = await _groupRepo.getPriorityGroups();

    return priorityGroups;
  }

  @override
  Future<int> updatePriorityCategory(PriorityCategory priorityCategory) async {
    final int updatedCount = await update(priorityCategory.toMap());

    return updatedCount;
  }
}
