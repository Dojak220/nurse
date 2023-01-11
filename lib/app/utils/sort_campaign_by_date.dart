import 'package:nurse/shared/models/infra/campaign_model.dart';

extension SortByDate on List<Campaign> {
  void sortByDate() {
    sort((date1, date2) {
      final int comparisonByStartDate = _sortByStartDate(date1, date2);

      return comparisonByStartDate != 0
          ? comparisonByStartDate
          : _sortByEndDate(date1, date2);
    });
  }

  int _sortByStartDate(Campaign a, Campaign b) =>
      a.startDate.compareTo(b.startDate);

  int _sortByEndDate(Campaign a, Campaign b) => a.endDate.compareTo(b.endDate);
}
