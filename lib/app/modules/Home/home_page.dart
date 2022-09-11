import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/modules/EntityEntry/add_entities_menu_page.dart';
import 'package:nurse/app/modules/Home/components/info_button.dart';
import 'package:nurse/app/modules/Home/components/main_button.dart';
import 'package:nurse/app/modules/Home/components/titled_list_view.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: AppDrawer(title: title),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/nurse-logo-2.png", height: 44),
            Text(
              title,
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
      ),
      body: Column(
        children: [
          const Expanded(flex: 1, child: VaccinationCountStatus()),
          const Expanded(flex: 4, child: LastVaccinationsList()),
          Align(
            alignment: Alignment.bottomCenter,
            child: VaccinationButton(
              newPage: "/vaccinations/new",
              onCallback: () =>
                  context.read<HomeController>().getApplications(),
            ),
          ),
        ],
      ),
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
            subtitle: const Text("Modificar vacinas cadastradas"),
            onTap: () => print("Editar"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Compartilhar"),
            subtitle: const Text("Enviar novas vacinas para o sistema"),
            onTap: () => print("Compartilhar"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Cadastrar"),
            subtitle: const Text("Vacinas, estabelecimentos e mais"),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AddEntitiesMenuPage(title: title),
              ),
            ),
          ),
        ],
      ),
    );
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
      child: TitledListView(
        "Últimos cadastros",
        applications: applications,
      ),
    );
  }
}
