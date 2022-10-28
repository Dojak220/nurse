import 'package:flutter/material.dart';
import 'package:nurse/app/utils/form_controller.dart';

abstract class AddFormController extends FormController {
  Future<bool> saveInfo();
  Future<bool> updateInfo();

  @protected
  Future<bool> createEntity<T>(
      T entity, Future<int> Function(T entity) create) async {
    return await _handleEntity(entity, create);
  }

  @protected
  Future<bool> updateEntity<T>(
      T entity, Future<int> Function(T entity) update) async {
    return await _handleEntity(entity, update);
  }

  Future<bool> _handleEntity<T>(
      T entity, Future<int> Function(T entity) handler) async {
    final allFieldsValid = submitForm(formKey);

    if (allFieldsValid) {
      try {
        final result = await handler(entity);

        if (result != 0) {
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
