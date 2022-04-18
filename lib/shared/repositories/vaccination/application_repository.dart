import 'package:nurse/shared/models/vaccination/application_model.dart';

abstract class ApplicationRepository {
  Future<int> createApplication(Application application);
  Future<void> deleteApplication(int id);
  Future<Application> getApplicationById(int id);
  Future<List<Application>> getApplications();
  Future<int> updateApplication(Application application);
}