import 'package:flutter/material.dart';
import 'package:nurse/app/components/second_appbar.dart';
import 'package:nurse/app/modules/EntityList/add_entities_menu_page.dart';
import 'package:nurse/app/modules/Export/export_data_page.dart';
import 'package:provider/provider.dart';

import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/modules/Home/components/vaccination_button.dart';
import 'package:nurse/app/modules/Home/home_controller.dart';
import 'package:nurse/app/modules/Home/home_page.dart';
import 'package:nurse/app/theme/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Map<String, Widget>> _widgetOptions = <Map<String, Widget>>[
    {
      "appBar": NurseAppBar(
        title: "Imunização",
        imageHeight: 60,
        titleFontSize: 36,
      ),
      "body": Home()
    },
    {
      "appBar": SecondAppBar(title: "Gerar planilha"),
      "body": ExportVaccinationDataPage()
    },
    {"appBar": SecondAppBar(title: "Menu"), "body": AddEntitiesMenuPage()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _widgetOptions.elementAt(_selectedIndex)["appBar"]
          as PreferredSizeWidget?,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)["body"],
      ),
      floatingActionButton: VaccinationButton(
        newPage: "/vaccinations/new",
        onCallback: () => context.read<HomeController>().fetchApplications(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: NurseBottomAppBar(onItemTapped: _onItemTapped),
    );
  }
}

class NurseBottomAppBar extends StatelessWidget {
  final void Function(int) onItemTapped;

  const NurseBottomAppBar({
    Key? key,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.cinzaMedio2,
            blurRadius: 15.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: BottomAppBar(
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
        ),
        color: AppColors.white,
        elevation: 10,
        notchMargin: 10,
        child: IconTheme(
          data: const IconThemeData(color: AppColors.cinzaEscuro),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                tooltip: 'Home Page',
                iconSize: 35,
                onPressed: () => onItemTapped(0),
                icon: const Icon(Icons.home_rounded),
              ),
              IconButton(
                tooltip: 'Share',
                iconSize: 35,
                onPressed: () => onItemTapped(1),
                icon: const Icon(Icons.share_rounded),
              ),
              IconButton(
                tooltip: 'Entities',
                iconSize: 35,
                onPressed: () => onItemTapped(2),
                icon: const Icon(Icons.apps_rounded),
              ),
              const SizedBox(
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
