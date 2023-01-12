import "package:flutter/material.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";

class Helper {
  static int applicationsForPeriod(
    List<Application> applications,
    Period period,
  ) {
    switch (period) {
      case Period.day:
        return applications
            .where(
              (element) =>
                  DateTime.now().difference(element.applicationDate).inDays ==
                      0 &&
                  element.applicationDate.day == DateTime.now().day,
            )
            .toList()
            .length;
      case Period.week:
        return applications
            .where((element) {
              return DateTime.now()
                      .difference(element.applicationDate)
                      .inDays <=
                  DateTime.now().weekday;
            })
            .toList()
            .length;
      case Period.month:
        return applications
            .where(
              (element) =>
                  element.applicationDate.year == DateTime.now().year &&
                  element.applicationDate.month == DateTime.now().month,
            )
            .toList()
            .length;
    }
  }

  static Map<DateTime, List<Application>> applicationsForRange(
    List<Application> applications,
    DateTimeRange dateRange,
  ) {
    final startDate = DateTime(
      dateRange.start.year,
      dateRange.start.month,
      dateRange.start.day,
    );

    final endDate = DateTime(
      dateRange.end.year,
      dateRange.end.month,
      dateRange.end.day,
      23,
      59,
      59,
    );

    final applicationsInRange = applications.where((element) {
      return element.applicationDate.isBetween(startDate, endDate);
    }).toList();

    final applicationsGroupedByDate = Map<DateTime, List<Application>>.of(
      applicationsInRange.fold(
        Map<DateTime, List<Application>>.of({}),
        (previousValue, element) {
          if (previousValue.containsKey(element.applicationDate)) {
            previousValue[element.applicationDate]!.add(element);
          } else {
            previousValue[element.applicationDate] = [element];
          }

          return previousValue;
        },
      ),
    );

    return applicationsGroupedByDate;
  }

  /// Get applications by dose
  static Map<VaccineDose, List<Application>> applicationsByDose(
    List<Application> applications,
  ) {
    final applicationsByDose = Map<VaccineDose, List<Application>>.of(
      applications.fold(
        Map<VaccineDose, List<Application>>.of({}),
        (previousValue, element) {
          if (previousValue.containsKey(element.dose)) {
            previousValue[element.dose]!.add(element);
          } else {
            previousValue[element.dose] = [element];
          }

          return previousValue;
        },
      ),
    );

    return applicationsByDose;
  }
}

enum Period {
  day,
  week,
  month,
}

extension DateTimeExtension on DateTime {
  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);

    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);

    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);

    return isAfter && isBefore;
  }
}
