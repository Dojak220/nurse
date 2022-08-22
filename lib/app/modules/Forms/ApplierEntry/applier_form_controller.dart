import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/vaccination/database_applier_repository.dart';
import 'package:nurse/shared/repositories/vaccination/applier_repository.dart';

class ApplierFormController extends FormController {
  Applier? selectedApplier;
  Establishment? selectedEstablishment;
  Applier? get applier => selectedApplier;

  final ApplierRepository _applierRepository;

  final _appliers = List<Applier>.empty(growable: true);
  List<Applier> get appliers => getAppliersFromSelectedEstablishment();
  List<Establishment> get establishments => getEstablishmentsFromAllAppliers();

  ApplierFormController([
    ApplierRepository? applierRepository,
  ]) : _applierRepository = applierRepository ?? DatabaseApplierRepository() {
    _getAppliers();
    notifyListeners();
  }

  void _getAppliers() async {
    _appliers.addAll(await _applierRepository.getAppliers());
  }

  List<Applier> getAppliersFromSelectedEstablishment() {
    if (selectedEstablishment == null) return _appliers;
    return _appliers.where((applier) {
      return applier.establishment.id == selectedEstablishment!.id;
    }).toList();
  }

  List<Establishment> getEstablishmentsFromAllAppliers() {
    return List.of(
      _appliers.map((applier) => applier.establishment).toSet(),
    );
  }

  void clearAllInfo() {
    selectedApplier = null;
    selectedEstablishment = null;

    notifyListeners();
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();
  }
}
