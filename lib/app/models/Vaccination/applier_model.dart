import 'package:nurse/app/models/infra/establishment_model.dart';

class ApplierModel {
  final String cns;
  final String cpf;
  final String name;
  final Establishment establishment;

  ApplierModel(
    this.cns,
    this.cpf,
    this.name,
    this.establishment,
  );
}
