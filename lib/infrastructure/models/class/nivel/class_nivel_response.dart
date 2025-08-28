class ClassLevelResponse {
    int id;
    String name;
    String description;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    ClassLevelResponse({
        required this.id,
        required this.name,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory ClassLevelResponse.fromJson(Map<String, dynamic> json) => ClassLevelResponse(
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