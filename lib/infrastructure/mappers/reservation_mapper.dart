import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/ocurrences/ocurrence_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/reservation/reservation_response.dart';

class ReservationMapper {
  static Reservation toEntity(ReservationResponse json) {
    return Reservation(
      id: json.id,
      clienteId: json.clientId ?? '1',
      pagada: json.status,
      ocurrence: json.occurrence != null 
      ? OccurrenceMapper.toEntity(json.occurrence!)
      : null,
    );
  }
}
