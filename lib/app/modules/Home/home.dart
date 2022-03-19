import 'package:flutter/material.dart';
import 'package:nurse/app/modules/Home/components/entry_card.dart';
import 'package:nurse/app/modules/Home/components/info_button.dart';
import 'package:nurse/app/modules/Home/components/main_button.dart';
import 'package:nurse/app/modules/Home/components/titled_list_view.dart';
import 'package:nurse/app/modules/VaccinationEntry/vaccination_entry.dart';
import 'package:nurse/app/theme/colors.dart';

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
    const String appliedDosesTitle = "Doses aplicadas";
    const String lastEntriesTitle = "Últimos cadastros";

    final ListView appliedDosesListView = ListView(
      shrinkWrap: true,
      children: [
        InfoButton(
          info: appliedDoses[0],
          text: "doses hoje",
        ),
        InfoButton(
          info: appliedDoses[1],
          text: "doses esta semana",
        ),
        InfoButton(
          info: appliedDoses[2],
          text: "doses este mês",
        ),
      ],
    );

    final ListView lastEntriesListView = ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      children: [
        EntryCard(
          cns: "123456789",
          name: "Um Dois Três de Oliveira Quatro",
          vaccine: "Coronavac",
          group: "50-54 anos",
          pregnant: "Comum",
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
          pregnant: "Comum",
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
        child: Column(
          children: [
            TitledListView(
              title: appliedDosesTitle,
              listView: appliedDosesListView,
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
            ),
            TitledListView(
              title: lastEntriesTitle,
              listView: lastEntriesListView,
              color: CustomColors.cinza,
            ),
            MainButton(
              newPage: VaccinationEntry(title: widget.title),
            ),
          ],
        ),
      ),
    );
  }
}
