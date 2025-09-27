import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class GuestResponse {
    int id;
    String name;
    String capacity;
    dynamic location;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;
    List<ClassSessionResponse> classSessions;

    GuestResponse({
        required this.id,
        required this.name,
        required this.capacity,
        required this.location,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.classSessions,
    });

    factory GuestResponse.fromJson(Map<String, dynamic> json) => GuestResponse(
        id: json["id"],
        name: json["name"],
        capacity: json["capacity"],
        location: json["location"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        classSessions: List<ClassSessionResponse>.from(json["class_sessions"].map((x) => ClassSessionResponse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "capacity": capacity,
        "location": location,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "class_sessions": List<dynamic>.from(classSessions.map((x) => x.toJson())),
    };
}