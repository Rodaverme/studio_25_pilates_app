import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';

abstract class CreditCardDatasource {
  Future<CreditCard> getMycreditCard();
}
