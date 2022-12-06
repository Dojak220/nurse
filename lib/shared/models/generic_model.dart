// coverage:ignore-file
abstract class GenericModel {
  final int? id;

  GenericModel(this.id);

  Map<String, dynamic> toMap();
}
