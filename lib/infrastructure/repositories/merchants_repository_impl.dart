import 'package:studio_25_pilates_app/domain/entities/merchants.dart';
import 'package:studio_25_pilates_app/domain/repositories/merchants_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/merchants_datasource_impl.dart';

class MerchantsRepositoryImpl extends MerchantsRepository {
  final MerchantsDatasourceImpl datasource;

  MerchantsRepositoryImpl({required this.datasource});

  @override
  Future<Merchants> getTokenPermalink() {
    return datasource.getTokenPermalink();
  }
}
