import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';


class ClassMapper {
  static PilatesClass classApitoEntity(ClassSessionResponse classes
  ) => PilatesClass(
    id: classes.id.toString(),
    nombre: classes.title,
    fechaHora: classes.createdAt,
    duracion: Duration(minutes: 30),
    instructor: classes.instructor!.name,
    bioInstructor:classes.instructor!.bio,
    cupoMaximo: classes.capacity,
    nivel: classes.classLevel!.name,
    cuposOcupados: 10,
    sala:classes.room!.name,
    descripcion: classes.description,
    price: classes.price,
  );
}
