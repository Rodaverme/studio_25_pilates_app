import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

abstract class ReservationRepository {
  Future<void> createReservation(
    int ocurrenceId,
    String paymentMethod,
    int cardId,
  );
  Future<PilatesClass> getResevation();
}