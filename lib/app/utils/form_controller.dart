import 'package:flutter/material.dart';

abstract class FormController extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  void clearAllInfo();

  bool submitForm(GlobalKey<FormState> formKey) {
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
    }

    return isValid;
  }
}
