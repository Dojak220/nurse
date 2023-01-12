import "package:flutter/material.dart";

abstract class FormController implements ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  void clearAllInfo();

  bool submitForm(GlobalKey<FormState> formKey) {
    final bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
    }

    return isValid;
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void dispose();

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}
}
