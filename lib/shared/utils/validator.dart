class Validator {
  static const _CPF_LENGTH = 11;
  static const _CNS_LENGTH = 15;
  static const IBGE_CODE_LENGTH = 7;

  static RegExp get _validCharactersRegex => RegExp(
        r"^[a-zA-Z0-9-\sáàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]*$",
      );

  static bool validateAll(
    List<ValidationPair<ValidatorType, Object>> evaluatees,
  ) {
    evaluatees.forEach((evaluatee) {
      validate(evaluatee.type, evaluatee.value);
    });

    return true;
  }

  /// Returns [true] or throws a [ValidatorException] if the [value] is not valid.
  static bool validate(ValidatorType type, Object value) {
    switch (type) {
      case ValidatorType.Id:
        return _isType<int>(value)
            ? _validateId(value as int)
            : throw ValidatorException.incompatibleType(int, value);
      case ValidatorType.Name:
        return _isType<String>(value)
            ? _validateName(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.OptionalName:
        return _isType<String>(value)
            ? _validateOptionalName(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.CPF:
        return _isType<String>(value)
            ? _validateCPF(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.CNS:
        return _isType<String>(value)
            ? _validateCNS(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.BirthDate:
        return _isType<DateTime>(value)
            ? _validateBirth(value as DateTime)
            : throw ValidatorException.incompatibleType(DateTime, value);
      case ValidatorType.IBGECode:
        return _isType<String>(value)
            ? _validateIBGECode(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      default:
        throw ValidatorException.unimplementedType(type);
    }
  }

  static bool _isType<T>(Object value) {
    return value is T;
  }

  static bool _validateName(String value) {
    final isEmpty = value.trim().isEmpty;
    final allCharactersValid = _validCharactersRegex.hasMatch(value);

    return !isEmpty && allCharactersValid
        ? true
        : throw ValidatorException.invalid(ValidatorType.Name, value);
  }

  static bool _validateOptionalName(String value) {
    final allCharactersValid = _validCharactersRegex.hasMatch(value);

    return allCharactersValid
        ? true
        : throw ValidatorException.invalid(ValidatorType.Name, value);
  }

  static bool _validateCPF(String cpf) {
    String cleanCPF = cpf.replaceAll('.', '').replaceAll('-', '').trim();

    final isExactLength = cleanCPF.length == _CPF_LENGTH;
    final isExceptionFormat = cleanCPF == "0" * 11;

    if (isExceptionFormat || !isExactLength) {
      throw ValidatorException.invalid(ValidatorType.CPF, cpf);
    }

    _verifyFirstDigitOf(cleanCPF);
    _verifySecondDigitOf(cleanCPF);

    return true;
  }

  static void _verifyFirstDigitOf(String cpf) {
    int soma = 0;
    int resto = 0;

    for (int i = 1; i <= 9; i++) {
      final cpfDigit = int.parse(cpf.substring(i - 1, i));
      final int multiplier = (11 - i);

      soma += cpfDigit * multiplier;
    }

    resto = (soma * 10) % 11;
    if ((resto == 10) || (resto == 11)) resto = 0;

    final int firstCheckDigit = int.parse(cpf.substring(9, 10));
    if (resto != firstCheckDigit)
      throw ValidatorException.invalid(ValidatorType.CPF, cpf);
  }

  static void _verifySecondDigitOf(String cpf) {
    int soma = 0;
    int resto = 0;

    for (int i = 1; i <= 10; i++) {
      final cpfDigit = int.parse(cpf.substring(i - 1, i));
      final int multiplier = (12 - i);

      soma += cpfDigit * multiplier;
    }

    resto = (soma * 10) % 11;
    if ((resto == 10) || (resto == 11)) resto = 0;

    final int secondCheckDigit = int.parse(cpf.substring(10, 11));
    if (resto != secondCheckDigit)
      throw ValidatorException.invalid(ValidatorType.CPF, cpf);
  }

  static bool _validateCNS(String cns) {
    // Fonte: https://integracao.esusab.ufsc.br/v211/docs/algoritmo_CNS.html
    String cleanCNS = cns.replaceAll('.', '').replaceAll('-', '').trim();

    if (cleanCNS.length != _CNS_LENGTH) {
      throw ValidatorException.invalid(ValidatorType.CNS, cns);
    }

    if (cleanCNS.startsWith(RegExp(r"[1-2]"))) {
      _validateCnsStartingWith1Or2(cleanCNS);
    } else if (cleanCNS.startsWith(RegExp(r"[7-9]"))) {
      _validateCnsStartingWith7To9(cleanCNS);
    } else {
      throw ValidatorException.invalid(ValidatorType.CNS, cns);
    }

    return true;
  }

  static void _validateCnsStartingWith1Or2(String cns) {
    int soma = 0;
    int resto = 0, dv = 0;
    String pis = "";
    String resultado = "";
    pis = cns.substring(0, 11);

    for (int i = 1; i <= 11; i++) {
      final cnsDigit = int.parse(cns.substring(i - 1, i));
      final int multiplier = (16 - i);

      soma += cnsDigit * multiplier;
    }

    resto = soma % 11;
    dv = 11 - resto;

    if (dv == 11) dv = 0;

    if (dv == 10) {
      soma += 2;

      resto = soma % 11;
      dv = 11 - resto;
      resultado = pis + "001" + dv.toString();
    } else {
      resultado = pis + "000" + dv.toString();
    }

    if (cns != resultado) {
      throw ValidatorException.invalid(ValidatorType.CNS, cns);
    }
  }

  static void _validateCnsStartingWith7To9(String cns) {
    int soma = 0;
    int resto = 0;

    for (int i = 1; i <= 15; i++) {
      final cnsDigit = int.parse(cns.substring(i - 1, i));
      final int multiplier = (16 - i);

      soma += cnsDigit * multiplier;
    }

    resto = soma % 11;

    if (resto != 0) {
      throw ValidatorException.invalid(ValidatorType.CNS, cns);
    }
  }

  static bool _validateBirth(DateTime birth) {
    final isBefore1900 = birth.year < 1900;
    final isAfterNow = birth.isAfter(DateTime.now());

    if (isBefore1900 || isAfterNow) {
      throw ValidatorException.invalid(ValidatorType.BirthDate, birth);
    }

    return true;
  }

  static bool _validateIBGECode(String code) {
    final isCorrectLength = code.length == IBGE_CODE_LENGTH;
    final isOnlyNumbers = int.tryParse(code) != null;

    return isCorrectLength && isOnlyNumbers
        ? true
        : throw ValidatorException.invalid(ValidatorType.IBGECode, code);
  }

  static bool _validateId(int id) {
    if (id <= 0) {
      throw Exception('Id must be greater than 0');
    }

    return true;
  }
}

class ValidationPair<ValidatorType, Object> {
  final ValidatorType type;
  final Object value;

  ValidationPair(this.type, this.value);
}

enum ValidatorType {
  Id,
  Name,
  OptionalName,
  Description,
  CPF,
  CNS,
  BirthDate,
  IBGECode,
  Email
}

class ValidatorException implements Exception {
  final String message;

  ValidatorException.incompatibleType(Type type, Object value)
      : message = '''
It was expected that the value '$value' would be of type '$type',
but it was of type '${value.runtimeType}'.
''';

  ValidatorException.unimplementedType(ValidatorType type)
      : message = "Unimplemented type: '$type'";

  ValidatorException.invalid(ValidatorType type, Object value)
      : message = "Invalid ${type.name}: '$value'.";
}
