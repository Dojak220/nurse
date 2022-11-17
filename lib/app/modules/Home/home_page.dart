import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nurse/app/components/nurse_appbar.dart';
import 'package:nurse/app/modules/Home/components/app_drawer.dart';
import 'package:nurse/app/modules/Home/components/vaccination_button.dart';
import 'package:nurse/app/modules/Home/components/vaccination_list_view.dart';
import 'package:provider/provider.dart';
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
