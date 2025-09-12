class InstructorResponse {
    int id;
    String? name;
    String? email;
    bool isActive;
    String? bio;
    dynamic photoUrl;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    InstructorResponse({
        required this.id,
         this.name,
         this.email,
        required this.isActive,
        required this.bio,
        required this.photoUrl,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory InstructorResponse.fromJson(Map<String, dynamic> json) => InstructorResponse(
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