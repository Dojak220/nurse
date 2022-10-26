import 'package:flutter/material.dart';
import 'package:nurse/app/components/main_button.dart';

class RegistrationButton extends StatelessWidget {
  final String text;
  final String newPage;
  final void Function() onCallback;

  const RegistrationButton({
    Key? key,
    required this.text,
    required this.newPage,
    required this.onCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButton(
      text: text,
      onPressed: () => Navigator.of(context)
          .pushNamed(newPage)
          .whenComplete(() => onCallback()),
    );
  }
}
