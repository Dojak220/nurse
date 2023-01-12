import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:nurse/app/theme/app_colors.dart";

class DatePicker {
  static Future<DateTime?> getNewDate(
    BuildContext context,
    DateTime? actualDate, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final newSelectedDate = await showDatePicker(
      context: context,
      initialDate: actualDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.verdeEscuro,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    );

    return newSelectedDate;
  }

  static String formatDateDDMMYYYY(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  static DateTime getDateFromString(String date) {
    return DateFormat("dd/MM/yyyy").parse(date);
  }
}
