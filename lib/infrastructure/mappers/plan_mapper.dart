import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';

import 'package:studio_25_pilates_app/infrastructure/models/plan/class_by_plan.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_api.dart';

class PlanMapper {
  static Plan planApitoEntity(PlansApi plan) => Plan(
        id: plan.id,
        name: plan.name,
        allowGuests: plan.allowGuests,
        guestLimitPerClass: plan.guestLimitPerClass,
        isActive: plan.isActive,
        price: plan.price?.toString() ?? '0',
        description: plan.description ,
        classes: (plan.classSessions ?? [])
            .map((cls) => _mapClass(cls))
            .toList(),
      );

  static PilatesClass _mapClass(ClassSessionByPlanResponse cls) {
    return PilatesClass(
      id: cls.id.toString(),
      nombre: cls.title,
      descripcion: cls.description,
      fechaHora: cls.createdAt,
      duracion: const Duration(minutes: 30),
      instructor: cls.instructorId,
      cupoMaximo: cls.capacity,
      nivel: cls.classLevelId,
      cuposOcupados: 0,
      sala: cls.roomId,
      price: cls.price,
       // si en tu entidad es num, cámbialo a double.tryParse(cls.price) ?? 0
    );
  }
}
