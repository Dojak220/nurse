enum FormLabels {
  applicationDate,
  applierCns,
  applierCpf,
  applierName,
  birthDate,
  campaignName,
  campaignDescription,
  campaignStartDate,
  campaignEndDate,
  category,
  dose,
  establishmentCNES,
  establishmentLocalityName,
  establishmentName,
  fatherName,
  localityName,
  localityCity,
  localityState,
  localityCode,
  motherName,
  group,
  maternalCondition,
  patientCns,
  patientCpf,
  patientName,
  sex,
  vaccineBatch,
  vaccineLaboratory,
  vaccine,
  vaccineSipniCode,
}

extension LabelNamesAndHints on FormLabels {
  String get description {
    switch (this) {
      case FormLabels.applicationDate:
        return "Data de Aplicação *";
      case FormLabels.applierCns:
        return "CNS do(a) Aplicante *";
      case FormLabels.applierCpf:
        return "CPF do(a) Aplicante *";
      case FormLabels.applierName:
        return "Nome Completo do(a) Aplicante *";
      case FormLabels.birthDate:
        return "Data de Nascimento";
      case FormLabels.campaignName:
        return "Campanha *";
      case FormLabels.campaignDescription:
        return "Descrição da Campanha";
      case FormLabels.campaignStartDate:
        return "Data de Início *";
      case FormLabels.campaignEndDate:
        return "Data de Término";
      case FormLabels.category:
        return "Categoria Prioritária *";
      case FormLabels.dose:
        return "Dose *";
      case FormLabels.establishmentCNES:
        return "CNES do Estabelecimento *";
      case FormLabels.establishmentLocalityName:
        return "Localidade do Estabelecimento *";
      case FormLabels.establishmentName:
        return "Nome do Estabelecimento *";
      case FormLabels.fatherName:
        return "Nome do Pai *";
      case FormLabels.localityName:
        return "Nome da Localidade *";
      case FormLabels.localityCity:
        return "Cidade da Localidade *";
      case FormLabels.localityState:
        return "Estado da Localidade *";
      case FormLabels.localityCode:
        return "Código da Localidade *";
      case FormLabels.motherName:
        return "Nome da Mãe *";
      case FormLabels.group:
        return "Grupo Prioritário *";
      case FormLabels.maternalCondition:
        return "Condição Maternal *";
      case FormLabels.patientCns:
        return "CNS do(a) Paciente *";
      case FormLabels.patientCpf:
        return "CPF do(a) Paciente *";
      case FormLabels.patientName:
        return "Nome Completo do(a) Paciente *";
      case FormLabels.sex:
        return "Sexo do(a) Paciente";
      case FormLabels.vaccineBatch:
        return "Lote da Vacina*";
      case FormLabels.vaccineLaboratory:
        return "Laboratório *";
      case FormLabels.vaccine:
        return "Nome da Vacina *";
      case FormLabels.vaccineSipniCode:
        return "Código SIPNI *";
      default:
        return "";
    }
  }

  String get hint {
    switch (this) {
      case FormLabels.applicationDate:
        return "Data da aplicação da vacina";
      case FormLabels.applierCns:
        return "Número do Cartão Nacional de Saúde do(a) aplicador(a)";
      case FormLabels.applierCpf:
        return "Número do Cadastro de Pessoas Físicas do(a) aplicador(a)";
      case FormLabels.applierName:
        return "Nome completo do(a) aplicante";
      case FormLabels.birthDate:
        return "Data de Nascimento";
      case FormLabels.campaignName:
        return "Campanha de vacinação";
      case FormLabels.campaignDescription:
        return "Descrição da campanha de vacinação";
      case FormLabels.campaignStartDate:
        return "Data de início da campanha de vacinação";
      case FormLabels.campaignEndDate:
        return "Data de término da campanha de vacinação";
      case FormLabels.category:
        return "Categoria do(a) paciente";
      case FormLabels.dose:
        return "Dose da vacina";
      case FormLabels.establishmentCNES:
        return "CNES do estabelecimento";
      case FormLabels.establishmentName:
        return "Nome do estabelecimento";
      case FormLabels.fatherName:
        return "Nome do pai";
      case FormLabels.localityName:
        return "Nome da localidade";
      case FormLabels.localityCity:
        return "Cidade da localidade";
      case FormLabels.localityState:
        return "Estado da localidade";
      case FormLabels.localityCode:
        return "Código ibge da cidade da localidade";
      case FormLabels.motherName:
        return "Nome da mãe";
      case FormLabels.group:
        return "Grupo do(a) paciente";
      case FormLabels.maternalCondition:
        return "Condição Maternal do(a) paciente";
      case FormLabels.patientCns:
        return "Número do Cartão Nacional de Saúde do(a) paciente";
      case FormLabels.patientCpf:
        return "Número do Cadastro de Pessoas Físicas do(a) paciente";
      case FormLabels.patientName:
        return "Nome completo do(a) paciente";
      case FormLabels.sex:
        return "Sexo do(a) paciente";
      case FormLabels.vaccineBatch:
        return "Número do lote da vacina";
      case FormLabels.vaccineLaboratory:
        return "Laboratório da vacina";
      case FormLabels.vaccine:
        return "Nome da vacina";
      case FormLabels.vaccineSipniCode:
        return "Código SIPNI da vacina";
      default:
        return "";
    }
  }
}
