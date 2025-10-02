class RoomResponse {
  final int? id;
  final String? name;
  final String? capacity;
  final dynamic location;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  RoomResponse({
    this.id,
    this.name = "Sin sala",
    this.capacity,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RoomResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RoomResponse(
        id: 0,
        name: "Sin sala",
      );
    }

    return RoomResponse(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Sin sala",
      capacity: json["capacity"]?.toString(), // 👈 en caso de que sea int
      location: json["location"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "capacity": capacity,
        "location": location,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
