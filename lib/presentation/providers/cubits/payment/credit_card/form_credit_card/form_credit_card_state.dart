part of 'form_credit_card_cubit.dart';



enum FormStauts { invalid, valid, validating, posting }

class FormsCreditCardState extends Equatable {
  final bool isValid;
  final FormStauts formStauts;
  final FormCreditCard formCreditCard;
  final DateExpired dateExpired;
  final SecurityCode securityCode;
  final OwnerCard ownerCard;

  const FormsCreditCardState({
    this.formStauts = FormStauts.invalid,
    this.formCreditCard = const FormCreditCard.pure(),
    this.dateExpired = const DateExpired.pure(),
    this.securityCode = const SecurityCode.pure(),
    this.ownerCard = const OwnerCard.pure(),
    this.isValid = false,
  });

  FormsCreditCardState copyWith({
    FormStauts? formStauts,
    bool? isValid,
    FormCreditCard? formCreditCard,
    DateExpired? dateExpired,
    SecurityCode? securityCode,
    OwnerCard? ownerCard,
  }) => FormsCreditCardState(
    isValid: isValid ?? this.isValid,
    formStauts: formStauts ?? this.formStauts,
    formCreditCard: formCreditCard ?? this.formCreditCard,
    dateExpired: dateExpired ?? this.dateExpired,
    securityCode: securityCode ?? this.securityCode,
    ownerCard: ownerCard ?? this.ownerCard,
  );

  @override
  List<Object?> get props => [
    formStauts,
    formCreditCard,
    dateExpired,
    securityCode,
    isValid,
    ownerCard,
  ];
}
