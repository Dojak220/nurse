import 'package:flutter/material.dart';
import 'package:nurse/app/modules/VaccinationEntry/components/form.dart';

class VaccinationEntry extends StatefulWidget {
  const VaccinationEntry({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VaccinationEntry> createState() => _VaccinationEntryState();
}

class _VaccinationEntryState extends State<VaccinationEntry> {
  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom * 0.1;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, bottom),
        child: VaccinationForm(),
      ),
    );
  }
}
