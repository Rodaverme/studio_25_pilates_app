import 'package:studio_25_pilates_app/domain/entities/class_with_next_ocurrence.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/class/class_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/ocurrences/ocurrence_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class ClassWithNextOccurrenceMapper {
  static ClassWithNextOcurrence fromApi(ClassSessionResponse response) {
    final pilatesClass = ClassMapper.classApitoEntity(response);

    final occurrence = response.nextOcurrence != null
        ? OccurrenceMapper.toEntity(response.nextOcurrence!)
        : null;

    return ClassWithNextOcurrence(
      pilatesClass: pilatesClass,
      nextOccurrence: occurrence,
    );
  }
}
