// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String token;
    Client client;

    LoginResponse({
        required this.token,
        required this.client,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        client: Client.fromJson(json["client"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "client": client.toJson(),
    };
}

class Client {
    int id;
    String name;
    String email;
    dynamic emailVerifiedAt;
    bool isActive;
    dynamic avatarUrl;
    String language;
    DateTime lastLoginAt;
    DateTime birthdate;
    dynamic gender;
    String phone;
    String documentType;
    String documentNumber;
    String businessName;
    String personType;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    Client({
        required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.isActive,
        required this.avatarUrl,
        required this.language,
        required this.lastLoginAt,
        required this.birthdate,
        required this.gender,
        required this.phone,
        required this.documentType,
        required this.documentNumber,
        required this.businessName,
        required this.personType,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
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
        birthdate: DateTime.parse(json["birthdate"]),
        gender: json["gender"],
        phone: json["phone"],
        documentType: json["document_type"],
        documentNumber: json["document_number"],
        businessName: json["business_name"],
        personType: json["person_type"],
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
        "birthdate": birthdate.toIso8601String(),
        "gender": gender,
        "phone": phone,
        "document_type": documentType,
        "document_number": documentNumber,
        "business_name": businessName,
        "person_type": personType,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
