import 'package:nurse/app/utils/form_controller.dart';
import 'package:nurse/shared/models/patient/patient_model.dart';
import 'package:nurse/shared/models/patient/person_model.dart';
import 'package:nurse/shared/models/patient/priority_category_model.dart';
import 'package:nurse/shared/repositories/database/patient/database_priority_category_repository.dart';
import 'package:nurse/shared/repositories/patient/priority_category_repository.dart';

class PatientFormController extends FormController {
  final PriorityCategoryRepository _priorityCategoryRepository;
  final _categories = List<PriorityCategory>.empty(growable: true);
  List<PriorityCategory> get categories => _categories;

  Patient? patient;

  late String? cns;
  late String? cpf;
  late String? name;
  late PriorityCategory? selectedCategory;
  late MaternalCondition? maternalCondition;

  PatientFormController([
    PriorityCategoryRepository? priorityCategoryRepository,
  ]) : _priorityCategoryRepository =
            priorityCategoryRepository ?? DatabasePriorityCategoryRepository() {
    _getCategories();
  }

  void _getCategories() async {
    _categories
        .addAll(await _priorityCategoryRepository.getPriorityCategories());
  }

  @override
  void submitForm() async {
    formKey.currentState!.save();

    patient = Patient(
      cns: cns!,
      priorityCategory: selectedCategory!,
      maternalCondition: maternalCondition!,
      person: Person(cpf: cpf!, name: name!),
    );
  }
}
