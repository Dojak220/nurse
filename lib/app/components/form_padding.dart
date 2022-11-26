import 'package:flutter/material.dart';
import 'package:nurse/app/theme/app_constraints.dart';

class FormPadding extends StatelessWidget {
  final Widget child;
  const FormPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstraints.formHorizontalPadding,
        AppConstraints.formVerticalPadding,
        AppConstraints.formHorizontalPadding,
        0,
      ),
      child: child,
    );
  }
}
