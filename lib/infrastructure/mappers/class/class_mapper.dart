import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class ClassMapper {
  static PilatesClass classApitoEntity(ClassSessionResponse classe) {
    return PilatesClass(
      id: classe.id.toString(),
      nombre: classe.title ?? '',
      instructor: classe.instructor?.name ?? "Sin instructor",
      bioInstructor: classe.instructor?.bio ?? "",
      cupoMaximo: classe.capacity ?? 1,
      nivel: classe.classLevel?.name ?? "Sin nivel",
      sala: classe.room?.name ?? "Sin sala",
      descripcion: classe.description ?? '',
      price: classe.price ?? '',
    );
  }
}
