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
    Pivot pivot;

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
        required this.pivot,
    });

    factory ClassSessionResponse.fromJson(Map<String, dynamic> json) => ClassSessionResponse(
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