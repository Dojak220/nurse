abstract class GenericModel<T> {
  abstract final int id;

  Map<String, Object> toMap();
}
