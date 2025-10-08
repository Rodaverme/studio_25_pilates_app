import 'package:studio_25_pilates_app/domain/entities/merchants.dart';

abstract class MerchantsDatasource {
Future<Merchants> getTokenPermalink();

}