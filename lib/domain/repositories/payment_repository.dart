import 'package:studio_25_pilates_app/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<List<Payment>> getAllPayments();
}
