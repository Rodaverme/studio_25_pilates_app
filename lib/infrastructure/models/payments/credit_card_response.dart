import 'dart:convert';

CreditCardResponse creditCardFromJson(String str) =>
    CreditCardResponse.fromJson(json.decode(str));

String creditCardToJson(CreditCardResponse data) =>
    json.encode(data.toJson());

class CreditCardResponse {
  int? id;
  String? clientId;
  String? brand;
  String? name;
  String? bin;
  String? cardHolder;
  String? lastFour;
  String? token;
  String? sourceId;
  String? expMonth;
  String? expYear;
  bool? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  CreditCardResponse({
    this.id,
    this.clientId,
    this.brand,
    this.name,
    this.bin,
    this.cardHolder,
    this.lastFour,
    this.token,
    this.sourceId,
    this.expMonth,
    this.expYear,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
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
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
