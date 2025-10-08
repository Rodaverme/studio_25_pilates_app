import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/class/class_mapper.dart';

import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_reponse.dart';

class PlanMapper {
  static Plan planApitoEntity(PlanResponse plan) {
    return Plan(
      id: plan.id ?? 1,
      name: plan.name ?? '',
      classLimit: plan.classLimit ?? 0,
      allowGuests: plan.allowGuests ?? false,
      isActive: plan.isActive ?? false,
      price: plan.price.toString(),
      description: plan.description ?? '',
     classes: (plan.classSessions ?? [])
    .map((c) => ClassMapper.classApitoEntity(c))
    .toList(), // 👈 lo convertimos a lista
    );
  }
}
