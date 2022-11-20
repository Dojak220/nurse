// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exporter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Exporter on _ExporterBase, Store {
  Computed<String?>? _$startDateTextComputed;

  @override
  String? get startDateText =>
      (_$startDateTextComputed ??= Computed<String?>(() => super.startDateText,
              name: '_ExporterBase.startDateText'))
          .value;
  Computed<String?>? _$endDateTextComputed;

  @override
  String? get endDateText =>
      (_$endDateTextComputed ??= Computed<String?>(() => super.endDateText,
              name: '_ExporterBase.endDateText'))
          .value;

  late final _$dateTimeRangeAtom =
      Atom(name: '_ExporterBase.dateTimeRange', context: context);

  @override
  DateTimeRange? get dateTimeRange {
    _$dateTimeRangeAtom.reportRead();
    return super.dateTimeRange;
  }

  @override
  set dateTimeRange(DateTimeRange? value) {
    _$dateTimeRangeAtom.reportWrite(value, super.dateTimeRange, () {
      super.dateTimeRange = value;
    });
  }

  late final _$startDateAtom =
      Atom(name: '_ExporterBase.startDate', context: context);

  @override
  DateTime? get startDate {
    _$startDateAtom.reportRead();
    return super.startDate;
  }

  @override
  set startDate(DateTime? value) {
    _$startDateAtom.reportWrite(value, super.startDate, () {
      super.startDate = value;
    });
  }

  late final _$endDateAtom =
      Atom(name: '_ExporterBase.endDate', context: context);

  @override
  DateTime? get endDate {
    _$endDateAtom.reportRead();
    return super.endDate;
  }

  @override
  set endDate(DateTime? value) {
    _$endDateAtom.reportWrite(value, super.endDate, () {
      super.endDate = value;
    });
  }

  late final _$_ExporterBaseActionController =
      ActionController(name: '_ExporterBase', context: context);

  @override
  void setDateRange(DateTimeRange dateTimeRange) {
    final _$actionInfo = _$_ExporterBaseActionController.startAction(
        name: '_ExporterBase.setDateRange');
    try {
      return super.setDateRange(dateTimeRange);
    } finally {
      _$_ExporterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStartDate(DateTime startDate) {
    final _$actionInfo = _$_ExporterBaseActionController.startAction(
        name: '_ExporterBase.setStartDate');
    try {
      return super.setStartDate(startDate);
    } finally {
      _$_ExporterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEndDate(DateTime endDate) {
    final _$actionInfo = _$_ExporterBaseActionController.startAction(
        name: '_ExporterBase.setEndDate');
    try {
      return super.setEndDate(endDate);
    } finally {
      _$_ExporterBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dateTimeRange: ${dateTimeRange},
startDate: ${startDate},
endDate: ${endDate},
startDateText: ${startDateText},
endDateText: ${endDateText}
    ''';
  }
}
