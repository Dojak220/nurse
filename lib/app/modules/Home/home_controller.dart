import 'package:mobx/mobx.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_application_repository.dart';
import 'package:nurse/shared/repositories/vaccination/application_repository.dart';
import 'package:nurse/shared/utils/helper.dart';

class HomeController {
  final ApplicationRepository applicationRepository;

  final applications = ObservableList<Application>.of(
    List<Application>.empty(growable: true),
  );

  late final fetchApplications = Action(_fetchApplications);

  HomeController() : applicationRepository = DatabaseApplicationRepository() {
    _fetchApplications(applicationRepository);
  }

  Future<List<Application>> _fetchApplications(ApplicationRepository aR) async {
    final result = await aR.getApplications();
    applications.addAll(result);

    return applications;
  }

  Map<String, int> applicationCount() {
    final applicationCountMap = Map<String, int>.of({
      "dia": Helper.applicationsForPeriod(applications, Period.day),
      "semana": Helper.applicationsForPeriod(applications, Period.week),
      "mês": Helper.applicationsForPeriod(applications, Period.month),
    });

    return applicationCountMap;
  }
}
