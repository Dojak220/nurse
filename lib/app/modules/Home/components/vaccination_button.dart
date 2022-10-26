import 'package:flutter/material.dart';
import 'package:nurse/app/components/main_button.dart';

class VaccinationButton extends StatelessWidget {
  final String newPage;
  final void Function() onCallback;

  const VaccinationButton({
    Key? key,
    required this.newPage,
    required this.onCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButton(
      text: "Vacinar",
      onPressed: () => Navigator.of(context)
          .pushNamed(newPage)
          .whenComplete(() => onCallback()),
    );
  }
}
