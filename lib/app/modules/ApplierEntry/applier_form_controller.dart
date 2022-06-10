import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/infra/establishment_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/vaccination/applier_model.dart';
import 'package:nurse/shared/repositories/database/infra/database_establishment_repository.dart';
import 'package:nurse/shared/repositories/infra/establishment_repository.dart';

class ApplierFormController extends FormController {
  final EstablishmentRepository _establishmentRepository;
  final _establishments = List<Establishment>.empty(growable: true);
  List<Establishment> get establishments => _establishments;

  Applier? applier;

  late String? cns;
  late String? cpf;
  late String? name;
  late Establishment? selectedEstablishment;

  ApplierFormController([
    EstablishmentRepository? establishmentRepository,
  ]) : _establishmentRepository =
            establishmentRepository ?? DatabaseEstablishmentRepository() {
    _getEstablishments();
  }

  void _getEstablishments() async {
    _establishments.addAll(await _establishmentRepository.getEstablishments());
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();

    applier = Applier(
      cns: cns!,
      establishment: selectedEstablishment!,
      person: Person(cpf: cpf!, name: name!),
    );
  }
}
