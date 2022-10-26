// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

class Validator {
  static const _CPF_LENGTH = 11;
  static const _CNS_LENGTH = 15;
  static const _CNES_LENGTH = 7;
  static const _IBGE_CODE_LENGTH = 7;
  static const _NAME_MAX_LENGTH = 100;
  static const _DESCRIPTION_MAX_LENGTH = 100;

  static bool _isValidCharactersRegex(String value) => RegExp(
        r"^[a-zA-Z0-9-/\sáàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ()≥]*$",
      ).hasMatch(value);

  static bool _isValidNumbersRegex(String value) =>
      RegExp(r"^[0-9]*$").hasMatch(value);

  static bool validateAll(
    List<ValidationPair<ValidatorType, Object>> evaluatees,
  ) {
    for (final evaluatee in evaluatees) {
      validate(evaluatee.type, evaluatee.value);
    }

    return true;
  }

  /// Returns true or throws a [ValidatorException] if the [value] is not valid.
  static bool validate(ValidatorType type, Object value) {
    DateTime? date = value is DateTime ? value : null;
    if ((type == ValidatorType.date ||
            type == ValidatorType.birthDate ||
            type == ValidatorType.pastDate) &&
        value is String) {
      date = DateTime.tryParse(_formatDate(value));
    }

    switch (type) {
      case ValidatorType.id:
        return _isType<int>(value)
            ? _validateId(value as int)
            : throw ValidatorException.incompatibleType(int, value);
      case ValidatorType.name:
        return _isType<String>(value)
            ? _validateName(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.optionalName:
        return _isType<String>(value)
            ? _validateOptionalName(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.description:
        return _isType<String>(value)
            ? _validateDescription(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.cpf:
        return _isType<String>(value)
            ? _validateCPF(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.cns:
        return _isType<String>(value)
            ? _validateCNS(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.cnes:
        return _isType<String>(value)
            ? _validateCNES(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.numericalString:
        return _isType<String>(value)
            ? _validateNumericalString(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      case ValidatorType.date:
        return (_isType<DateTime>(date))
            ? _validateDate(date as DateTime)
            : throw ValidatorException.incompatibleType(DateTime, value);
      case ValidatorType.birthDate:
      case ValidatorType.pastDate:
        return (_isType<DateTime>(date))
            ? _validateBirth(date as DateTime)
            : throw ValidatorException.incompatibleType(DateTime, value);
      case ValidatorType.optionalDate:
        return (_isType<DateTime?>(date))
            ? _validateOptionalDate(date)
            : throw ValidatorException.incompatibleType(DateTime, value);
      case ValidatorType.ibgeCode:
        return _isType<String>(value)
            ? _validateIBGECode(value as String)
            : throw ValidatorException.incompatibleType(String, value);
      default:
        throw ValidatorException.unimplementedType(type);
    }
  }

  static bool _isType<T>(Object? value) {
    return value is T;
  }

  static bool _validateName(String value) {
    final isEmpty = value.trim().isEmpty;
    final isTooLong = value.length > _NAME_MAX_LENGTH;
    final allCharactersValid = _isValidCharactersRegex(value);

    return !isEmpty && !isTooLong && allCharactersValid
        ? true
        : throw ValidatorException.invalid(ValidatorType.name, value);
  }

  static bool _validateOptionalName(String value) {
    final isTooLong = value.length > _NAME_MAX_LENGTH;
    final allCharactersValid = _isValidCharactersRegex(value);

    return !isTooLong && allCharactersValid
        ? true
        : throw ValidatorException.invalid(ValidatorType.name, value);
  }

  static bool _validateDescription(String value) {
    final isTooLong = value.length > _DESCRIPTION_MAX_LENGTH;
    final allCharactersValid = _isValidCharactersRegex(value);

    return !isTooLong && allCharactersValid
        ? true
        : throw ValidatorException.invalid(ValidatorType.name, value);
  }

  static bool _validateCPF(String cpf) {
    String cleanCPF = cpf.replaceAll('.', '').replaceAll('-', '').trim();

    final isExactLength = cleanCPF.length == _CPF_LENGTH;
    final isExceptionFormat = cleanCPF == "0" * 11;

    if (isExceptionFormat || !isExactLength) {
      throw ValidatorException.invalid(ValidatorType.cpf, cpf);
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
    if (resto != firstCheckDigit) {
      throw ValidatorException.invalid(ValidatorType.cpf, cpf);
    }
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
    if (resto != secondCheckDigit) {
      throw ValidatorException.invalid(ValidatorType.cpf, cpf);
    }
  }

  static bool _validateCNS(String cns) {
    String cleanCNS = cns.replaceAll('.', '').replaceAll('-', '').trim();

    final isExactLength = cleanCNS.length == _CNS_LENGTH;
    final isNumericalString = _isValidNumbersRegex(cleanCNS);
    if (!isExactLength || !isNumericalString) {
      throw ValidatorException.invalid(ValidatorType.cns, cns);
    }

    if (cleanCNS.startsWith(RegExp(r"[1-2]"))) {
      _validateCnsStartingWith1Or2(cleanCNS);
    } else if (cleanCNS.startsWith(RegExp(r"[7-9]"))) {
      _validateCnsStartingWith7To9(cleanCNS);
    } else {
      throw ValidatorException.invalid(ValidatorType.cns, cns);
    }

    return true;
  }

  static bool _validateCNES(String cnes) {
    String cleanCNES = cnes.trim();

    final isExactLength = cleanCNES.length == _CNES_LENGTH;
    final isNumericalString = _isValidNumbersRegex(cleanCNES);
    if (!isExactLength || !isNumericalString) {
      throw ValidatorException.invalid(ValidatorType.cnes, cnes);
    }

    return true;
  }

  static bool _validateNumericalString(String value) {
    final isEmpty = value.trim().isEmpty;
    final allCharactersValid = _isValidNumbersRegex(value);

    return !isEmpty && allCharactersValid
        ? true
        : throw ValidatorException.invalid(
            ValidatorType.numericalString,
            value,
          );
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
      resultado = "${pis}001$dv";
    } else {
      resultado = "${pis}000$dv";
    }

    if (cns != resultado) {
      throw ValidatorException.invalid(ValidatorType.cns, cns);
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
      throw ValidatorException.invalid(ValidatorType.cns, cns);
    }
  }

  static String _formatDate(String oldFormattedDate) {
    final date = DateFormat("dd/MM/yyyy").parse(oldFormattedDate);
    final newFormattedDate = DateFormat("yyyy-MM-dd").format(date);

    return newFormattedDate;
  }

  static bool _validateDate(DateTime date) {
    final isBefore1900 = date.year < 1900;
    final isAfter5YearsFromNow = date.isAfter(
      DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (isBefore1900 || isAfter5YearsFromNow) {
      throw ValidatorException.invalid(ValidatorType.date, date);
    }

    return true;
  }

  static bool _validateBirth(DateTime birth) {
    final isBefore1900 = birth.year < 1900;
    final isAfterNow = birth.isAfter(DateTime.now());

    if (isBefore1900 || isAfterNow) {
      throw ValidatorException.invalid(ValidatorType.birthDate, birth);
    }

    return true;
  }

  static bool _validateOptionalDate(DateTime? optionalDate) {
    if (optionalDate == null) return true;

    final isBefore1900 = optionalDate.year < 1900;
    final isAfterNow = optionalDate.isAfter(DateTime.now());

    if (isBefore1900 || isAfterNow) {
      throw ValidatorException.invalid(
          ValidatorType.optionalDate, optionalDate);
    }

    return true;
  }

  static bool _validateIBGECode(String code) {
    final isCorrectLength = code.length == _IBGE_CODE_LENGTH;
    final isOnlyNumbers = int.tryParse(code) != null;

    return isCorrectLength && isOnlyNumbers
        ? true
        : throw ValidatorException.invalid(ValidatorType.ibgeCode, code);
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
  id,
  name,
  optionalName,
  description,
  cpf,

  /// Fonte: https://integracao.esusab.ufsc.br/v211/docs/algoritmo_CNS.html
  cns,

  /// Fonte: https://integracao.esusab.ufsc.br/v20/docs/profissional.html#:~:text=HeaderCdsCadastro-,%231%20cnesUnidadeSaude,-CNES%20da%20unidade
  cnes,
  numericalString,

  optionalDate,

  /// Date must be between 1900 and 5 years from now
  date,

  /// Date must be between 1900 and now
  birthDate,

  /// Date must be between 1900 and now (equals to BirthDate)
  pastDate,

  ibgeCode,
  email
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

  @override
  String toString() {
    return message;
  }
}
