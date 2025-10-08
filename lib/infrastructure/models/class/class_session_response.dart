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
  String? title;
  String? description;
  String? visibility;
  String?classLevelId;
  String? instructorId;
  String? roomId;
  String? price;
  int? capacity;
  ClassLevelResponse? classLevel;
  InstructorResponse? instructor;
  RoomResponse? room;
  Datum? nextOcurrence;
 

  ClassSessionResponse({
    required this.id,
    this.title,
    this.description,
    this.visibility,
    this.classLevelId,
    this.instructorId,
    this.roomId,
    this.price,
    this.capacity,
    required this.classLevel,
    required this.instructor,
    required this.room,
    required this.nextOcurrence

   
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
      nextOcurrence: json["next_occurrence"] != null
          ? Datum.fromJson(json["next_occurrence"])
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
    "class_level": classLevel?.toJson(),
    "instructor": instructor?.toJson(),
    "room": room?.toJson(),
   
  };
}
