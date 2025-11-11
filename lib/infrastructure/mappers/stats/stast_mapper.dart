import 'package:studio_25_pilates_app/domain/entities/stats.dart';
import 'package:studio_25_pilates_app/infrastructure/models/stats/stats_response.dart';

class StastMapper {
  static Stats statsApiToEntity(StastResponse json) => Stats(
    clasessThisMonth: json.plans.active.classLimit,
    streak: json.reservations.longestStreakDays,
    totoalReservation: json.reservations.total,
    totalClasses: json.plans.active.classLimit,
    totaltime: json.reservations.hoursTrained,
    attendeed: json.reservations.attended
  );
}
