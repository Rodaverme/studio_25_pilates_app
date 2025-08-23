// To parse this JSON data, do
//
//     final plansResponse = plansResponseFromJson(jsonString);

import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_api.dart';

List<PlansResponse> plansResponseFromJson(String str) => List<PlansResponse>.from(json.decode(str).map((x) => PlansResponse.fromJson(x)));

String plansResponseToJson(List<PlansResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlansResponse {
    int id;
    String clientId;
    String planId;
    String cardId;
    DateTime startDate;
    bool isActive;
    DateTime createdAt;
    DateTime updatedAt;
    PlanApi plan;

    PlansResponse({
        required this.id,
        required this.clientId,
        required this.planId,
        required this.cardId,
        required this.startDate,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
        required this.plan,
    });

    factory PlansResponse.fromJson(Map<String, dynamic> json) => PlansResponse(
        id: json["id"],
        clientId: json["client_id"],
        planId: json["plan_id"],
        cardId: json["card_id"],
        startDate: DateTime.parse(json["start_date"]),
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        plan: PlanApi.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "plan_id": planId,
        "card_id": cardId,
        "start_date": startDate.toIso8601String(),
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "plan": plan.toJson(),
    };
}

