// To parse this JSON data, do
//
//     final stastResponse = stastResponseFromJson(jsonString);

import 'dart:convert';

StastResponse stastResponseFromJson(String str) => StastResponse.fromJson(json.decode(str));

String stastResponseToJson(StastResponse data) => json.encode(data.toJson());

class StastResponse {
    Period period;
    Reservations reservations;
    Plans plans;
    Payments payments;

    StastResponse({
        required this.period,
        required this.reservations,
        required this.plans,
        required this.payments,
    });

    factory StastResponse.fromJson(Map<String, dynamic> json) => StastResponse(
        period: Period.fromJson(json["period"]),
        reservations: Reservations.fromJson(json["reservations"]),
        plans: Plans.fromJson(json["plans"]),
        payments: Payments.fromJson(json["payments"]),
    );

    Map<String, dynamic> toJson() => {
        "period": period.toJson(),
        "reservations": reservations.toJson(),
        "plans": plans.toJson(),
        "payments": payments.toJson(),
    };
}

class Payments {
    int total;
    dynamic mostUsedMethod;

    Payments({
        required this.total,
        required this.mostUsedMethod,
    });

    factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        total: json["total"],
        mostUsedMethod: json["most_used_method"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "most_used_method": mostUsedMethod,
    };
}

class Period {
    DateTime from;
    DateTime to;

    Period({
        required this.from,
        required this.to,
    });

    factory Period.fromJson(Map<String, dynamic> json) => Period(
        from: DateTime.parse(json["from"]),
        to: DateTime.parse(json["to"]),
    );

    Map<String, dynamic> toJson() => {
        "from": "${from.year.toString().padLeft(4, '0')}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}",
        "to": "${to.year.toString().padLeft(4, '0')}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}",
    };
}

class Plans {
    Active active;
    int availableReservations;
    int availableInvitations;
    int usagePercent;
    int purchaseCount;

    Plans({
        required this.active,
        required this.availableReservations,
        required this.availableInvitations,
        required this.usagePercent,
        required this.purchaseCount,
    });

    factory Plans.fromJson(Map<String, dynamic> json) => Plans(
        active: Active.fromJson(json["active"]),
        availableReservations: json["available_reservations"],
        availableInvitations: json["available_invitations"],
        usagePercent: json["usage_percent"],
        purchaseCount: json["purchase_count"],
    );

    Map<String, dynamic> toJson() => {
        "active": active.toJson(),
        "available_reservations": availableReservations,
        "available_invitations": availableInvitations,
        "usage_percent": usagePercent,
        "purchase_count": purchaseCount,
    };
}

class Active {
    int id;
    String name;
    int classLimit;
    int guestPerPeriod;
    String price;

    Active({
        required this.id,
        required this.name,
        required this.classLimit,
        required this.guestPerPeriod,
        required this.price,
    });

    factory Active.fromJson(Map<String, dynamic> json) => Active(
        id: json["id"],
        name: json["name"],
        classLimit: json["class_limit"],
        guestPerPeriod: json["guest_per_period"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "class_limit": classLimit,
        "guest_per_period": guestPerPeriod,
        "price": price,
    };
}

class Reservations {
    int total;
    int attended;
    int cancelled;
    int pending;
    int attendanceRate;
    List<dynamic> byWeekday;
    int hoursTrained;
    int longestStreakDays;
    dynamic preferredInstructor;

    Reservations({
        required this.total,
        required this.attended,
        required this.cancelled,
        required this.pending,
        required this.attendanceRate,
        required this.byWeekday,
        required this.hoursTrained,
        required this.longestStreakDays,
        required this.preferredInstructor,
    });

    factory Reservations.fromJson(Map<String, dynamic> json) => Reservations(
        total: json["total"],
        attended: json["attended"],
        cancelled: json["cancelled"],
        pending: json["pending"],
        attendanceRate: json["attendance_rate"],
        byWeekday: List<dynamic>.from(json["by_weekday"].map((x) => x)),
        hoursTrained: json["hours_trained"],
        longestStreakDays: json["longest_streak_days"],
        preferredInstructor: json["preferred_instructor"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "attended": attended,
        "cancelled": cancelled,
        "pending": pending,
        "attendance_rate": attendanceRate,
        "by_weekday": List<dynamic>.from(byWeekday.map((x) => x)),
        "hours_trained": hoursTrained,
        "longest_streak_days": longestStreakDays,
        "preferred_instructor": preferredInstructor,
    };
}
