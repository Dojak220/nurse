import "package:mobx/mobx.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";

part "priority_group_store.g.dart";

class PriorityGroupStore = _PriorityGroupStoreBase with _$PriorityGroupStore;

abstract class _PriorityGroupStoreBase with Store {
  @observable
  String? code;

  @observable
  String? name;

  @observable
  String? description;

  @action
  void setCode(String value) => code = value;

  @action
  void setName(String value) => name = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setInfo(PriorityGroup group) {
    code = group.code;
    name = group.name;
    description = group.description;
  }

  @action
  void clearAllInfo() {
    code = null;
    name = null;
    description = null;
  }
}
