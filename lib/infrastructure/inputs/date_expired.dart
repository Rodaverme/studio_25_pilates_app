import 'package:formz/formz.dart';

// Define input validation errors
enum DateExpiredError { empty, invalid, expired }

// Extend FormzInput and provide the input type and error type.
class DateExpired extends FormzInput<String, DateExpiredError> {
  static final RegExp expRegExp = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');

  // Call super.pure to represent an unmodified form input.
  const DateExpired.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const DateExpired.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DateExpiredError.empty)   return 'El campo es requerido';
    if (displayError == DateExpiredError.invalid) return 'Formato inválido (MM/YY)';
    if (displayError == DateExpiredError.expired) return 'La tarjeta esta expirada';
    return null;
  }

  // Override validator to handle validating a given input value.
@override
DateExpiredError? validator(String value) {
  if (value.isEmpty || value.trim().isEmpty) {
    return DateExpiredError.empty;
  }

  // 👇 Validar formato MM/YY antes de hacer split
  if (!expRegExp.hasMatch(value)) {
    return DateExpiredError.invalid;
  }

  final parts = value.split('/');
  final int month = int.parse(parts[0]);
  final int year = int.parse('20${parts[1]}'); // ej: "24" -> 2024

  // Mes inválido aunque pase regex (ejemplo "00/24")
  if (month < 1 || month > 12) {
    return DateExpiredError.invalid;
  }

  final now = DateTime.now();
  final lastDayOfMonth = DateTime(year, month + 1, 0);

  if (lastDayOfMonth.isBefore(now)) {
    return DateExpiredError.expired;
  }

  return null;
}
}
