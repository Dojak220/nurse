import 'package:nurse/app/utils/form_controller.dart';

abstract class AddFormController extends FormController {
  Future<bool> saveInfo();
}
