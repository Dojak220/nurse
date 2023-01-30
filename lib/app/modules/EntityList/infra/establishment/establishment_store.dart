import "package:mobx/mobx.dart";
import "package:nurse/shared/models/infra/establishment_model.dart";
import "package:nurse/shared/models/infra/locality_model.dart";

part "establishment_store.g.dart";

class EstablishmentStore = _EstablishmentStoreBase with _$EstablishmentStore;

abstract class _EstablishmentStoreBase with Store {
  @observable
  Locality? selectedLocality;

  @observable
  String? cnes;

  @observable
  String? name;

  @action
  void setLocality(Locality? value) => selectedLocality = value;

  @action
  void setCnes(String value) => cnes = value;

  @action
  void setName(String value) => name = value;

  @action
  void setInfo(Establishment establishment) {
    selectedLocality = establishment.locality;

    cnes = establishment.cnes;
    name = establishment.name;
  }

  @action
  void clearAllInfo() {
    selectedLocality = null;

    cnes = null;
    name = null;
  }
}
