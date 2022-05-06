import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/modules/Home/components/info_button.dart';
import 'package:nurse/app/modules/Home/components/main_button.dart';
import 'package:nurse/app/modules/Home/components/titled_list_view.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';
import 'package:nurse/shared/models/vaccination/application_model.dart';

class Home extends StatelessWidget {
  final String title;
  static const List<int> appliedDoses = [30, 150, 600];

  late final HomeController controller;

  Home({Key? key, required this.title}) : super(key: key) {
    controller = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.edit),
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
          Observer(builder: (_) {
            return VaccinationCountStatus(
              appliedDoses: controller.applicationCount().values.toList(),
            );
          }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                LastVaccinationsList(
                  applications: controller.applications,
                ),
                MainButton(
                  newPage: VaccinationEntry(title: title),
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

class VaccinationCountStatus extends StatelessWidget {
  const VaccinationCountStatus({
    Key? key,
    required this.appliedDoses,
  }) : super(key: key);

  final List<int> appliedDoses;

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 8.0),
            child: Text(
              "Doses aplicadas",
              style: AppTheme.titleTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              key: Key("applied_doses_row"),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoButton(
                  info: appliedDoses[0],
                  text: "Dia",
                ),
                InfoButton(
                  info: appliedDoses[1],
                  text: "Semana",
                ),
                InfoButton(
                  info: appliedDoses[2],
                  text: "Mês",
                ),
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
    // required this.entryList,
    required this.applications,
  }) : super(key: key);

  // final List<EntryCard> entryList;
  final List<Application> applications;

  @override
  Widget build(BuildContext context) {
    return TitledListView(
      "Últimos cadastros",
      // entryList: entryList,
      applications: applications,
    );
  }
}
