import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_colors.dart';
import 'package:nurse/app/theme/app_theme.dart';

class AddEntitiesMenuPage extends StatelessWidget {
  const AddEntitiesMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 3),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: [
              EntityButton(
                title: "Campanha",
                icon: Icons.campaign_rounded,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/campaigns", arguments: {
                  "title": "Campanha",
                }),
              ),
              EntityButton(
                title: "Estabelecimento",
                icon: Icons.local_hospital,
                onPressed: () => Navigator.of(context)
                    .pushNamed("/establishments", arguments: {
                  "title": "Estabelecimento",
                }),
              ),
              EntityButton(
                title: "Vacina",
                icon: Icons.vaccines_rounded,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/vaccines", arguments: {
                  "title": "Vacina",
                }),
              ),
              EntityButton(
                title: "Lote de Vacina",
                icon: Icons.local_pharmacy_rounded,
                onPressed: () => Navigator.of(context)
                    .pushNamed("/vaccineBatches", arguments: {
                  "title": "Lote de Vacina",
                }),
              ),
              EntityButton(
                title: "Paciente",
                icon: Icons.person,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/patients", arguments: {
                  "title": "Paciente",
                }),
              ),
              EntityButton(
                title: "Aplicante",
                icon: Icons.person,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/appliers", arguments: {
                  "title": "Aplicante",
                }),
              ),
              EntityButton(
                title: "Localidade",
                icon: Icons.location_city_rounded,
                onPressed: () =>
                    Navigator.of(context).pushNamed("/localities", arguments: {
                  "title": "Localidade",
                }),
              ),
              EntityButton(
                title: "Grupo Prioritário",
                icon: Icons.group,
                onPressed: () => Navigator.of(context)
                    .pushNamed("/priorityGroups", arguments: {
                  "title": "Grupo Prioritário",
                }),
              ),
              EntityButton(
                title: "Categoria Prioritária",
                icon: Icons.category,
                onPressed: () => Navigator.of(context)
                    .pushNamed("/priorityCategories", arguments: {
                  "title": "Categoria Prioritária",
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EntityButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onPressed;
  const EntityButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: AppColors.verdeEscuro,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: AppTheme.tileTitleStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
