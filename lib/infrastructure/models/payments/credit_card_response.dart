// To parse this JSON data, do
//
//     final creditCard = creditCardFromJson(jsonString);

import 'dart:convert';

CreditCardResponse creditCardFromJson(String str) =>
    CreditCardResponse.fromJson(json.decode(str));

String creditCardToJson(CreditCardResponse data) => json.encode(data.toJson());

class CreditCardResponse {
  int id;
  String clientId;
  String brand;
  dynamic name;
  dynamic bin;
  dynamic cardHolder;
  String lastFour;
  String token;
  dynamic sourceId;
  String expMonth;
  String expYear;
  bool isDefault;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  CreditCardResponse({
    required this.id,
    required this.clientId,
    required this.brand,
    required this.name,
    required this.bin,
    required this.cardHolder,
    required this.lastFour,
    required this.token,
    required this.sourceId,
    required this.expMonth,
    required this.expYear,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) =>
      CreditCardResponse(
        id: json["id"],
        clientId: json["client_id"],
        brand: json["brand"],
        name: json["name"],
        bin: json["bin"],
        cardHolder: json["card_holder"],
        lastFour: json["last_four"],
        token: json["token"],
        sourceId: json["source_id"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        isDefault: json["is_default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "brand": brand,
    "name": name,
    "bin": bin,
    "card_holder": cardHolder,
    "last_four": lastFour,
    "token": token,
    "source_id": sourceId,
    "exp_month": expMonth,
    "exp_year": expYear,
    "is_default": isDefault,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
