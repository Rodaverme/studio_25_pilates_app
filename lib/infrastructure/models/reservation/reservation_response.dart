// To parse this JSON data, do
//
//     final reservationResponse = reservationResponseFromJson(jsonString);

import 'dart:convert';

import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

List<ReservationResponse> reservationResponseFromJson(String str) => List<ReservationResponse>.from(json.decode(str).map((x) => ReservationResponse.fromJson(x)));

String reservationResponseToJson(List<ReservationResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReservationResponse {
    int id;
    String clientId;
    String occurrenceId;
    String status;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;
    Datum occurrence;
    

    ReservationResponse({
        required this.id,
        required this.clientId,
        required this.occurrenceId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.occurrence,
       
    });

    factory ReservationResponse.fromJson(Map<String, dynamic> json) => ReservationResponse(
        id: json["id"],
        clientId: json["client_id"],
        occurrenceId: json["occurrence_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        occurrence: Datum.fromJson(json["occurrence"]),
        
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "occurrence_id": occurrenceId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "occurrence": occurrence.toJson(),
       
    };
}







