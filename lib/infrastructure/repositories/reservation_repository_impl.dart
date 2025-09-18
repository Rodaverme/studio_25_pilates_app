import 'package:studio_25_pilates_app/domain/entities/entities.dart';

import 'package:studio_25_pilates_app/domain/repositories/reservation_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/reservation_datasource_impl.dart';

class ReservationRepositoryImpl extends ReservationRepository {
  final ReservationDatasourceImpl datasourceImpl;

  ReservationRepositoryImpl({required this.datasourceImpl});

  @override
  Future<void> createReservation(
    int ocurrenceId,
    String paymentMethod,
    int cardId,
  ) {
    return datasourceImpl.createReservation(ocurrenceId, paymentMethod, cardId);
  }

  @override
  Future<List<Reservation>> getResevation() {
    return datasourceImpl.getResevation();
  }
}
