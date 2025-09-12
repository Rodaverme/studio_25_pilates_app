import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class OccurrenceResponse {
  int id;
  String classSessionId;
  String recurringScheduleId;
  dynamic specialScheduleId;
  DateTime date;
  String startTime;
  String endTime;
  int capacity;
  String price;
  bool isSpecial;
  bool isCancelled;
  String reservedCount;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  ClassSessionResponse? classSession;

  OccurrenceResponse({
    required this.id,
    required this.classSessionId,
    required this.recurringScheduleId,
    required this.specialScheduleId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.price,
    required this.isSpecial,
    required this.isCancelled,
    required this.reservedCount,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    this.classSession,
  });

  factory OccurrenceResponse.fromJson(Map<String, dynamic> json) =>
      OccurrenceResponse(
        id: json["id"],
        classSessionId: json["class_session_id"],
        recurringScheduleId: json["recurring_schedule_id"],
        specialScheduleId: json["special_schedule_id"],
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        capacity: json["capacity"],
        price: json["price"],
        isSpecial: json["is_special"],
        isCancelled: json["is_cancelled"],
        reservedCount: json["reserved_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        classSession: json['class_session'] != null
            ? ClassSessionResponse.fromJson(json['class_session'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "class_session_id": classSessionId,
    "recurring_schedule_id": recurringScheduleId,
    "special_schedule_id": specialScheduleId,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "capacity": capacity,
    "price": price,
    "is_special": isSpecial,
    "is_cancelled": isCancelled,
    "reserved_count": reservedCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    'class_session': classSession,
  };
}
