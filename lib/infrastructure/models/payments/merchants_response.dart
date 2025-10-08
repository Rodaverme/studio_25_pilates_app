// To parse this JSON data, do
//
//     final merchantsResponse = merchantsResponseFromJson(jsonString);

import 'dart:convert';

MerchantsResponse merchantsResponseFromJson(String str) => MerchantsResponse.fromJson(json.decode(str));

String merchantsResponseToJson(MerchantsResponse data) => json.encode(data.toJson());

class MerchantsResponse {
    Data data;
    List<dynamic> meta;

    MerchantsResponse({
        required this.data,
        required this.meta,
    });

    factory MerchantsResponse.fromJson(Map<String, dynamic> json) => MerchantsResponse(
        data: Data.fromJson(json["data"]),
        meta: List<dynamic>.from(json["meta"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "meta": List<dynamic>.from(meta.map((x) => x)),
    };
}

class Data {
    int id;
    String name;
    String email;
    String contactName;
    String phoneNumber;
    bool active;
    dynamic logoUrl;
    String legalName;
    String legalIdType;
    String legalId;
    String publicKey;
    List<String> acceptedCurrencies;
    dynamic fraudJavascriptKey;
    List<dynamic> fraudGroups;
    List<String> acceptedPaymentMethods;
    List<PaymentMethod> paymentMethods;
    Presigned presignedAcceptance;
    Presigned presignedPersonalDataAuth;
    dynamic clickToPayDpaId;
    dynamic mcc;
    dynamic acquirerId;

    Data({
        required this.id,
        required this.name,
        required this.email,
        required this.contactName,
        required this.phoneNumber,
        required this.active,
        required this.logoUrl,
        required this.legalName,
        required this.legalIdType,
        required this.legalId,
        required this.publicKey,
        required this.acceptedCurrencies,
        required this.fraudJavascriptKey,
        required this.fraudGroups,
        required this.acceptedPaymentMethods,
        required this.paymentMethods,
        required this.presignedAcceptance,
        required this.presignedPersonalDataAuth,
        required this.clickToPayDpaId,
        required this.mcc,
        required this.acquirerId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        contactName: json["contact_name"],
        phoneNumber: json["phone_number"],
        active: json["active"],
        logoUrl: json["logo_url"],
        legalName: json["legal_name"],
        legalIdType: json["legal_id_type"],
        legalId: json["legal_id"],
        publicKey: json["public_key"],
        acceptedCurrencies: List<String>.from(json["accepted_currencies"].map((x) => x)),
        fraudJavascriptKey: json["fraud_javascript_key"],
        fraudGroups: List<dynamic>.from(json["fraud_groups"].map((x) => x)),
        acceptedPaymentMethods: List<String>.from(json["accepted_payment_methods"].map((x) => x)),
        paymentMethods: List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        presignedAcceptance: Presigned.fromJson(json["presigned_acceptance"]),
        presignedPersonalDataAuth: Presigned.fromJson(json["presigned_personal_data_auth"]),
        clickToPayDpaId: json["click_to_pay_dpa_id"],
        mcc: json["mcc"],
        acquirerId: json["acquirer_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "contact_name": contactName,
        "phone_number": phoneNumber,
        "active": active,
        "logo_url": logoUrl,
        "legal_name": legalName,
        "legal_id_type": legalIdType,
        "legal_id": legalId,
        "public_key": publicKey,
        "accepted_currencies": List<dynamic>.from(acceptedCurrencies.map((x) => x)),
        "fraud_javascript_key": fraudJavascriptKey,
        "fraud_groups": List<dynamic>.from(fraudGroups.map((x) => x)),
        "accepted_payment_methods": List<dynamic>.from(acceptedPaymentMethods.map((x) => x)),
        "payment_methods": List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        "presigned_acceptance": presignedAcceptance.toJson(),
        "presigned_personal_data_auth": presignedPersonalDataAuth.toJson(),
        "click_to_pay_dpa_id": clickToPayDpaId,
        "mcc": mcc,
        "acquirer_id": acquirerId,
    };
}

class PaymentMethod {
    String name;
    List<PaymentProcessor> paymentProcessors;

    PaymentMethod({
        required this.name,
        required this.paymentProcessors,
    });

    factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        name: json["name"],
        paymentProcessors: List<PaymentProcessor>.from(json["payment_processors"].map((x) => PaymentProcessor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "payment_processors": List<dynamic>.from(paymentProcessors.map((x) => x.toJson())),
    };
}

class PaymentProcessor {
    String name;

    PaymentProcessor({
        required this.name,
    });

    factory PaymentProcessor.fromJson(Map<String, dynamic> json) => PaymentProcessor(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Presigned {
    String acceptanceToken;
    String permalink;
    String type;

    Presigned({
        required this.acceptanceToken,
        required this.permalink,
        required this.type,
    });

    factory Presigned.fromJson(Map<String, dynamic> json) => Presigned(
        acceptanceToken: json["acceptance_token"],
        permalink: json["permalink"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "acceptance_token": acceptanceToken,
        "permalink": permalink,
        "type": type,
    };
}
