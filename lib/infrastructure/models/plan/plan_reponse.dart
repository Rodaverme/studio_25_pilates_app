import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class PlanResponse {
  int? id;
  bool? isActive;
  String? name;
  String? description;
  int? classLimit;
  String? price;
  bool? allowGuests;
  int? guestPerPeriod;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<ClassSessionResponse>? classSessions;

  PlanResponse({
    this.id,
    this.isActive,
    this.name,
    this.description,
    this.classLimit,
    this.price,
    this.allowGuests,
    this.guestPerPeriod,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.classSessions,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) => PlanResponse(
    id: json["id"],
    isActive: json["is_active"],
    name: json["name"],
    description: json["description"],
    classLimit: json["class_limit"],
    price: json["price"],
    allowGuests: json["allow_guests"],
    guestPerPeriod: json["guest_per_period"],
    createdAt: json["created_at"] != null
        ? DateTime.tryParse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.tryParse(json["updated_at"])
        : null,
    deletedAt: json["deleted_at"],
    classSessions: json["class_sessions"] != null
        ? List<ClassSessionResponse>.from(
            json["class_sessions"].map((x) => ClassSessionResponse.fromJson(x)),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_active": isActive,
    "name": name,
    "description": description,
    "class_limit": classLimit,
    "price": price,
    "allow_guests": allowGuests,
    "guest_per_period": guestPerPeriod,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "class_sessions": classSessions?.map((x) => x.toJson()).toList(),
  };
}
