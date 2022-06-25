import 'package:nurse/shared/models/vaccination/application_model.dart';

abstract class ApplicationRepository {
  Future<int> createApplication(Application application);
  Future<int> deleteApplication(int id);
  Future<Application> getApplicationById(int id);
  Future<bool> exists(Application application);
  Future<List<Application>> getApplications();
  Future<int> updateApplication(Application application);
}
