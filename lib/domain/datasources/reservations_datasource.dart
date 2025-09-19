import 'package:studio_25_pilates_app/domain/entities/check_reservation.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';

abstract class ReservationsDatasource {
  Future<void> createReservation(
    int ocurrenceId,
    String paymentMethod,
    int cardId,
  );
  Future<List<Reservation>> getResevation();
  Future<CheckReservation>reservationCheck(int ocurrenceId);
}
