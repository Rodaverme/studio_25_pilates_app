import 'package:studio_25_pilates_app/domain/entities/merchants.dart';
import 'package:studio_25_pilates_app/infrastructure/models/payments/merchants_response.dart';

class MerchantsMapper  {
  static Merchants  merchantsApiToEntity(MerchantsResponse merchants){
    return Merchants(
      presignedAcceptance:  merchants.data.presignedAcceptance.acceptanceToken, 
      permalinkPresignedAcceptance: merchants.data.presignedAcceptance.permalink,
      presignedPersonalDataAuth: merchants.data.presignedPersonalDataAuth.acceptanceToken,
      permalinkPersonalDataAuth: merchants.data.presignedPersonalDataAuth.permalink);
  }
  
}