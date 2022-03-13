import 'package:nurse/app/models/Infra/locality_model.dart';

class EstablishmentModel {
  final int id;
  final String cnes;
  final String name;
  final LocalityModel locality;

  EstablishmentModel(
    this.id,
    this.cnes,
    this.name,
    this.locality,
  );
}
