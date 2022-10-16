import 'package:flutter/material.dart';

class EditEntitiesMenuPage extends StatelessWidget {
  final String title;

  const EditEntitiesMenuPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(fontSize: 32))),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EntityButton(
                title: "Campanha",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/campaigns", arguments: {
                  "title": "Campanhas",
                }),
              ),
              EntityButton(
                title: "Estabelecimento",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/establishments", arguments: {
                  "title": "Estabelecimentos",
                }),
              ),
              EntityButton(
                title: "Vacina",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/vaccines", arguments: {
                  "title": "Vacinas",
                }),
              ),
              EntityButton(
                title: "Lote de Vacina",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/vaccineBatches", arguments: {
                  "title": "Lotes de Vacina",
                }),
              ),
              EntityButton(
                title: "Paciente",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/patients", arguments: {
                  "title": "Pacientes",
                }),
              ),
              EntityButton(
                title: "Aplicante",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/appliers", arguments: {
                  "title": "Aplicantes",
                }),
              ),
              EntityButton(
                title: "Localidade",
                onPressed: () =>
                    Navigator.of(context).pushNamed("/localities", arguments: {
                  "title": "Localidades",
                }),
              ),
              EntityButton(
                title: "Grupo Prioritário",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/priorityGroups", arguments: {
                  "title": "Grupos Prioritários",
                }),
              ),
              EntityButton(
                title: "Categoria Prioritária",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/priorityCategories", arguments: {
                  "title": "Categorias Prioritárias",
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
