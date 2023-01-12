import "package:nurse/shared/models/infra/locality_model.dart";

abstract class LocalityRepository {
  Future<int> createLocality(Locality locality);
  Future<int> deleteLocality(int id);
  Future<Locality> getLocalityById(int id);
  Future<Locality> getLocalityByIbgeCode(String ibgeCode);
  Future<List<Locality>> getLocalities();
  Future<List<Locality>> getLocalitiesByStateAndCity(
    String state,
    String city,
  );
  Future<int> updateLocality(Locality locality);
}
