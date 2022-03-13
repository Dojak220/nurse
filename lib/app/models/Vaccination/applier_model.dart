import 'package:nurse/app/models/Infra/establishment_model.dart';

class ApplierModel {
  final String cns;
  final String cpf;
  final String name;
  final EstablishmentModel establishment;

  ApplierModel(
    this.cns,
    this.cpf,
    this.name,
    this.establishment,
  );
}
