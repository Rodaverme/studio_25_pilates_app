import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

class ReservationResponse {
  int? id;
  String? clientId;
  String? occurrenceId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Datum? occurrence;

  ReservationResponse({
    this.id,
    this.clientId,
    this.occurrenceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.occurrence,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) =>
      ReservationResponse(
        id: json["id"],
        clientId: json["client_id"],
        occurrenceId: json["occurrence_id"],
        status: json["status"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        occurrence: json["occurrence"] != null
            ? Datum.fromJson(json["occurrence"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "occurrence_id": occurrenceId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "occurrence": occurrence?.toJson(),
      };
}
