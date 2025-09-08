abstract class TransactionsDatasource {
  Future<void> doTransaction(
    String type,
    String typeId,
    int amount,
    String currency,
    String method,
    String paymentSourceId,
  );
}
