import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

List<PlansApi> plansApiFromJson(String str) =>
    List<PlansApi>.from(json.decode(str).map((x) => PlansApi.fromJson(x)));

String plansApiToJson(List<PlansApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlansApi {
  final int id;
  final bool isActive;
  final String name;
  final String description;
  final int? classLimit;
  final int? price;
  final bool allowGuests;
  final dynamic guestLimitPerClass;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<ClassSessionResponse>? classSessions;

  PlansApi({
    required this.id,
    required this.isActive,
    required this.name,
    required this.description,
    this.classLimit,
    this.price,
    required this.allowGuests,
    this.guestLimitPerClass,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.classSessions,
  });

  factory PlansApi.fromJson(Map<String, dynamic> json) {
    int? _parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    List<ClassSessionResponse> _parseSessions(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => ClassSessionResponse.fromJson(e)).toList();
      return [];
    }

    return PlansApi(
      id: json['id'] ?? 0,
      isActive: json['is_active'] ?? false,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      classLimit: _parseInt(json['class_limit']),
      price: _parseInt(json['price']),
      allowGuests: json['allow_guests'] ?? false,
      guestLimitPerClass: json['guest_limit_per_class'],
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      deletedAt: json['deleted_at'],
      classSessions: _parseSessions(json['class_sessions']),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_active": isActive,
        "name": name,
        "description": description,
        "class_limit": classLimit,
        "price": price,
        "allow_guests": allowGuests,
        "guest_limit_per_class": guestLimitPerClass,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "class_sessions": List<dynamic>.from(classSessions?.map((x) => x.toJson()) ?? []),
      };
}

