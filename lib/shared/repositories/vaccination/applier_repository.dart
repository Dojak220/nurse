import 'package:nurse/shared/models/vaccination/applier_model.dart';

abstract class ApplierRepository {
  Future<int> createApplier(Applier applier);
  Future<int> deleteApplier(int id);
  Future<Applier> getApplierById(int id);
  Future<List<Applier>> getAppliers();
  Future<int> updateApplier(Applier applier);
}
