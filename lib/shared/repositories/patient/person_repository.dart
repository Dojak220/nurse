import 'package:nurse/shared/models/patient/person_model.dart';

abstract class PersonRepository {
  Future<int> createPerson(Person patient);
  Future<int> deletePerson(int id);
  Future<Person> getPersonById(int id);
  Future<Person> getPersonByCpf(String cpf);
  Future<List<Person>> getPersons();
  Future<int> updatePerson(Person patient);
}
