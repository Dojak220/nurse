import 'package:flutter/material.dart';

class AddEntitiesMenuPage extends StatelessWidget {
  final String title;

  const AddEntitiesMenuPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EntityButton(
                title: "Campanha",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/campaigns/new", arguments: {
                  "title": "Campanha",
                }),
              ),
              EntityButton(
                title: "Estabelecimento",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/establishments/new", arguments: {
                  "title": "Estabelecimento",
                }),
              ),
              EntityButton(
                title: "Vacina",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/vaccines/new", arguments: {
                  "title": "Vacina",
                }),
              ),
              EntityButton(
                title: "Lote de Vacina",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/vaccineBatches/new", arguments: {
                  "title": "Lote de Vacina",
                }),
              ),
              EntityButton(
                title: "Paciente",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/patients/new", arguments: {
                  "title": "Paciente",
                }),
              ),
              EntityButton(
                title: "Aplicante",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/appliers/new", arguments: {
                  "title": "Aplicante",
                }),
              ),
              EntityButton(
                title: "Localidade",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/localities/new", arguments: {
                  "title": "Localidade",
                }),
              ),
              EntityButton(
                title: "Lote",
                onPressed: () => print("Lote"),
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
