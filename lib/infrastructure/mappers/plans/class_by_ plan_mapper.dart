import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/instructor/instructor_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/nivel/class_nivel_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/room/room_response.dart';

class ClassByplanMapper {
  static PilatesClass classApitoEntity(
    ClassSessionResponse classes,
    InstructorResponse instructor,
    ClassLevelResponse level,
    RoomResponse room,
  ) => PilatesClass(
    id: classes.id.toString(),
    nombre: classes.title,
    date: classes.nextOccurrence?.date ?? DateTime.now(),
    duracion: Duration(minutes: 30),
    instructor: instructor.name,
    cupoMaximo: classes.capacity,
    nivel: level.name,
    cuposOcupados: int.parse(classes.nextOccurrence?.reservedCount ?? '0'),
    sala: room.name,
    descripcion: classes.description,
    price: classes.price,
    bioInstructor: instructor.bio,
    endTime: classes.nextOccurrence?.endTime ?? '',
    starTime: classes.nextOccurrence?.startTime ?? ''
  );
}
