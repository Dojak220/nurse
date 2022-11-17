import 'package:flutter/material.dart';
import 'package:nurse/app/modules/EntityList/add_entities_menu_page.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final String title;

  const AppDrawer({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.verdeEscuro),
            child: Text('Menu'),
          ),
          const SizedBox(height: 20),
          ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Compartilhar"),
              subtitle: const Text("Enviar novas vacinas para o sistema"),
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ExportVaccinationDataPage(),
                    ),
                  )),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Cadastrar"),
            subtitle: const Text("Vacinas, estabelecimentos e mais"),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AddEntitiesMenuPage(title: "Cadastrar"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExportVaccinationDataPage extends StatelessWidget {
  const ExportVaccinationDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/nurse-logo-2.png", height: 44),
            const Text("Gerar planilha"),
          ],
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDateRange(context),
            child: const Text("Escolher data"),
          ),
        ],
      ),
    );
  }

  Future<DateTimeRange?> _selectDateRange(BuildContext context) {
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) async {
      if (value != null) {
        await showAlertDialog(context, value);
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
