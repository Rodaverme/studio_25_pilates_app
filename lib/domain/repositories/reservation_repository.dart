
import 'package:studio_25_pilates_app/domain/entities/check_reservation.dart';
import 'package:studio_25_pilates_app/domain/entities/reservation.dart';

abstract class ReservationRepository {
  Future<void> createReservation(
    int ocurrenceId,
    String paymentMethod,
    int cardId,
    int planId
  );
  Future<List<Reservation>> getResevation();
   Future<CheckReservation>reservationCheck(int ocurrenceId);
}