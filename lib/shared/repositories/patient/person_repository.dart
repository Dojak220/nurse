import 'package:nurse/shared/models/patient/person_model.dart';

abstract class PersonRepository {
  Future<int> createPerson(Person patient);
  Future<void> deletePerson(int id);
  Future<Person> getPersonById(int id);
  Future<List<Person>> getPersons();
  Future<int> updatePerson(Person patient);
}
