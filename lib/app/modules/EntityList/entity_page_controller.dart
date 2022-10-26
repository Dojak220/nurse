import 'package:mobx/mobx.dart';

abstract class EntityPageController<T> {
  final entities = ObservableList<T>.of(
    List<T>.empty(growable: true),
  );
}
