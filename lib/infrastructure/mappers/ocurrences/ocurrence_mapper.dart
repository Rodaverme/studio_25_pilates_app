// infrastructure/mappers/occurrence_mapper.dart


import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/class/class_mapper.dart';


import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

class OccurrenceMapper {
  static Ocurrence toEntity(Datum json) {
    return Ocurrence(
      id: json.id,
      date: json.date,
      startTime: json.startTime,
      endTime: json.endTime,
      capacity: json.capacity,
      price: json.price,
      isSpecial: json.isSpecial,
      isCancelled: json.isCancelled,
      isInPlan: json.isInPlan,
      reservedCount: int.tryParse(json.reservedCount) ?? 0,
      classSession: ClassMapper.classApitoEntity(json.classSession),
    );
  }
}
