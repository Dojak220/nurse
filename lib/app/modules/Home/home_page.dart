import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/modules/Home/components/info_button.dart';
import 'package:nurse/app/modules/Home/components/main_button.dart';
import 'package:nurse/app/modules/Home/components/titled_list_view.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final String title;

  Home({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: AppDrawer(),
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
        iconTheme: IconThemeData(color: AppColors.black),
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
      ),
      body: Column(
        children: [
          VaccinationCountStatus(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                LastVaccinationsList(),
                VaccinationButton(
                  newPage: "/vaccinations/new",
                  onCallback: () =>
                      context.read<HomeController>().getApplications(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(color: AppColors.verdeEscuro),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Editar"),
            subtitle: Text("Modificar vacinas cadastradas"),
            onTap: () => print("Editar"),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Compartilhar"),
            subtitle: Text("Enviar novas vacinas para o sistema"),
            onTap: () => print("Compartilhar"),
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
      decoration: BoxDecoration(
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
              key: Key("applied_doses_row"),
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
                    text: "M??s",
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

    return TitledListView(
      "??ltimos cadastros",
      applications: applications,
    );
  }
}
