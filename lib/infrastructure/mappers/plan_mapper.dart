import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_api.dart';

class PlanMapper {
  static Plan planApitoEntity(PlansApi plan) => Plan(
    id: plan.id,
    name: plan.name,
    allowGuests: plan.allowGuests,
    guestLimitPerClass: plan.guestLimitPerClass,
    isActive: plan.isActive,
    price: plan.price.toString(),
    description: plan.description,
    classes: plan.classSessions?.map((cls) => _mapClass(cls)).toList() ?? [],
  );

   static PilatesClass _mapClass(ClassSessionResponse cls) {
    // En este punto SOLO usas lo que tengas disponible en el JSON
    return PilatesClass(
      id: cls.id.toString(),
      nombre: cls.title,
      descripcion: cls.description,
      fechaHora: cls.createdAt,
      duracion: const Duration(minutes: 30),
      instructor: "Instructor ${cls.instructorId}", // placeholder
      cupoMaximo: cls.capacity,
      nivel: "Nivel ${cls.classLevelId}", // placeholder
      cuposOcupados: 0, // placeholder
      sala: "Sala ${cls.roomId}", // placeholder
      price: cls.price,
    );
  }




}
