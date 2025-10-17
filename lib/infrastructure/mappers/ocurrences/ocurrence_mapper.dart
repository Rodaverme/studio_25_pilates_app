// infrastructure/mappers/occurrence_mapper.dart

import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/class/class_mapper.dart';

import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

class OccurrenceMapper {
  static Ocurrence toEntity(Datum json) {
    return Ocurrence(
      id: json.id ?? 1,

      date: json.date ?? DateTime.now(),
      startTime: json.startTime ?? DateTime.now(),
      endTime: json.endTime ?? DateTime.now(),
      capacity: json.capacity ?? 1,
      price: json.price ?? '',
      isInPlan: json.isInPlan ?? false,
      classSession: json.classSession != null
          ? ClassMapper.classApitoEntity(json.classSession!)
          : null,
      duracion: json.duracion ?? 1,
      classSessionTitle: json.classSessionTitle,
    );
  }
}
