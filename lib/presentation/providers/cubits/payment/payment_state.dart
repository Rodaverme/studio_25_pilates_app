import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';

enum PaymentMethodType { credit, card, newCard }

class PaymentMethod extends Equatable {
  final PaymentMethodType type;
  final CreditCard? card; // si el método es card, aquí guardamos la tarjeta completa

  const PaymentMethod._(this.type, {this.card});

  const PaymentMethod.credit() : this._(PaymentMethodType.credit);

  const PaymentMethod.card(CreditCard card) : this._(PaymentMethodType.card, card: card);

  const PaymentMethod.newCard() : this._(PaymentMethodType.newCard);

  @override
  List<Object?> get props => [type, card];
}

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentSelected extends PaymentState {
  final PaymentMethod method;

  const PaymentSelected(this.method);

  @override
  List<Object?> get props => [method];
}
