import 'package:nurse/shared/models/patient/priority_category_model.dart';

abstract class PriorityCategoryRepository {
  Future<int> createPriorityCategory(PriorityCategory priorityCategory);
  Future<void> deletePriorityCategory(int id);
  Future<PriorityCategory> getPriorityCategoryById(int id);
  Future<List<PriorityCategory>> getPriorityCategories();
  Future<int> updatePriorityCategory(PriorityCategory priorityCategory);
}
