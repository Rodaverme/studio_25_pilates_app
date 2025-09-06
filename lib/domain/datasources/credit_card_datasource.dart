import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';

abstract class CreditCardDatasource {
  Future <List<CreditCard>> getMycreditCard();
  Future<void>saveCreditCard(String number, String cvc, String expMonth,String expYear,String cardHolder,String acceptToken,String acceptPersonalAuth); 
}
