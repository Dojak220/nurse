import 'package:nurse/shared/models/infra/locality_model.dart';

abstract class LocalityRepository {
  Future<int> createLocality(Locality locality);
  Future<void> deleteLocality(int id);
  Future<Locality> getLocalityById(int id);
  Future<List<Locality>> getLocalities();
  Future<int> updateLocality(Locality locality);
}
