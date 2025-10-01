// To parse this JSON data, do
//
//     final notificationsResponse = notificationsResponseFromJson(jsonString);

import 'dart:convert';

List<NotificationsResponse> notificationsResponseFromJson(String str) => List<NotificationsResponse>.from(json.decode(str).map((x) => NotificationsResponse.fromJson(x)));

String notificationsResponseToJson(List<NotificationsResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationsResponse {
    int id;
    String title;
    String body;
    String createdBy;
    String status;
    dynamic readAt;
    String clientId;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    NotificationsResponse({
        required this.id,
        required this.title,
        required this.body,
        required this.createdBy,
        required this.status,
        this.readAt,
        required this.clientId,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    factory NotificationsResponse.fromJson(Map<String, dynamic> json) => NotificationsResponse(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        createdBy: json["created_by"],
        status: json["status"],
        readAt: json["read_at"],
        clientId: json["client_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "created_by": createdBy,
        "status": status,
        "read_at": readAt,
        "client_id": clientId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
