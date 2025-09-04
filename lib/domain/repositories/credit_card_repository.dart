import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';

abstract class CreditCardRepository {
  Future<CreditCard> getMycreditCard();
}
