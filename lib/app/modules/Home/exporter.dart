import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nurse/app/utils/date_picker.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';
import 'package:nurse/shared/services/excel_service.dart';

part 'exporter.g.dart';

class Exporter = _ExporterBase with _$Exporter;

abstract class _ExporterBase with Store {
  final ExcelService excelService = ExcelService();

  @observable
  DateTimeRange? dateTimeRange;

  @observable
  DateTime? startDate;

  @observable
  DateTime? endDate;

  @action
  void setDateRange(DateTimeRange dateTimeRange) {
    this.dateTimeRange = dateTimeRange;
  }

  @action
  void setStartDate(DateTime startDate) {
    this.startDate = startDate;
    if (endDate != null) {
      setDateRange(DateTimeRange(start: startDate, end: endDate!));
    }
  }

  @action
  void setEndDate(DateTime endDate) {
    this.endDate = endDate;
    if (startDate != null) {
      setDateRange(DateTimeRange(start: startDate!, end: endDate));
    }
  }

  @computed
  String? get startDateText =>
      startDate != null ? DatePicker.formatDateDDMMYYYY(startDate!) : null;

  @computed
  String? get endDateText =>
      endDate != null ? DatePicker.formatDateDDMMYYYY(endDate!) : null;

  Future<void> shareExcelFile(
      List<Application> applications, DateTimeRange dateRange) {
    return excelService.shareExcelFile(applications, dateRange);
  }

  Future<void> openExcelFile(
      List<Application> applications, DateTimeRange dateRange) {
    return excelService.openExcelFile(applications, dateRange);
  }
}
