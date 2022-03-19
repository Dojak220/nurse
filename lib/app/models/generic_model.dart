abstract class GenericModel<T> {
  final int id;

  GenericModel({required this.id});

  Map<String, dynamic> toMap();
  String toString();
}
