import 'package:flutter_test/flutter_test.dart';
import 'package:nurse/shared/utils/validator.dart';

void main() {
  group("incompatible type for [ValidatorType.id]", () {
    _testValidator<int>(ValidatorType.id);
  });

  group("incompatible type for [ValidatorType.name]", () {
    _testValidator<String>(ValidatorType.name);
  });

  group("incompatible type for [ValidatorType.cpf]", () {
    _testValidator<String>(ValidatorType.cpf);
  });

  group("incompatible type for [ValidatorType.cns]", () {
    _testValidator<String>(ValidatorType.cns);
  });

  group("incompatible type for [ValidatorType.birthDate]", () {
    _testValidator<DateTime>(ValidatorType.birthDate);
  });

  group("unimplemented type validator", () {
    test("should throw an [ValidatorException] if type has no validation.", () {
      expect(
        () => Validator.validate(ValidatorType.email, "example@example.com"),
        throwsA(
          allOf(
            isA<ValidatorException>(),
            predicate((ValidatorException e) {
              return e.message == "Unimplemented type: '$ValidatorType.email'";
            }),
          ),
        ),
      );
    });
  });
}

void _testValidator<T>(ValidatorType type) {
  switch (T) {
    case String:
      _testValidatorOfTypeString(type);
      break;
    case int:
      _testValidatorOfTypeInt(type);
      break;
    case DateTime:
      _testValidatorOfTypeDateTime(type);
      break;
    default:
  }
}

void _testValidatorOfTypeInt(ValidatorType type) {
  Object value;

  test("should throw an [ValidatorException] if [value] isnt [int].", () {
    value = "not int";
    expect(
      () => Validator.validate(type, value),
      throwsA(
        allOf(
          isA<ValidatorException>(),
          predicate((ValidatorException e) {
            return e.message == createExpectedMessage(int, value);
          }),
        ),
      ),
    );

    value = true;
    expect(
      () => Validator.validate(type, value),
      throwsA(
        allOf(
          isA<ValidatorException>(),
          predicate((ValidatorException e) {
            return e.message == createExpectedMessage(int, value);
          }),
        ),
      ),
    );
  });
}

void _testValidatorOfTypeString(ValidatorType type) {
  Object value;

  test("should throw an [ValidatorException] if [value] isnt [String].", () {
    value = true;
    expect(
      () => Validator.validate(type, value),
      throwsA(
        allOf(
          isA<ValidatorException>(),
          predicate((ValidatorException e) {
            return e.message == createExpectedMessage(String, value);
          }),
        ),
      ),
    );

    value = 1;
    expect(
      () => Validator.validate(type, value),
      throwsA(
        allOf(
          isA<ValidatorException>(),
          predicate((ValidatorException e) {
            return e.message == createExpectedMessage(String, value);
          }),
        ),
      ),
    );
  });
}

void _testValidatorOfTypeDateTime(ValidatorType type) {
  Object value;

  test("should throw an [ValidatorException] if [value] isnt [DateTime].", () {
    value = true;
    expect(
      () => Validator.validate(type, value),
      throwsA(
        allOf(
          isA<ValidatorException>(),
          predicate((ValidatorException e) {
            return e.message == createExpectedMessage(DateTime, value);
          }),
        ),
      ),
    );

    value = 1;
    expect(
      () => Validator.validate(type, value),
      throwsA(
        allOf(
          isA<ValidatorException>(),
          predicate((ValidatorException e) {
            return e.message == createExpectedMessage(DateTime, value);
          }),
        ),
      ),
    );
  });
}

String createExpectedMessage(Type expected, Object acualValue) {
  return """
It was expected that the value '$acualValue' would be of type '$expected',
but it was of type '${acualValue.runtimeType}'.
""";
}
