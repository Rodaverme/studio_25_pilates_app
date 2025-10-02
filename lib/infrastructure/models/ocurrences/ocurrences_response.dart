// To parse this JSON data, do
//
//     final ocurrenceResponse = ocurrenceResponseFromJson(jsonString);

import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

OcurrenceResponse ocurrenceResponseFromJson(String str) =>
    OcurrenceResponse.fromJson(json.decode(str));

String ocurrenceResponseToJson(OcurrenceResponse? data) =>
    json.encode(data?.toJson());

class OcurrenceResponse {
  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  OcurrenceResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory OcurrenceResponse.fromJson(Map<String, dynamic> json) =>
      OcurrenceResponse(
        currentPage: json["current_page"],
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"] is String
            ? int.tryParse(json["per_page"])
            : json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data != null
        ? List<dynamic>.from(data!.map((x) => x.toJson()))
        : [],
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
  int? id;
  String? classSessionId;
  dynamic specialScheduleId;
  DateTime? date;
  DateTime? startTime;
  DateTime? endTime;
  int? capacity;
  String? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  bool? isInPlan;
  double? duracion;
  ClassSessionResponse? classSession;

  Datum({
    this.id,
    this.classSessionId,
    this.specialScheduleId,
    this.date,
    this.startTime,
    this.endTime,
    this.capacity,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isInPlan,
    this.classSession,
    this.duracion,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    DateTime? date;
    DateTime? startTime;
    DateTime? endTime;

    if (json["date"] != null) {
      date = DateTime.tryParse(json["date"]);
    }

    if (date != null && json["start_time"] != null) {
      final startParts = (json["start_time"] as String).split(":");
      startTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.tryParse(startParts[0]) ?? 0,
        int.tryParse(startParts[1]) ?? 0,
        int.tryParse(startParts[2]) ?? 0,
      );
    }

    if (date != null && json["end_time"] != null) {
      final endParts = (json["end_time"] as String).split(":");
      endTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.tryParse(endParts[0]) ?? 0,
        int.tryParse(endParts[1]) ?? 0,
        int.tryParse(endParts[2]) ?? 0,
      );
    }

    return Datum(
      id: json["id"],
      classSessionId: json["class_session_id"]?.toString(),
      specialScheduleId: json["special_schedule_id"],
      date: date,
      startTime: startTime,
      endTime: endTime,
      capacity: json["capacity"],
      price: json["price"]?.toString(),
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
      isInPlan: json["is_in_plan"] ?? false,
      classSession: json["class_session"] != null
          ? ClassSessionResponse.fromJson(json["class_session"])
          : null,
      duracion: json["duration_in_minutes"] != null
          ? (json["duration_in_minutes"] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "class_session_id": classSessionId,
    "special_schedule_id": specialScheduleId,
    "date": date?.toIso8601String(),
    "start_time": startTime != null
        ? "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:${startTime!.second.toString().padLeft(2, '0')}"
        : null,
    "end_time": endTime != null
        ? "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:${endTime!.second.toString().padLeft(2, '0')}"
        : null,
    "capacity": capacity,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "is_in_plan": isInPlan,
    "class_session": classSession?.toJson(),
    "duration_in_minutes": duracion,
  };
}
