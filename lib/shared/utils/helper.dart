import 'package:nurse/shared/models/vaccination/application_model.dart';

class Helper {
  static int applicationsForPeriod(
    List<Application> applications,
    Period period,
  ) {
    switch (period) {
      case Period.day:
        return applications
            .where((element) =>
                DateTime.now().difference(element.applicationDate).inDays ==
                    0 &&
                element.applicationDate.day == DateTime.now().day)
            .toList()
            .length;
      case Period.week:
        return applications
            .where((element) {
              print(DateTime.now().difference(element.applicationDate).inDays);
              return DateTime.now()
                          .difference(element.applicationDate)
                          .inDays <=
                      7 &&
                  element.applicationDate.weekday == DateTime.now().weekday;
            })
            .toList()
            .length;
      case Period.month:
      default:
        return applications
            .where((element) =>
                DateTime.now().difference(element.applicationDate).inDays <=
                    365 &&
                element.applicationDate.month == DateTime.now().month)
            .toList()
            .length;
    }
  }
}

enum Period {
  day,
  week,
  month,
}
