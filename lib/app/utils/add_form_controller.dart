import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';

abstract class AddFormController extends FormController {
  Future<bool> saveInfo();

  @protected
  Future<bool> createEntity<T>(
      T entity, Future<int> Function(T entity) create) async {
    final allFieldsValid = submitForm(formKey);

    if (allFieldsValid) {
      try {
        final id = await create(entity);

        if (id != 0) {
          clearAllInfo();
          return true;
        } else {
          return false;
        }
      } catch (error) {
        print(error);
        return false;
      }
    }

    return false;
  }
}
