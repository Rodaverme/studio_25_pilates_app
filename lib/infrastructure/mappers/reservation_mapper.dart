import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/ocurrences/ocurrence_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/reservation/reservation_response.dart';

class ReservationMapper {
  static Reservation toEntity(ReservationResponse json) {
    return Reservation(
      id: json.id,
      clienteId: json.clientId,
      pagada: json.status,
      ocurrence: OccurrenceMapper.toEntity(json.occurrence),
    );
  }
}
