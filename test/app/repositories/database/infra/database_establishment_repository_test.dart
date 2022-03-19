import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nurse/app/models/infra/establishment_model.dart';
import 'package:nurse/app/models/infra/locality_model.dart';
import 'package:nurse/app/repositories/database/infra/database_establishment_repository.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import 'database_establishment_repository_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  final database = MockDatabase();

  final repository = DatabaseEstablishmentRepository(database);
  final validEstablishment = Establishment(
    id: 1,
    cnes: "1234567",
    name: "Test",
    locality: Locality(1, "Nome da localidade", "Brasília", "DF", "IBGECode"),
  );

  setUp(() {
    when(repository.createEstablishment(validEstablishment))
        .thenAnswer((_) async => Future.value(1));
  });

  test('should create a new establishment entry and return its id', () async {
    final int id = await repository.createEstablishment(validEstablishment);

    expect(id, 1);
  });

  test('should return expection if cnes is invalid', () async {
    final invalidCnes = Establishment(
      id: 1,
      cnes: "123456789",
      name: "Test",
      locality: Locality(1, "Nome da localidade", "Brasília", "DF", "IBGECode"),
    );
    final int id = await repository.createEstablishment(invalidCnes);

    // expect exception
  }, skip: true);
}
