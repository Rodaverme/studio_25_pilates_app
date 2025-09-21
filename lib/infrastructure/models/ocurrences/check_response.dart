// To parse this JSON data, do
//
//     final checkResponse = checkResponseFromJson(jsonString);

import 'dart:convert';

CheckResponse checkResponseFromJson(String str) =>
    CheckResponse.fromJson(json.decode(str));

String checkResponseToJson(CheckResponse data) => json.encode(data.toJson());

class CheckResponse {
  int occurrenceId;
  String classId;
  DateTime date;
  String startTime;
  String endTime;
  int capacity;
  int reserved;
  int available;
  bool isInPlan;
  bool alreadyReserved;
  bool canReserve;
  int creditsRemaining; // <- ahora siempre es int, no nullable
  DateTime planExpiresAt; // <- aseguramos que nunca sea null

  CheckResponse({
    required this.occurrenceId,
    required this.classId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.reserved,
    required this.available,
    required this.isInPlan,
    required this.alreadyReserved,
    required this.canReserve,
    required this.creditsRemaining,
    required this.planExpiresAt,
  });

  factory CheckResponse.fromJson(Map<String, dynamic> json) => CheckResponse(
        occurrenceId: json["occurrence_id"],
        classId: json["class_id"],
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        capacity: json["capacity"],
        reserved: json["reserved"],
        available: json["available"],
        isInPlan: json["is_in_plan"],
        alreadyReserved: json["already_reserved"],
        canReserve: json["can_reserve"],
        creditsRemaining: (json["credits_remaining"] as int?) ??
            0, // Si viene null => 0
        planExpiresAt: json["plan_expires_at"] != null
            ? DateTime.parse(json["plan_expires_at"])
            : DateTime.now(), // Si viene null => DateTime.now()
      );

  Map<String, dynamic> toJson() => {
        "occurrence_id": occurrenceId,
        "class_id": classId,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "capacity": capacity,
        "reserved": reserved,
        "available": available,
        "is_in_plan": isInPlan,
        "already_reserved": alreadyReserved,
        "can_reserve": canReserve,
        "credits_remaining": creditsRemaining,
        "plan_expires_at":
            "${planExpiresAt.year.toString().padLeft(4, '0')}-${planExpiresAt.month.toString().padLeft(2, '0')}-${planExpiresAt.day.toString().padLeft(2, '0')}",
      };
}
