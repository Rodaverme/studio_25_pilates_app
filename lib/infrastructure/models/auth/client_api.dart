import 'dart:convert';

Client clientFromJson(String str) => Client.fromJson(json.decode(str));
String clientToJson(Client data) => json.encode(data.toJson());

class Client {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  bool? isActive;
  dynamic avatarUrl;
  String? language;
  DateTime lastLoginAt;
  String? birthdate;
  dynamic gender;
  String? phone;
  String? documentType;
  String? documentNumber;
  String? businessName;
  String? personType;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String? pathology;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    this.isActive,
    this.avatarUrl,
    this.language,
    required this.lastLoginAt,
    this.birthdate,
    required this.gender,
    this.phone,
    this.documentType,
    this.documentNumber,
    this.businessName,
    this.personType,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.pathology,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    isActive: json["is_active"],
    avatarUrl: json["avatar_url"],
    language: json["language"],
    lastLoginAt: DateTime.parse(json["last_login_at"]),
    birthdate: json["birthdate"],
    gender: json["gender"]?.toString(), // 👈 Asegurar que sea String
    phone: json["phone"] ?? "",
    documentType: json["document_type"]?.toString(), // 👈
    documentNumber: json["document_number"],
    businessName: json["business_name"],
    personType: json["person_type"]?.toString(), // 👈
    pathology: json["pathology"], // si agregaste este campo
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "is_active": isActive,
    "avatar_url": avatarUrl,
    "language": language,
    "last_login_at": lastLoginAt.toIso8601String(),
    "birthdate": birthdate ?? "",
    "gender": gender,
    "phone": phone ?? "",
    "document_type": documentType,
    "document_number": documentNumber,
    "business_name": businessName,
    "person_type": personType,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "pathology": pathology,
  };
}
