abstract class GenericModel<T> {
  final int? id;

  GenericModel(this.id);

  Map<String, Object> toMap();
}
