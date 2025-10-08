import 'package:formz/formz.dart';

// Define input validation errors
enum OwnerCardError { empty, length }

// Extend FormzInput and provide the input type and error type.
class OwnerCard extends FormzInput<String, OwnerCardError> {
  // Call super.pure to represent an unmodified form input.
  const OwnerCard.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const OwnerCard.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == OwnerCardError.empty) return 'El campo es requerido';
    if (displayError == OwnerCardError.length) return 'Minimo 6 caracteres';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  OwnerCardError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return OwnerCardError.empty;
    if (value.length < 6) return OwnerCardError.length;
    return null;
  }
}
