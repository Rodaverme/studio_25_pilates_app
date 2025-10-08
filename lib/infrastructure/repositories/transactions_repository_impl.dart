import 'package:studio_25_pilates_app/domain/repositories/transactions_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/transactions_datasource_impl.dart';

class TransactionsRepositoryImpl extends TransactionsRepository {
  final TransactionsDatasourceImpl datasource;

  TransactionsRepositoryImpl({required this.datasource});

  @override
  Future<void> doTransaction(
    String type,
    String typeId,
    int amount,
    String currency,
    String method,
    String paymentSourceId,
  ) {
    return datasource.doTransaction(
      type,
      typeId,
      amount,
      currency,
      method,
      paymentSourceId,
    );
  }
}
