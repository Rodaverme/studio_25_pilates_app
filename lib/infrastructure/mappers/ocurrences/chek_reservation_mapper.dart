import 'package:studio_25_pilates_app/domain/entities/check_reservation.dart';
import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/check_response.dart';

class ChekReservationMapper {
  static CheckReservation toEntity(CheckResponse json) {
    return CheckReservation(
      available: json.available,
      startTime: json.startTime,
      canReserve: json.canReserve,
      capacity: json.capacity,
      classId: json.classId,
      creditsRemaining: json.creditsRemaining,
      date: json.date,
      endTime: json.endTime,
      isInPlan: json.isInPlan,
      occurrenceId: json.occurrenceId,
      planExpiresAt: json.planExpiresAt,
      reserved: json.reserved,
    );
  }
}
