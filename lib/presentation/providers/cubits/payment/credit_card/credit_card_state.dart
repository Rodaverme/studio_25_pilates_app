part of 'credit_card_cubit.dart';

enum CreditCardStatus { initial, loading, loaded, error }

class CreditCardState extends Equatable {
  final CreditCardStatus status;
  final List <CreditCard> creditCard; // lo hago nullable para manejar initial sin error
  final String? errorMessage;

  const CreditCardState({
    this.status = CreditCardStatus.initial,
    this.creditCard = const [],
    this.errorMessage,
  });

  CreditCardState copyWith({
    CreditCardStatus? status,
    List <CreditCard>? creditCard,
    String? errorMessage,
  }) {
    return CreditCardState(
      status: status ?? this.status,
      creditCard: creditCard ?? this.creditCard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, creditCard, errorMessage];
}
