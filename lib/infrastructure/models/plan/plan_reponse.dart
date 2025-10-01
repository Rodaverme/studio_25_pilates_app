// To parse this JSON data, do
//
//     final planResponse = planResponseFromJson(jsonString);

import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

List<PlanResponse> planResponseFromJson(String str) => List<PlanResponse>.from(
  json.decode(str).map((x) => PlanResponse.fromJson(x)),
);

String planResponseToJson(List<PlanResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlanResponse {
  int id;
  bool? isActive;
  String name;
  String? description;
  int? classLimit;
  String price;
  bool? allowGuests;
  int? guestPerPeriod;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<ClassSessionResponse>? classSessions;

  PlanResponse({
    required this.id,
    this.isActive,
    required this.name,
    this.description,
    this.classLimit,
    required this.price,
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
    description: json["description"] ?? '',
    classLimit: json["class_limit"],
    price: json["price"],
    allowGuests: json["allow_guests"],
    guestPerPeriod: json["guest_per_period"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    classSessions: json["class_sessions"] == null
        ? null
        : List<ClassSessionResponse>.from(
            json["class_sessions"].map((x) => ClassSessionResponse.fromJson(x)),
          ),
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
    "class_sessions": List<dynamic>.from(
      classSessions?.map((x) => x.toJson()) ?? [],
    ),
  };
}
