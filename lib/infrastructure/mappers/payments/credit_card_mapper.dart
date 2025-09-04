import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';

import 'package:studio_25_pilates_app/infrastructure/models/payments/credit_card_response.dart';

class CreditCardMapper {
  static CreditCard cardApitoEntity(CreditCardResponse card) => CreditCard(
    id: card.id,
    brand: card.brand,
    clientId: card.clientId,
    expMonth: card.expMonth,
    expYear: card.expYear,
    lastFour: card.lastFour,
    token: card.token,
  );
}
