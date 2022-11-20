import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/date_field.dart';
import 'package:nurse/app/components/main_button.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ExportVaccinationDataPage extends StatelessWidget {
  const ExportVaccinationDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Período específico",
              textAlign: TextAlign.start,
              style: AppTheme.tileTitleStyle,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Observer(builder: (_) {
                    return DateField(
                        value: controller.exporter.startDateText,
                        label: "De",
                        onTap: () => _selectDate(context));
                  }),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Observer(builder: (_) {
                    return DateField(
                        value: controller.exporter.endDateText,
                        label: "Até",
                        onTap: () => _selectDate(context, isStartDate: false));
                  }),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: Observer(builder: (_) {
                return MainButton(
                  text: "Exportar",
                  isEnable: controller.exporter.dateTimeRange != null,
                  onPressed: controller.exporter.dateTimeRange != null
                      ? () async => await showAlertDialog(
                          context, controller.exporter.dateTimeRange!)
                      : () {},
                );
              }),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<DateTimeRange?> _selectDate(BuildContext context,
      {bool isStartDate = true}) async {
    final controller = context.read<HomeController>();

    return showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.verdeEscuro,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
            dialogBackgroundColor: AppColors.white,
          ),
          child: child!,
        );
      },
    ).then((value) async {
      if (value != null) {
        isStartDate
            ? controller.exporter.setStartDate(value)
            : controller.exporter.setEndDate(value);
      }
      return null;
    });
  }

  Future<void> showAlertDialog(
      BuildContext context, DateTimeRange dateRange) async {
    final controller = context.read<HomeController>();

    return showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Icon(
                    Icons.file_open,
                    size: 120.0,
                  ),
                  Text(
                    'O que deseja fazer com a planilha de vacinações?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => controller.shareExcelFile(dateRange),
                  style: AppTheme.dialogButtonStyle,
                  child: const Text("Compartilhar"),
                ),
                Visibility(
                  child: ElevatedButton(
                    onPressed: () => controller.openExcelFile(dateRange),
                    style: AppTheme.dialogButtonStyle,
                    child: const Text("Abrir"),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceAround,
            ));
  }
}
