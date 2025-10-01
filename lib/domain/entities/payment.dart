// domain/entities/payment.dart


import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/domain/entities/reservation.dart';

class Payment  {
  final int id;
  final String type;
  final String amount;
  final String currency;
  final String method;
  final String status;
  final String description;
  final DateTime createdAt;
  final Plan? plan;
  final CreditCard? card;
  final Reservation? reservation;

  const Payment({
    required this.id,
    required this.type,
   
    required this.amount,
    required this.currency,
    required this.method,
    
    required this.status,
    required this.description,
    required this.createdAt,
    this.plan,
    this.card,
    this.reservation,
  });

 
}
