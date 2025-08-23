class PlanApi {
    int id;
    bool isActive;
    String name;
    String description;
    String classLimit;
    String validDays;
    String price;
    bool allowGuests;
    dynamic guestLimitPerClass;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    PlanApi({
        required this.id,
        required this.isActive,
        required this.name,
        required this.description,
        required this.classLimit,
        required this.validDays,
        required this.price,
        required this.allowGuests,
        required this.guestLimitPerClass,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory PlanApi.fromJson(Map<String, dynamic> json) => PlanApi(
        id: json["id"],
        isActive: json["is_active"],
        name: json["name"],
        description: json["description"],
        classLimit: json["class_limit"],
        validDays: json["valid_days"],
        price: json["price"],
        allowGuests: json["allow_guests"],
        guestLimitPerClass: json["guest_limit_per_class"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "name": name,
        "description": description,
        "class_limit": classLimit,
        "valid_days": validDays,
        "price": price,
        "allow_guests": allowGuests,
        "guest_limit_per_class": guestLimitPerClass,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
