// To parse this JSON data, do
//
//     final statusPlan = statusPlanFromJson(jsonString);

import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_api.dart';

StatusPlan statusPlanFromJson(String str) =>
    StatusPlan.fromJson(json.decode(str));

String statusPlanToJson(StatusPlan data) => json.encode(data.toJson());

class StatusPlan {
  PlansApi plan;
  int reservationsUsed;
  int reservationsRemaining;
  DateTime startDate;
  DateTime expiresAt;
  bool isExpired;
  bool isActive;

  StatusPlan({
    required this.plan,
    required this.reservationsUsed,
    required this.reservationsRemaining,
    required this.startDate,
    required this.expiresAt,
    required this.isExpired,
    required this.isActive,
  });

  factory StatusPlan.fromJson(Map<String, dynamic> json) => StatusPlan(
    plan: PlansApi.fromJson(json["plan"]),
    reservationsUsed: json["reservations_used"],
    reservationsRemaining: json["reservations_remaining"],
    startDate: DateTime.parse(json["start_date"]),
    expiresAt: DateTime.parse(json["expires_at"]),
    isExpired: json["is_expired"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "plan": plan.toJson(),
    "reservations_used": reservationsUsed,
    "reservations_remaining": reservationsRemaining,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "expires_at":
        "${expiresAt.year.toString().padLeft(4, '0')}-${expiresAt.month.toString().padLeft(2, '0')}-${expiresAt.day.toString().padLeft(2, '0')}",
    "is_expired": isExpired,
    "is_active": isActive,
  };
}
