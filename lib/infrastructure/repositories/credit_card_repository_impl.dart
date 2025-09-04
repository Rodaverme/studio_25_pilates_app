import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/domain/repositories/credit_card_repository.dart';

class CreditCardRepositoryImpl extends CreditCardRepository {
  final CreditCardRepositoryImpl datasource;

  CreditCardRepositoryImpl({required this.datasource});
  @override
  Future<CreditCard> getMycreditCard() {
    return datasource.getMycreditCard();
  }
}
