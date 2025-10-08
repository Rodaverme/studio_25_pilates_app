// To parse this JSON data, do
//
//     final statusPlan = statusPlanFromJson(jsonString);

import 'dart:convert';

StatusPlan statusPlanFromJson(String str) => StatusPlan.fromJson(json.decode(str));

String statusPlanToJson(StatusPlan data) => json.encode(data.toJson());

class StatusPlan {
    PlanApi plan;
    bool isActive;
    int daysRemaining;
    DateTime startDate;
    DateTime endDate;
    DateTime expiresAt;
    bool isExpired;
    String reservations;
    String reservationsUsed;
    int reservationsRemaining;
    String invitations;
    String invitationsUsed;
    int invitationsRemaining;

    StatusPlan({
        required this.plan,
        required this.isActive,
        required this.daysRemaining,
        required this.startDate,
        required this.endDate,
        required this.expiresAt,
        required this.isExpired,
        required this.reservations,
        required this.reservationsUsed,
        required this.reservationsRemaining,
        required this.invitations,
        required this.invitationsUsed,
        required this.invitationsRemaining,
    });

    factory StatusPlan.fromJson(Map<String, dynamic> json) => StatusPlan(
        plan: PlanApi.fromJson(json["plan"]),
        isActive: json["is_active"],
        daysRemaining: json["days_remaining"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        expiresAt: DateTime.parse(json["expires_at"]),
        isExpired: json["is_expired"],
        reservations: json["reservations"],
        reservationsUsed: json["reservations_used"],
        reservationsRemaining: json["reservations_remaining"],
        invitations: json["invitations"],
        invitationsUsed: json["invitations_used"],
        invitationsRemaining: json["invitations_remaining"],
    );

    Map<String, dynamic> toJson() => {
        "plan": plan.toJson(),
        "is_active": isActive,
        "days_remaining": daysRemaining,
        "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "expires_at": "${expiresAt.year.toString().padLeft(4, '0')}-${expiresAt.month.toString().padLeft(2, '0')}-${expiresAt.day.toString().padLeft(2, '0')}",
        "is_expired": isExpired,
        "reservations": reservations,
        "reservations_used": reservationsUsed,
        "reservations_remaining": reservationsRemaining,
        "invitations": invitations,
        "invitations_used": invitationsUsed,
        "invitations_remaining": invitationsRemaining,
    };
}

class PlanApi {
    int id;
    String name;
    int classLimit;
    bool allowGuests;
    int guestPerPeriod;
    String price;
    bool isActive;

    PlanApi({
        required this.id,
        required this.name,
        required this.classLimit,
        required this.allowGuests,
        required this.guestPerPeriod,
        required this.price,
        required this.isActive,
    });

    factory PlanApi.fromJson(Map<String, dynamic> json) => PlanApi(
        id: json["id"],
        name: json["name"],
        classLimit: json["class_limit"],
        allowGuests: json["allow_guests"],
        guestPerPeriod: json["guest_per_period"],
        price: json["price"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "class_limit": classLimit,
        "allow_guests": allowGuests,
        "guest_per_period": guestPerPeriod,
        "price": price,
        "is_active": isActive,
    };
}
