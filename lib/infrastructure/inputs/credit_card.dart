import 'package:formz/formz.dart';

// Define input validation errors
enum CreditCardError { empty, invalid }

// Tipos de tarjeta soportados
enum CardType { visa, masterCard, amex, discover, unknown }

// Form input para validación de tarjeta de crédito
class FormCreditCard extends FormzInput<String, CreditCardError> {
  const FormCreditCard.pure() : super.pure('');
  const FormCreditCard.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == CreditCardError.empty) return 'El campo es requerido';
    if (displayError == CreditCardError.invalid)
      return 'Número de tarjeta inválido';
    return null;
  }

  @override
  CreditCardError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return CreditCardError.empty;

    final sanitized = value.replaceAll(RegExp(r'\s+|-'), '');
    if (!_isValidLuhn(sanitized)) return CreditCardError.invalid;

    return null;
  }

  // -------------------------------
  // Algoritmo de Luhn
  // -------------------------------
  bool _isValidLuhn(String input) {
    if (!RegExp(r'^\d+$').hasMatch(input)) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = input.length - 1; i >= 0; i--) {
      int digit = int.parse(input[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // -------------------------------
  // Detección del tipo de tarjeta
  // -------------------------------
  CardType get cardType {
    final sanitized = value.replaceAll(RegExp(r'\s+|-'), '');

    if (sanitized.isEmpty) return CardType.unknown;

    if (sanitized.startsWith('4')) return CardType.visa;

    if (RegExp(r'^(5[1-5])').hasMatch(sanitized) ||
        RegExp(
          r'^(222[1-9]|22[3-9]\d|2[3-6]\d{2}|27[01]\d|2720)',
        ).hasMatch(sanitized)) {
      return CardType.masterCard;
    }

    if (RegExp(r'^(34|37)').hasMatch(sanitized)) return CardType.amex;

    if (RegExp(r'^(6011|65|64[4-9]|622)').hasMatch(sanitized))
      return CardType.discover;

    return CardType.unknown;
  }

  // Texto legible para el usuario
  String get cardTypeLabel {
    switch (cardType) {
      case CardType.visa:
        return 'Visa';
      case CardType.masterCard:
        return 'MasterCard';
      case CardType.amex:
        return 'American Express';
      case CardType.discover:
        return 'Discover';
      default:
        return 'Desconocida';
    }
  }
}
