// To parse this JSON data, do
//
//     final classSessionResponse = classSessionResponseFromJson(jsonString);

import 'dart:convert';

// import 'package:studio_25_pilates_app/domain/entities/entities.dart';

List<ClassSessionByPlanResponse> classSessionResponseFromJson(String str) =>
    List<ClassSessionByPlanResponse>.from(
      json.decode(str).map((x) => ClassSessionByPlanResponse.fromJson(x)),
    );

String classSessionResponseToJson(List<ClassSessionByPlanResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassSessionByPlanResponse {
  int id;
  String title;
  String description;
  String visibility;
  String classLevelId;
  String instructorId;
  String roomId;
  String price;
  int capacity;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

ClassSessionByPlanResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.visibility,
    required this.classLevelId,
    required this.instructorId,
    required this.roomId,
    required this.price,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory ClassSessionByPlanResponse.fromJson(Map<String, dynamic> json) {
    int _asInt(dynamic v, {int fallback = 0}) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    String _asString(dynamic v, {String fallback = ''}) {
      if (v == null) return fallback;
      return v.toString();
    }

    DateTime _asDate(dynamic v, {DateTime? fallback}) {
      if (v == null) return fallback ?? DateTime.now();
      final s = v.toString();
      return DateTime.tryParse(s) ?? (fallback ?? DateTime.now());
    }

    return ClassSessionByPlanResponse(
      id: _asInt(json["id"]),
      title: _asString(json["title"], fallback: 'Clase sin título'),
      description: _asString(json["description"]),
      visibility: _asString(json["visibility"]),
      classLevelId: _asString(json["class_level_id"]),
      instructorId: _asString(json["instructor_id"]),
      roomId: _asString(json["room_id"]),
      price: _asString(json["price"], fallback: '0'),
      capacity: _asInt(json["capacity"]),
      createdAt: _asDate(json["created_at"]),
      updatedAt: _asDate(json["updated_at"]),
      deletedAt: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "visibility": visibility,
    "class_level_id": classLevelId,
    "instructor_id": instructorId,
    "room_id": roomId,
    "price": price,
    "capacity": capacity,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

// class NextOccurrence {
//     int id;
//     String classSessionId;
//     String recurringScheduleId;
//     dynamic specialScheduleId;
//     DateTime date;
//     String startTime;
//     String endTime;
//     int capacity;
//     String price;
//     bool isSpecial;
//     bool isCancelled;
//     String reservedCount;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic deletedAt;

//     NextOccurrence({
//         required this.id,
//         required this.classSessionId,
//         required this.recurringScheduleId,
//         required this.specialScheduleId,
//         required this.date,
//         required this.startTime,
//         required this.endTime,
//         required this.capacity,
//         required this.price,
//         required this.isSpecial,
//         required this.isCancelled,
//         required this.reservedCount,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.deletedAt,
//     });

//     factory NextOccurrence.fromJson(Map<String, dynamic> json) => NextOccurrence(
//         id: json["id"],
//         classSessionId: json["class_session_id"],
//         recurringScheduleId: json["recurring_schedule_id"],
//         specialScheduleId: json["special_schedule_id"],
//         date: DateTime.parse(json["date"]),
//         startTime: json["start_time"],
//         endTime: json["end_time"],
//         capacity: json["capacity"],
//         price: json["price"],
//         isSpecial: json["is_special"],
//         isCancelled: json["is_cancelled"],
//         reservedCount: json["reserved_count"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "class_session_id": classSessionId,
//         "recurring_schedule_id": recurringScheduleId,
//         "special_schedule_id": specialScheduleId,
//         "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//         "start_time": startTime,
//         "end_time": endTime,
//         "capacity": capacity,
//         "price": price,
//         "is_special": isSpecial,
//         "is_cancelled": isCancelled,
//         "reserved_count": reservedCount,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//     };
// }

// class Plan {
//     int id;
//     bool isActive;
//     String name;
//     String description;
//     String classLimit;
//     String price;
//     bool allowGuests;
//     dynamic guestLimitPerClass;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic deletedAt;
//     Pivot pivot;

//     Plan({
//         required this.id,
//         required this.isActive,
//         required this.name,
//         required this.description,
//         required this.classLimit,
//         required this.price,
//         required this.allowGuests,
//         required this.guestLimitPerClass,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.deletedAt,
//         required this.pivot,
//     });

//     factory Plan.fromJson(Map<String, dynamic> json) => Plan(
//         id: json["id"],
//         isActive: json["is_active"],
//         name: json["name"],
//         description: json["description"],
//         classLimit: json["class_limit"],
//         price: json["price"],
//         allowGuests: json["allow_guests"],
//         guestLimitPerClass: json["guest_limit_per_class"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//         pivot: Pivot.fromJson(json["pivot"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "is_active": isActive,
//         "name": name,
//         "description": description,
//         "class_limit": classLimit,
//         "price": price,
//         "allow_guests": allowGuests,
//         "guest_limit_per_class": guestLimitPerClass,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//         "pivot": pivot.toJson(),
//     };
// }

// class Pivot {
//   String classSessionId;
//   String planId;
//   DateTime createdAt;
//   DateTime updatedAt;

//   Pivot({
//     required this.classSessionId,
//     required this.planId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
//     classSessionId: json["class_session_id"],
//     planId: json["plan_id"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "class_session_id": classSessionId,
//     "plan_id": planId,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//   };
// }

// class Room {
//     int id;
//     String name;
//     String capacity;
//     dynamic location;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic deletedAt;

//     Room({
//         required this.id,
//         required this.name,
//         required this.capacity,
//         required this.location,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.deletedAt,
//     });

//     factory Room.fromJson(Map<String, dynamic> json) => Room(
//         id: json["id"],
//         name: json["name"],
//         capacity: json["capacity"],
//         location: json["location"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "capacity": capacity,
//         "location": location,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//     };
// }
