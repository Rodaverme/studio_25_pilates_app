// import 'package:studio_25_pilates_app/domain/entities/entities.dart';
// import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

// class ClassMapper {
//   static PilatesClass classApitoEntity(ClassSessionResponse classes) =>
//       PilatesClass(
//         id: classes.id.toString(),
//         nombre: classes.title,
//         date: classes.nextOccurrence?.date ?? DateTime.now(),
//         duracion: Duration(minutes: 30),
//         instructor: classes.instructor!.name,
//         bioInstructor: classes.instructor!.bio,
//         cupoMaximo: classes.capacity,
//         nivel: classes.classLevel!.name,
//         cuposOcupados: int.parse(classes.nextOccurrence?.reservedCount ?? '0'),
//         sala: classes.room!.name,
//         descripcion: classes.description,
//         price: classes.price,
//         endTime: classes.nextOccurrence?.endTime ?? '' ,
//         starTime: classes.nextOccurrence?.startTime  ?? '',
//         ocurrenceId: classes.nextOccurrence!.id
//       );
// }

import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/reservation/reservation_response.dart';

class ReservedClassMapper {
  static PilatesClass resevartionToClassEntity(
    ReservationResponse reservedClass,
  ) {
    final occurrence = reservedClass.occurrence;
    final classSession = occurrence.classSession;
    return PilatesClass(
      id: classSession?.id.toString() ?? '',
      nombre: classSession?.title ?? '',
      descripcion: classSession?.description ?? '',
      date: occurrence.date,
      duracion: Duration(minutes: 30),
      instructor: classSession?.instructor?.name ?? "Instructor no definido",
      bioInstructor: classSession?.instructor?.bio ?? "",
      cupoMaximo: occurrence.capacity,
      nivel: classSession?.classLevel?.name ?? "",
      cuposOcupados: int.tryParse(occurrence.reservedCount) ?? 0,
      sala: classSession?.room?.name ?? "",
      price: occurrence.price,
      starTime: occurrence.startTime,
      endTime: occurrence.endTime,
      ocurrenceId: occurrence.id,
    );
  }
}
