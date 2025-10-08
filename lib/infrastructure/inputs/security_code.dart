import 'package:formz/formz.dart';

// Define input validation errors
enum SecurityCodeError { empty, invalid}

// Extend FormzInput and provide the input type and error type.
class SecurityCode extends FormzInput<String, SecurityCodeError> {
  // Call super.pure to represent an unmodified form input.
  const SecurityCode.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const SecurityCode.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SecurityCodeError.empty) return 'El campo es requerido';
    if (displayError == SecurityCodeError.invalid) return 'El codigo es invalido';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SecurityCodeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return SecurityCodeError.empty;
     if (!RegExp(r'^\d{3,4}$').hasMatch(value)) return SecurityCodeError.invalid;
    return null;
  }
}
