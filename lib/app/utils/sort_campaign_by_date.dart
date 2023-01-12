import "package:nurse/shared/models/infra/campaign_model.dart";

extension SortByDate on List<Campaign> {
  void sortByDate() {
    sort((Campaign a, Campaign b) {
      final int comparisonByStartDate = _sortByStartDate(a, b);

      return comparisonByStartDate != 0
          ? comparisonByStartDate
          : _sortByEndDate(a, b);
    });
  }

  int _sortByStartDate(Campaign a, Campaign b) =>
      a.startDate.compareTo(b.startDate);

  int _sortByEndDate(Campaign a, Campaign b) => a.endDate.compareTo(b.endDate);
}
