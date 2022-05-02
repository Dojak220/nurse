import 'package:flutter/material.dart';
import 'package:nurse/app/modules/Home/components/entry_card.dart';
import 'package:nurse/app/modules/Home/components/info_button.dart';
import 'package:nurse/app/modules/Home/components/main_button.dart';
import 'package:nurse/app/modules/Home/components/titled_list_view.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<int> appliedDoses = [30, 150, 600];

    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.edit),
            Text(
              widget.title,
            ),
          ],
        ),
        iconTheme: IconThemeData(color: AppColors.black),
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
      ),
      body: Column(
        children: [
          VaccinationCountStatus(appliedDoses: appliedDoses),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                LastVaccinationsList(),
                MainButton(
                  newPage: VaccinationEntry(title: widget.title),
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

class LastVaccinationsList extends StatelessWidget {
  const LastVaccinationsList({
    Key? key,
  }) : super(key: key);

  final entryList = const [
    EntryCard(
      cns: "123456789",
      name: "Um Dois Três de Oliveira Quatro",
      vaccine: "Coronavac",
      group: "50-54 anos",
      pregnant: "Nenhum",
    ),
    EntryCard(
      cns: "888777666",
      name: "Sandra de Albuquerque Matos",
      vaccine: "P-Fizer",
      group: "20-25 anos",
      pregnant: "Gestante",
    ),
    EntryCard(
      cns: "111222333",
      name: "Cleiton dos Santos de Almeida",
      vaccine: "P-Fizer",
      group: "20-25 anos",
      pregnant: "Nenhum",
    ),
    EntryCard(
      cns: "111222333",
      name: "Cleiton dos Santos de Almeida",
      vaccine: "P-Fizer",
      group: "20-25 anos",
      pregnant: "Nenhum",
    ),
    EntryCard(
      cns: "111222333",
      name: "Cleiton dos Santos de Almeida",
      vaccine: "P-Fizer",
      group: "20-25 anos",
      pregnant: "Nenhum",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return TitledListView(
      "Últimos cadastros",
      entryList: entryList,
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
