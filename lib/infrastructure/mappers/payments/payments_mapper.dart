import 'package:studio_25_pilates_app/domain/entities/payment.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/payments/credit_card_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/plans/plan_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/reservation_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/payments/payments_response.dart';

class PaymentsMapper {
  static Payment paymentApiToEntity(PaymentResponse payment) {
    return Payment(
      id: payment.id ?? 1,
      amount: payment.amount ?? '',
      description: payment.description ?? '',
      currency: payment.currency ?? '',
      method: payment.method ?? '',
      status: payment.status ?? '',
      card: payment.card != null
          ? CreditCardMapper.cardApitoEntity(payment.card!)
          : null,
      plan: payment.plan != null
          ? PlanMapper.planApitoEntity(payment.plan!)
          : null,
      reservation: payment.reservation != null
          ? ReservationMapper.toEntity(payment.reservation!)
          : null,
      type: payment.type ?? '',
      createdAt: payment.createdAt ?? DateTime.now(),
    );
  }
}
