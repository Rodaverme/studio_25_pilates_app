import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/classbyid_response.dart';

class ClassMapper {
  static PilatesClass classApitoEntity(ClassByIdResponse classes) =>
      PilatesClass(
        id: classes.id.toString(),
        nombre: classes.title,
        fechaHora: DateTime.now(),
        duracion: Duration(minutes: 30),
        instructor: classes.instructor.name,
        cupoMaximo: classes.capacity,
        nivel: classes.classLevel.name,
        cuposOcupados: 10,
        sala: classes.room.capacity,
        descripcion: classes.description,
        price: classes.price,
      );
}
