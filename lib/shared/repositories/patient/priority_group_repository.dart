import 'package:nurse/shared/models/patient/priority_group_model.dart';

abstract class PriorityGroupRepository {
  Future<int> createPriorityGroup(PriorityGroup priorityGroup);
  Future<int> deletePriorityGroup(int id);
  Future<PriorityGroup> getPriorityGroupById(int id);
  Future<List<PriorityGroup>> getPriorityGroups();
  Future<int> updatePriorityGroup(PriorityGroup priorityGroup);
}
