import 'package:nurse/shared/models/infra/establishment_model.dart';

abstract class EstablishmentRepository {
  Future<int> createEstablishment(Establishment establishment);
  Future<int> deleteEstablishment(int id);
  Future<Establishment> getEstablishmentById(int id);
  Future<List<Establishment>> getEstablishments();
  Future<int> updateEstablishment(Establishment establishment);
}
