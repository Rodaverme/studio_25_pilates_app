import 'dart:convert';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_api.dart';

StatusPlan statusPlanFromJson(String str) => StatusPlan.fromJson(json.decode(str));

String statusPlanToJson(StatusPlan data) => json.encode(data.toJson());

class StatusPlan {
  final PlansApi plan;
  final int reservationsUsed;
  final int reservationsRemaining;
  final DateTime? startDate;
  final DateTime? expiresAt;
  final bool isExpired;
  final bool isActive;
  final int daysRemaining;

  StatusPlan({
    required this.plan,
    required this.reservationsUsed,
    required this.reservationsRemaining,
    this.startDate,
    this.expiresAt,
    required this.isExpired,
    required this.isActive,
    required this.daysRemaining,
  });

  factory StatusPlan.fromJson(Map<String, dynamic> json) => StatusPlan(
        plan: json['plan'] != null ? PlansApi.fromJson(json['plan']) : PlansApi.fromJson({}),
        reservationsUsed: json['reservations_used'] ?? 0,
        reservationsRemaining: json['reservations_remaining'] ?? 0,
        startDate: DateTime.tryParse(json['start_date']?.toString() ?? ''),
        expiresAt: DateTime.tryParse(json['expires_at']?.toString() ?? ''),
        isExpired: json['is_expired'] ?? false,
        isActive: json['is_active'] ?? false,
        daysRemaining: json['days_remaining'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "plan": plan.toJson(),
        "reservations_used": reservationsUsed,
        "reservations_remaining": reservationsRemaining,
        "start_date": startDate?.toIso8601String(),
        "expires_at": expiresAt?.toIso8601String(),
        "is_expired": isExpired,
        "is_active": isActive,
        "days_remaining": daysRemaining,
      };
}
