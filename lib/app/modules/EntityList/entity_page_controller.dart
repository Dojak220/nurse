import 'package:mobx/mobx.dart';
part 'entity_page_controller.g.dart';

class EntityPageController<T> = _EntityPageControllerBase<T>
    with _$EntityPageController<T>;

abstract class _EntityPageControllerBase<T> with Store {
  @observable
  ObservableList<T> entities = ObservableList<T>();
}
