import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/models/patient/priority_group_model.dart';
import 'package:nurse/shared/repositories/database/database_interface.dart';
import 'package:nurse/shared/repositories/database/database_manager.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_group_repository.dart';

class DatabasePriorityCategoryRepository extends DatabaseInterface
    implements PriorityCategoryRepository {
  static const String TABLE = "Priority_Category";
  PriorityGroupRepository groupRepo;

  DatabasePriorityCategoryRepository({
    DatabaseManager? dbManager,
    required this.groupRepo,
  }) : super(TABLE, dbManager);

  @override
  Future<int> createPriorityCategory(PriorityCategory priorityCategory) async {
    final int result = await create(priorityCategory.toMap());

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
      final priorityCategoryMap = await get(id);

      final priorityGroup = await _getPriorityGroup(
        priorityCategoryMap["priority_group"],
      );

      priorityCategoryMap["priority_group"] = priorityGroup.toMap();

      final priorityCategory = PriorityCategory.fromMap(priorityCategoryMap);

      return priorityCategory;
    } catch (e) {
      rethrow;
    }
  }

  Future<PriorityGroup> _getPriorityGroup(int id) async {
    final priorityGroup = await groupRepo.getPriorityGroupById(id);

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
    final priorityGroups = await groupRepo.getPriorityGroups();

    return priorityGroups;
  }

  @override
  Future<int> updatePriorityCategory(PriorityCategory priorityCategory) async {
    final int updatedCount = await update(priorityCategory.toMap());

    return updatedCount;
  }
}
