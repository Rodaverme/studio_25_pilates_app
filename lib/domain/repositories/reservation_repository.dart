
import 'package:studio_25_pilates_app/domain/entities/reservation.dart';

abstract class ReservationRepository {
  Future<void> createReservation(
    int ocurrenceId,
    String paymentMethod,
    int cardId,
  );
  Future<List<Reservation>> getResevation();
}