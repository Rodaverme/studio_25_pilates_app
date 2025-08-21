// To parse this JSON data, do
//
//     final classByIdResponse = classByIdResponseFromJson(jsonString);

import 'dart:convert';

ClassByIdResponse classByIdResponseFromJson(String str) => ClassByIdResponse.fromJson(json.decode(str));

String classByIdResponseToJson(ClassByIdResponse data) => json.encode(data.toJson());

class ClassByIdResponse {
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
    ClassLevel classLevel;
    Instructor instructor;
    Room room;
    List<dynamic> plans;

    ClassByIdResponse({
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
        required this.plans,
    });

    factory ClassByIdResponse.fromJson(Map<String, dynamic> json) => ClassByIdResponse(
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
        classLevel: ClassLevel.fromJson(json["class_level"]),
        instructor: Instructor.fromJson(json["instructor"]),
        room: Room.fromJson(json["room"]),
        plans: List<dynamic>.from(json["plans"].map((x) => x)),
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
        "class_level": classLevel.toJson(),
        "instructor": instructor.toJson(),
        "room": room.toJson(),
        "plans": List<dynamic>.from(plans.map((x) => x)),
    };
}

class ClassLevel {
    int id;
    String name;
    String description;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    ClassLevel({
        required this.id,
        required this.name,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory ClassLevel.fromJson(Map<String, dynamic> json) => ClassLevel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}

class Instructor {
    int id;
    String name;
    String email;
    bool isActive;
    String bio;
    dynamic photoUrl;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    Instructor({
        required this.id,
        required this.name,
        required this.email,
        required this.isActive,
        required this.bio,
        required this.photoUrl,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        isActive: json["is_active"],
        bio: json["bio"],
        photoUrl: json["photo_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "is_active": isActive,
        "bio": bio,
        "photo_url": photoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}

class Room {
    int id;
    String name;
    String capacity;
    dynamic location;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    Room({
        required this.id,
        required this.name,
        required this.capacity,
        required this.location,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        name: json["name"],
        capacity: json["capacity"],
        location: json["location"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "capacity": capacity,
        "location": location,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
