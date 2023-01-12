import "package:nurse/shared/models/vaccination/applier_model.dart";

abstract class ApplierRepository {
  Future<int> createApplier(Applier applier);
  Future<int> deleteApplier(int id);
  Future<Applier> getApplierById(int id);
  Future<Applier> getApplierByCns(String cns);
  Future<List<Applier>> getAppliers();
  Future<int> updateApplier(Applier applier);
}
