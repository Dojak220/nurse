import 'package:flutter/material.dart';
import 'package:nurse/pages/Home/_home.dart';

class Vaccination extends StatefulWidget {
  const Vaccination({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Vaccination> createState() => _VaccinationState();
}

class _VaccinationState extends State<Vaccination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Back to Home'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home(title: widget.title)),
          ),
        ),
      ),
    );
  }
}
