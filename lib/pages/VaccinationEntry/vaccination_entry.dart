import 'package:flutter/material.dart';
import 'package:nurse/pages/VaccinationEntry/components/entry_details.dart';
import 'package:nurse/pages/VaccinationEntry/components/form.dart';

class VaccinationEntry extends StatefulWidget {
  const VaccinationEntry({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VaccinationEntry> createState() => _VaccinationEntryState();
}

class _VaccinationEntryState extends State<VaccinationEntry> {
  String susId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
          child: Column(
            children: [
              VaccinationEntryDetails(),
              VaccinationForm(),
            ],
          ),
        ));
  }
}
