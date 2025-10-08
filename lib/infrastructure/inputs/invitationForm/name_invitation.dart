import 'package:formz/formz.dart';

// Define input validation errors
enum InvitationNameError { empty, length }

// Extend FormzInput and provide the input type and error type.
class NameInvitation extends FormzInput<String, InvitationNameError> {
  // Call super.pure to represent an unmodified form input.
  const  NameInvitation.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const  NameInvitation.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == InvitationNameError.empty) return 'El campo es requerido';
    if (displayError == InvitationNameError.length) return 'Minimo 6 caracteres';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  InvitationNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return InvitationNameError.empty;
    if (value.length < 6) return InvitationNameError.length;
    return null;
  }
}
