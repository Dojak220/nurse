import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker {
  static Future<DateTime?> getNewDate(
      BuildContext context, DateTime? actualDate) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: actualDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    return newSelectedDate;
  }

  static formatDateDDMMYYYY(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
}
