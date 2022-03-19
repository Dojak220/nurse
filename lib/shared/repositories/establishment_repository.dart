import 'package:nurse/shared/models/infra/establishment_model.dart';

abstract class EstablishmentRepository {
  Future<int> createEstablishment(Establishment establishment);
  Future<void> deleteEstablishment(int id);
  Future<Establishment> getEstablishment(int id);
  Future<List<Establishment>> getEstablishments();
  Future<int> updateEstablishment(Establishment establishment);
}
