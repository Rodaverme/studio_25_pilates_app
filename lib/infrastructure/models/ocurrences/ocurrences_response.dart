import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class OccurrenceResponse {
  final int id;
  final String? classSessionId;
  final String? recurringScheduleId;
  final String? specialScheduleId;
  final DateTime date;
  final String? startTime;
  final String? endTime;
  final int capacity;
  final String? price;
  final bool isSpecial;
  final bool isCancelled;
  final String? reservedCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final bool isInPlan;
  final ClassSessionResponse? classSession;

  OccurrenceResponse({
    required this.id,
    this.classSessionId,
    this.recurringScheduleId,
    this.specialScheduleId,
    required this.date,
    this.startTime,
    this.endTime,
    required this.capacity,
    this.price,
    required this.isSpecial,
    required this.isCancelled,
    this.reservedCount,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isInPlan,
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
        price: json["price"]?.toString(),
        isSpecial: json["is_special"],
        isCancelled: json["is_cancelled"],
        reservedCount: json["reserved_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        isInPlan: json["is_in_plan"],
        classSession: json["class_session"] != null
            ? ClassSessionResponse.fromJson(json["class_session"])
            : null,
      );
}
