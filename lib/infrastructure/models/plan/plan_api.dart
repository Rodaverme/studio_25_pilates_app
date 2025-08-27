import 'dart:convert';

List<PlansApi> plansApiFromJson(String str) =>
    List<PlansApi>.from(json.decode(str).map((x) => PlansApi.fromJson(x)));

String plansApiToJson(List<PlansApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlansApi {
  final int id;
  final bool isActive;
  final String name;
  final String description;
  final int? classLimit;
  final int? price;
  final bool allowGuests;
  final dynamic guestLimitPerClass;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<ClassSession>? classSessions;

  PlansApi({
    required this.id,
    required this.isActive,
    required this.name,
    required this.description,
    this.classLimit,
    this.price,
    required this.allowGuests,
    this.guestLimitPerClass,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.classSessions,
  });

  factory PlansApi.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    List<ClassSession> _parseSessions(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => ClassSession.fromJson(e)).toList();
      return [];
    }

    return PlansApi(
      id: json['id'] ?? 0,
      isActive: json['is_active'] ?? false,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      classLimit: _parseInt(json['class_limit']),
      price: _parseInt(json['price']),
      allowGuests: json['allow_guests'] ?? false,
      guestLimitPerClass: json['guest_limit_per_class'],
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      deletedAt: json['deleted_at'],
      classSessions: _parseSessions(json['class_sessions']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "name": name,
        "description": description,
        "class_limit": classLimit,
        "price": price,
        "allow_guests": allowGuests,
        "guest_limit_per_class": guestLimitPerClass,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "class_sessions": List<dynamic>.from(classSessions?.map((x) => x.toJson()) ?? []),
      };
}

class ClassSession {
  final int id;
  final String title;
  final String description;
  final String visibility;
  final String classLevelId;
  final String instructorId;
  final String roomId;
  final String price;
  final int capacity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final Pivot pivot;

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
    this.createdAt,
    this.updatedAt,
    required this.deletedAt,
    required this.pivot,
  });

  factory ClassSession.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());
    return ClassSession(
      id: json["id"] ?? 0,
      title: json["title"]?.toString() ?? '',
      description: json["description"]?.toString() ?? '',
      visibility: json["visibility"]?.toString() ?? '',
      classLevelId: json["class_level_id"]?.toString() ?? '',
      instructorId: json["instructor_id"]?.toString() ?? '',
      roomId: json["room_id"]?.toString() ?? '',
      price: json["price"]?.toString() ?? '',
      capacity: json["capacity"] ?? 0,
      createdAt: _parseDate(json["created_at"]),
      updatedAt: _parseDate(json["updated_at"]),
      deletedAt: json["deleted_at"],
      pivot: Pivot.fromJson(json["pivot"] ?? {}),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  final String planId;
  final String classSessionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pivot({
    required this.planId,
    required this.classSessionId,
    this.createdAt,
    this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());
    return Pivot(
      planId: json["plan_id"]?.toString() ?? '',
      classSessionId: json["class_session_id"]?.toString() ?? '',
      createdAt: _parseDate(json["created_at"]),
      updatedAt: _parseDate(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "class_session_id": classSessionId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
