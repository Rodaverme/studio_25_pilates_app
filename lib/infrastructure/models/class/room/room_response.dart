class RoomResponse {
    int id;
    String? name;
    String?capacity;
    dynamic location;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    RoomResponse({
        required this.id,
        this.name,
        this.capacity,
        required this.location,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory RoomResponse.fromJson(Map<String, dynamic> json) => RoomResponse(
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