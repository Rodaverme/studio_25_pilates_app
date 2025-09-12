import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_list_response.dart';
import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';



class ClassMapper {
  static PilatesClass classApitoEntity(OccurrenceResponse occurrence) {
    return PilatesClass(
      id: occurrence.classSessionId ?? '',
      nombre: occurrence.classSession?.title ?? '',
      date: occurrence.date,
      isInPlan: occurrence.isInPlan,
      instructor: occurrence.classSession?.instructor?.name ?? "Sin instructor",
      bioInstructor: occurrence.classSession?.instructor?.bio ?? "",
      cupoMaximo: occurrence.classSession?.capacity ?? occurrence.capacity ,
      nivel: occurrence.classSession?.classLevel?.name ?? "Sin nivel",
      cuposOcupados: int.tryParse(occurrence.reservedCount ?? "0") ?? 0,
      sala: occurrence.classSession?.room?.name ?? "Sin sala",
      descripcion: occurrence.classSession?.description ?? '',
      price: occurrence.classSession?.price ?? occurrence.price ?? '',
      endTime: occurrence.endTime ?? '',
      starTime: occurrence.startTime ?? '',
      ocurrenceId: occurrence.id,
    );
    
  }

  static List<PilatesClass> listApiToEntity(OccurrenceListResponse response) {
    return response.data.map((o) => classApitoEntity(o)).toList();
  }
  
}
