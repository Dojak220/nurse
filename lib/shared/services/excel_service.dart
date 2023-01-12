import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_archive/flutter_archive.dart";
import "package:nurse/shared/models/vaccination/application_model.dart";
import "package:nurse/shared/utils/helper.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart";

class ExcelService {
  Future<void> shareExcelFile(
    List<Application> items,
    DateTimeRange dateRange,
  ) async {
    final applicationsForRange = Helper.applicationsForRange(
      items,
      dateRange,
    );

    final dateMap = await _generateSheetData(applicationsForRange);
    final files = List<File>.empty(growable: true);

    for (final dateKey in dateMap.keys) {
      final doseMap = dateMap[dateKey]!;

      for (final doseKey in doseMap.keys) {
        final applications = doseMap[doseKey]!;

        final fileName =
            "vacinacao_${dateKey.year}_${dateKey.month}_${dateKey.day}_${doseKey.name}.xlsx";

        final file = await _createFile(applications, fileName);
        files.add(file);
      }
    }

    final sourceDir = await getTemporaryDirectory();

    final zipFile = File("${sourceDir.path}/vacinacao.zip");

    try {
      await ZipFile.createFromFiles(
        sourceDir: sourceDir,
        files: files,
        zipFile: zipFile,
      );
    } catch (e) {
      print(e);
    }

    await _shareFile(zipFile);
  }

  Future<void> openExcelFile(
    List<Application> items,
    DateTimeRange dateRange,
  ) async {
    final applicationsForRange = Helper.applicationsForRange(
      items,
      dateRange,
    );

    final dateMap = await _generateSheetData(applicationsForRange);

    if (dateMap.length == 1 && dateMap.values.first.length == 1) {
      final doseMap = dateMap.values.first;
      final applications = doseMap.values.first;

      final fileName =
          "vacinacao_${dateMap.keys.first.year}_${dateMap.keys.first.month}_${dateMap.keys.first.day}_${doseMap.keys.first.name}.xlsx";

      final file = await _createFile(applications, fileName);

      await _openFile(file);
    } else {
      shareExcelFile(items, dateRange);
    }
  }

  //Create a Excel document.
  Future<Map<DateTime, Map<VaccineDose, List<int>>>> _generateSheetData(
    Map<DateTime, List<Application>> data,
  ) async {
    /// https://pub.dev/packages/syncfusion_flutter_xlsio

    final works = Map<DateTime, Map<VaccineDose, List<int>>>.of({});

    for (final DateTime dateKey in data.keys) {
      final Workbook workbook = Workbook();

      Worksheet sheet = _setTemplateForWorkSheet(workbook);

      final doseApplications = Helper.applicationsByDose(data[dateKey]!);

      for (final VaccineDose doseKey in doseApplications.keys) {
        sheet = _setDataInWorkSheet(sheet, doseApplications[doseKey]!);

        final List<int> bytes = workbook.saveAsStream();

        workbook.dispose();

        works[dateKey] = <VaccineDose, List<int>>{doseKey: bytes};
      }
    }

    return works;
  }

  Worksheet _setTemplateForWorkSheet(Workbook workbook) {
    final Worksheet sheet = workbook.worksheets[0]
      ..name = "Aplicações"
      ..getRangeByName("A1:G1").columnWidth = 40
      ..getRangeByName("A1:G1").cellStyle.backColor = "#333F4F"
      ..getRangeByName("A1:G1").cellStyle.fontSize = 16
      ..getRangeByName("A1").setText("CPF/CNS CIDADAO")
      ..getRangeByName("B1").setText("CODIGO SEQUENCIAL LOTE")
      ..getRangeByName("C1").setText("SIGLA DOSE")
      ..getRangeByName("D1").setText("CPF/CNS VACINADOR")
      ..getRangeByName("E1").setText("DATA DE VACINACAO")
      ..getRangeByName("F1").setText("GRUPO DE ATENDIMENTO")
      ..getRangeByName("G1").setText("CONDICAO MATERNAL");

    return sheet;
  }

  Worksheet _setDataInWorkSheet(Worksheet sheet, List<Application> data) {
    for (int i = 0; i < data.length; i++) {
      sheet.getRangeByName("A${i + 2}").setText(data[i].patient.cns);
      sheet.getRangeByName("B${i + 2}").setText(data[i].vaccineBatch.number);
      sheet.getRangeByName("C${i + 2}").setText(data[i].dose.name);
      sheet.getRangeByName("D${i + 2}").setText(data[i].applier.cns);
      sheet.getRangeByName("E${i + 2}").setText("${data[i].applicationDate}");
      sheet
          .getRangeByName("F${i + 2}")
          .setText("${data[i].patient.priorityCategory.priorityGroup}");
      sheet
          .getRangeByName("G${i + 2}")
          .setText(data[i].patient.maternalCondition.name);
    }

    return sheet;
  }

  Future<File> _createFile(List<int> bytes, String fileName) async {
    final String path = (await getTemporaryDirectory()).path;
    final String fullPath = "$path/$fileName";
    final File file = File(fullPath);
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  Future<void> _shareFile(File file) async {
    await Share.shareFiles([file.path], subject: "Vacinação Covid-19");

    await file.delete();
  }

  Future<void> _openFile(File file) async {
    await OpenFile.open(file.path);
  }
}
