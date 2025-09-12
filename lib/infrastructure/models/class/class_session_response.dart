// To parse this JSON data, do
//
//     final classSessionResponse = classSessionResponseFromJson(jsonString);

import 'dart:convert';

// import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/instructor/instructor_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/nivel/class_nivel_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/room/room_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

List<ClassSessionResponse> classSessionResponseFromJson(String str) =>
    List<ClassSessionResponse>.from(
      json.decode(str).map((x) => ClassSessionResponse.fromJson(x)),
    );

String classSessionResponseToJson(List<ClassSessionResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClassSessionResponse {
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
  ClassLevelResponse? classLevel;
  InstructorResponse? instructor;
  RoomResponse? room;
  OccurrenceResponse? nextOccurrence;

  ClassSessionResponse({
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
    required this.classLevel,
    required this.instructor,
    required this.room,
    required this.nextOccurrence,
  });

  factory ClassSessionResponse.fromJson(Map<String, dynamic> json) {
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

    return ClassSessionResponse(
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
      classLevel: ClassLevelResponse.fromJson(
        (json["class_level"] ?? const <String, dynamic>{})
            as Map<String, dynamic>,
      ),
      instructor: InstructorResponse.fromJson(
        (json["instructor"] ?? const <String, dynamic>{})
            as Map<String, dynamic>,
      ),
      room: RoomResponse.fromJson(
        (json["room"] ?? const <String, dynamic>{}) as Map<String, dynamic>,
      ),
      nextOccurrence: json["next_occurrence"] != null
          ? OccurrenceResponse.fromJson(json["next_occurrence"])
          : null,
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
    "class_level": classLevel?.toJson(),
    "instructor": instructor?.toJson(),
    "room": room?.toJson(),
    "next_occurrence": nextOccurrence?.toJson(),
  };
}
