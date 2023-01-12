import "package:flutter/material.dart";
import "package:nurse/app/components/nurse_appbar.dart";
import "package:nurse/app/components/second_appbar.dart";
import "package:nurse/app/components/toolbar_icon.dart";
import "package:nurse/app/modules/EntityList/add_entities_menu_page.dart";
import "package:nurse/app/modules/Export/export_data_page.dart";
import "package:nurse/app/modules/Home/components/vaccination_button.dart";
import "package:nurse/app/modules/Home/home_controller.dart";
import "package:nurse/app/modules/Home/home_page.dart";
import "package:nurse/app/theme/app_colors.dart";
import "package:provider/provider.dart";

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
      bottomNavigationBar: NurseBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class NurseBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const NurseBottomAppBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: AppColors.cinzaMedio2, blurRadius: 15.0)],
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
            children: [
              ToolbarIcon(
                0,
                icon: Icons.home_rounded,
                label: "Home Page",
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              ),
              ToolbarIcon(
                1,
                icon: Icons.share_rounded,
                label: "Share",
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              ),
              ToolbarIcon(
                2,
                icon: Icons.apps_rounded,
                label: "Entities",
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              ),
              const SizedBox(width: 50, height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
