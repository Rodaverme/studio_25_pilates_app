class InstructorResponse {
  final int id;
  final String name;
  final String? email;
  final bool isActive;
  final String? bio;
  final dynamic photoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  InstructorResponse({
    required this.id,
    this.name = '',
    this.email,
    this.isActive = false,
    this.bio,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory InstructorResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return InstructorResponse(
        id: 0,
        name: "Sin Instructor",
      );
    }

    return InstructorResponse(
      id: json["id"] ?? 0,
      name: json["name"] ?? "Sin Instructor",
      email: json["email"],
      isActive: json["is_active"] ?? false,
      bio: json["bio"],
      photoUrl: json["photo_url"],
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
        "email": email,
        "is_active": isActive,
        "bio": bio,
        "photo_url": photoUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
