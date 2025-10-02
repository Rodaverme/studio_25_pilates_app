class ClassLevelResponse {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  ClassLevelResponse({
    this.id,
    this.name = 'Sin Nivel',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ClassLevelResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ClassLevelResponse(
        id: 0,
        name: "Sin Nivel",
      );
    }

    return ClassLevelResponse(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Sin Nivel",
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
