import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/modules/EntityList/edit_entities_menu_page.dart';
import 'package:nurse/app/modules/Home/components/vaccination_button.dart';
import 'package:nurse/app/modules/Home/components/vaccination_list_view.dart';
import 'package:provider/provider.dart';

import 'package:nurse/app/modules/EntityEntry/add_entities_menu_page.dart';
import 'package:nurse/app/modules/Home/components/info_button.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class Home extends StatelessWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: AppDrawer(title: title),
      appBar: NurseAppBar(title: title),
      body: Column(
        children: const [
          Expanded(flex: 1, child: VaccinationCountStatus()),
          Expanded(flex: 4, child: LastVaccinationsList()),
        ],
      ),
      floatingActionButton: VaccinationButton(
        newPage: "/vaccinations/new",
        onCallback: () => context.read<HomeController>().getApplications(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

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
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Editar"),
            subtitle: const Text("Modificar vacinas, estabelecimentos e mais"),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const EditEntitiesMenuPage(title: "Editar"),
              ),
            ),
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

class VaccinationCountStatus extends StatefulWidget {
  const VaccinationCountStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<VaccinationCountStatus> createState() => _VaccinationCountStatusState();
}

class _VaccinationCountStatusState extends State<VaccinationCountStatus> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.21,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.verdeClaro, AppColors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 0.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 8.0),
            child: Text(
              "Doses aplicadas",
              style: AppTheme.titleTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              key: const Key("applied_doses_row"),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Observer(builder: (_) {
                  return InfoButton(
                    info: controller.applicationCount().values.toList()[0],
                    text: "Hoje",
                  );
                }),
                Observer(builder: (_) {
                  return InfoButton(
                    info: controller.applicationCount().values.toList()[1],
                    text: "Semana",
                  );
                }),
                Observer(builder: (_) {
                  return InfoButton(
                    info: controller.applicationCount().values.toList()[2],
                    text: "Mês",
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LastVaccinationsList extends StatelessWidget {
  const LastVaccinationsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);
    final applications = controller.applications;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: VaccinationListView(
        "Últimos cadastros",
        applications: applications,
      ),
    );
  }
}
