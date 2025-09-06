import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/domain/repositories/credit_card_repository.dart';

class CreditCardRepositoryImpl extends CreditCardRepository {
  final CreditCardRepositoryImpl datasource;

  CreditCardRepositoryImpl({required this.datasource});
  @override
  Future<List<CreditCard>> getMycreditCard() {
    return datasource.getMycreditCard();
  }

  @override
  Future<void> saveCreditCard(
    String number,
    String cvc,
    String expMonth,
    String expYear,
    String cardHolder,
    String acceptToken,
    String acceptPersonalAuth,
  ) {
    return datasource.saveCreditCard(
      number,
      cvc,
      expMonth,
      expYear,
      cardHolder,
      acceptToken,
      acceptPersonalAuth,
    );
  }
}
