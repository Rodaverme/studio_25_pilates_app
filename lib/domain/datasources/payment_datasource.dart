import 'package:studio_25_pilates_app/domain/entities/payment.dart';

abstract class PaymentDatasource {
  Future  <List<Payment>> getAllPayments();
}
