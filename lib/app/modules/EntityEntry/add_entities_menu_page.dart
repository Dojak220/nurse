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
                title: "Estabelecimento",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/establishments/new", arguments: {
                  "title": "Estabelecimento",
                }),
              ),
              EntityButton(
                title: "Vacina",
                onPressed: () => print("Vacina"),
              ),
              EntityButton(
                title: "Paciente",
                onPressed: () => print("Paciente"),
              ),
              EntityButton(
                title: "Aplicante",
                onPressed: () => Navigator.of(context)
                    .pushNamed("/appliers/new", arguments: {
                  "title": "Aplicante",
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
  final Function() onPressed;
  const EntityButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(alignment: AlignmentDirectional.center),
      child: Text(title, textAlign: TextAlign.center),
      onPressed: onPressed,
    );
  }
}
