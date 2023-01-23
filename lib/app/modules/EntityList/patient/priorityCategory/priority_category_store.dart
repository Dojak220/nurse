import "package:mobx/mobx.dart";
import "package:nurse/shared/models/patient/priority_category_model.dart";
import "package:nurse/shared/models/patient/priority_group_model.dart";

part "priority_category_store.g.dart";

class PriorityCategoryStore = _PriorityCategoryStoreBase
    with _$PriorityCategoryStore;

abstract class _PriorityCategoryStoreBase with Store {
  @observable
  PriorityGroup? selectedPriorityGroup;

  @observable
  String? code;

  @observable
  String? name;

  @observable
  String? description;

  @action
  void setPriorityGroup(PriorityGroup? value) => selectedPriorityGroup = value;

  @action
  void setCode(String value) => code = value;

  @action
  void setName(String value) => name = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setInfo(PriorityCategory category) {
    selectedPriorityGroup = category.priorityGroup;

    code = category.code;
    name = category.name;
    description = category.description;
  }

  @action
  void clearAllInfo() {
    selectedPriorityGroup = null;

    code = null;
    name = null;
    description = null;
  }
}
