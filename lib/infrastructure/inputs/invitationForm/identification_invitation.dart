import 'package:formz/formz.dart';

// Define input validation errors
enum IdentificationError { empty, length }

// Extend FormzInput and provide the input type and error type.
class IdentificationInvitation extends FormzInput<String, IdentificationError> {
  // Call super.pure to represent an unmodified form input.
  const  IdentificationInvitation.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const  IdentificationInvitation.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == IdentificationError.empty) return 'El campo es requerido';
    if (displayError == IdentificationError.length) return 'Minimo 6 caracteres';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  IdentificationError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return IdentificationError.empty;
    if (value.length < 6) return IdentificationError.length;
    return null;
  }
}
