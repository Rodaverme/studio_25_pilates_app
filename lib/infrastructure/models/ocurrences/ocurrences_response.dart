// To parse this JSON data, do
//
//     final ocurrenceResponse = ocurrenceResponseFromJson(jsonString);

import 'dart:convert';


import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

OcurrenceResponse ocurrenceResponseFromJson(String str) =>
    OcurrenceResponse.fromJson(json.decode(str));

String ocurrenceResponseToJson(OcurrenceResponse data) =>
    json.encode(data.toJson());

class OcurrenceResponse {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  OcurrenceResponse({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory OcurrenceResponse.fromJson(Map<String, dynamic> json) =>
      OcurrenceResponse(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],

        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,

    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  int id;
  String classSessionId;
  String recurringScheduleId;
  dynamic specialScheduleId;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  int capacity;
  String price;
  bool isSpecial;
  bool isCancelled;
  String reservedCount;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  bool? isInPlan;
  ClassSessionResponse classSession;

  Datum({
    required this.id,
    required this.classSessionId,
    required this.recurringScheduleId,
    required this.specialScheduleId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.price,
    required this.isSpecial,
    required this.isCancelled,
    required this.reservedCount,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.isInPlan,
    required this.classSession,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json["date"]);

    // Hora de inicio
    final startParts = (json["start_time"] as String).split(":");
    final startTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
      int.parse(startParts[2]),
    );

    // Hora de fin
    final endParts = (json["end_time"] as String).split(":");
    final endTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
      int.parse(endParts[2]),
    );

    return Datum(
      id: json["id"],
      classSessionId: json["class_session_id"],
      recurringScheduleId: json["recurring_schedule_id"],
      specialScheduleId: json["special_schedule_id"],
      date: date,
      startTime: startTime,
      endTime: endTime,
      capacity: json["capacity"],
      price: json["price"],
      isSpecial: json["is_special"],
      isCancelled: json["is_cancelled"],
      reservedCount: json["reserved_count"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"],
      isInPlan:  json["is_in_plan"] ?? false ,
      classSession: ClassSessionResponse.fromJson(json["class_session"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "class_session_id": classSessionId,
    "recurring_schedule_id": recurringScheduleId,
    "special_schedule_id": specialScheduleId,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time":
        "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:${startTime.second.toString().padLeft(2, '0')}",
    "end_time":
        "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:${endTime.second.toString().padLeft(2, '0')}",
    "capacity": capacity,
    "price": price,
    "is_special": isSpecial,
    "is_cancelled": isCancelled,
    "reserved_count": reservedCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "is_in_plan": isInPlan,
    "class_session": classSession.toJson(),
  };
}
