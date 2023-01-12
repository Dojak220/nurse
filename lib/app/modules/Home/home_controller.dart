import "package:flutter/material.dart" hide Action;
import "package:mobx/mobx.dart";
import "package:nurse/app/modules/Home/exporter.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";
import "package:nurse/shared/repositories/database/vaccination/database_application_repository.dart";
import "package:nurse/shared/repositories/vaccination/application_repository.dart";
import "package:nurse/shared/utils/helper.dart";

class HomeController {
  final ApplicationRepository applicationRepository;
  final Exporter exporter = Exporter();

  final ObservableList<Application> applications =
      ObservableList<Application>.of(
    List<Application>.empty(growable: true),
  );
  late final Action fetchApplications = Action(getApplications);

  HomeController({ApplicationRepository? applicationRepository})
      : applicationRepository =
            applicationRepository ?? DatabaseApplicationRepository() {
    fetchApplications();
  }

  Future<List<Application>> getApplications() async {
    final result = await applicationRepository.getApplications();
    applications
      ..clear()
      ..addAll(result.reversed);

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

  Future<void> shareExcelFile(DateTimeRange dateRange) {
    return exporter.shareExcelFile(applications, dateRange);
  }

  Future<void> openExcelFile(DateTimeRange dateRange) {
    return exporter.openExcelFile(applications, dateRange);
  }
}
