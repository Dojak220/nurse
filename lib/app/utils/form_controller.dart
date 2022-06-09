import 'package:flutter/material.dart';

abstract class FormController {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  void submitForm();
}
