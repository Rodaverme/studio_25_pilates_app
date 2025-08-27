// To parse this JSON data, do
//
//     final plansApi = plansApiFromJson(jsonString);

import 'dart:convert';

List<PlansApi> plansApiFromJson(String str) =>
    List<PlansApi>.from(json.decode(str).map((x) => PlansApi.fromJson(x)));

String plansApiToJson(List<PlansApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlansApi {
  int id;
  bool isActive;
  String name;
  String description;
  String classLimit;
  String price;
  bool allowGuests;
  dynamic guestLimitPerClass;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  List<ClassSession>? classSessions;

  PlansApi({
    required this.id,
    required this.isActive,
    required this.name,
    required this.description,
    required this.classLimit,

    required this.price,
    required this.allowGuests,
    required this.guestLimitPerClass,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.classSessions,
  });

  factory PlansApi.fromJson(Map<String, dynamic> json) => PlansApi(
    id: json["id"],
    isActive: json["is_active"],
    name: json["name"],
    description: json["description"],
    classLimit: json["class_limit"],
    price: json["price"],
    allowGuests: json["allow_guests"],
    guestLimitPerClass: json["guest_limit_per_class"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    classSessions: json["class_sessions"] == null
        ? []
        : List<ClassSession>.from(
            json["class_sessions"].map((x) => ClassSession.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_active": isActive,
    "name": name,
    "description": description,
    "class_limit": classLimit,
    "price": price,
    "allow_guests": allowGuests,
    "guest_limit_per_class": guestLimitPerClass,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "class_sessions": List<dynamic>.from(
      classSessions ?? [].map((x) => x.toJson()),
    ),
  };
}

class ClassSession {
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
  Pivot pivot;

  ClassSession({
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
    required this.pivot,
  });

  factory ClassSession.fromJson(Map<String, dynamic> json) => ClassSession(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    visibility: json["visibility"],
    classLevelId: json["class_level_id"],
    instructorId: json["instructor_id"],
    roomId: json["room_id"],
    price: json["price"],
    capacity: json["capacity"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    pivot: Pivot.fromJson(json["pivot"]),
  );

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
    "pivot": pivot.toJson(),
  };
}

class Pivot {
  String planId;
  String classSessionId;
  DateTime createdAt;
  DateTime updatedAt;

  Pivot({
    required this.planId,
    required this.classSessionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    planId: json["plan_id"],
    classSessionId: json["class_session_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "plan_id": planId,
    "class_session_id": classSessionId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
