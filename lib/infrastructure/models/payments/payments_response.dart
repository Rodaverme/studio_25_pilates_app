import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/payments/credit_card_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_reponse.dart';
import 'package:studio_25_pilates_app/infrastructure/models/reservation/reservation_response.dart';

List<PaymentResponse> paymentResponseFromJson(String str) =>
    List<PaymentResponse>.from(
      json.decode(str).map((x) => PaymentResponse.fromJson(x)),
    );

String paymentResponseToJson(List<PaymentResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentResponse {
  int? id;
  String? type;
  String? typeId;
  String? amount;
  String? currency;
  String? method;
  String? methodId;
  String? status;
  String? description;
  DateTime? createdAt;
  PlanResponse? plan;
  CreditCardResponse? card;
  ReservationResponse? reservation;

  PaymentResponse({
    this.id,
    this.type,
    this.typeId,
    this.amount,
    this.currency,
    this.method,
    this.methodId,
    this.status,
    this.description,
    this.createdAt,
    this.plan,
    this.card,
    this.reservation,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
        id: json["id"],
        type: json["type"],
        typeId: json["type_id"],
        amount: json["amount"],
        currency: json["currency"],
        method: json["method"],
        methodId: json["method_id"],
        status: json["status"],
        description: json["description"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        plan: json["plan"] != null ? PlanResponse.fromJson(json["plan"]) : null,
        card: json["card"] != null
            ? CreditCardResponse.fromJson(json["card"])
            : null,
        reservation: json["reservation"] != null
            ? ReservationResponse.fromJson(json["reservation"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "type_id": typeId,
        "amount": amount,
        "currency": currency,
        "method": method,
        "method_id": methodId,
        "status": status,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "plan": plan?.toJson(),
        "card": card?.toJson(),
        "reservation": reservation?.toJson(),
      };
}
