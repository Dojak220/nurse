import 'package:flutter/material.dart';
import 'package:nurse/app/components/nurse_appbar.dart';

class AddEntitiesMenuPage extends StatelessWidget {
  final String title;

  const AddEntitiesMenuPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NurseAppBar(
        title: title,
        toolbarHeight: kToolbarHeight,
        imageHeight: 30,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EntityButton(
                title: "Campanha",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/campaigns", arguments: {
                  "title": "Campanha",
                }),
              ),
              EntityButton(
                title: "Estabelecimento",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/establishments", arguments: {
                  "title": "Estabelecimento",
                }),
              ),
              EntityButton(
                title: "Vacina",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/vaccines", arguments: {
                  "title": "Vacina",
                }),
              ),
              EntityButton(
                title: "Lote de Vacina",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/vaccineBatches", arguments: {
                  "title": "Lote de Vacina",
                }),
              ),
              EntityButton(
                title: "Paciente",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/patients", arguments: {
                  "title": "Paciente",
                }),
              ),
              EntityButton(
                title: "Aplicante",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/appliers", arguments: {
                  "title": "Aplicante",
                }),
              ),
              EntityButton(
                title: "Localidade",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/localities", arguments: {
                  "title": "Localidade",
                }),
              ),
              EntityButton(
                title: "Grupo Prioritário",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/priorityGroups", arguments: {
                  "title": "Grupo Prioritário",
                }),
              ),
              EntityButton(
                title: "Categoria Prioritária",
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
  final void Function() onPressed;
  const EntityButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(alignment: AlignmentDirectional.center),
      onPressed: onPressed,
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}
