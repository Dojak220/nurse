import 'package:flutter/material.dart';

abstract class FormController extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  void submitForm();
}
