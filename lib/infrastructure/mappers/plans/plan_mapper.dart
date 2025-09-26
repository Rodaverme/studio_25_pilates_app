import 'package:studio_25_pilates_app/domain/entities/plan.dart';

import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_reponse.dart';

class PlanMapper {
  static Plan planApitoEntity(PlanResponse plan) => Plan(
    id: plan.id,
    name: plan.name,
    classLimit: plan.classLimit ,
    allowGuests: plan.allowGuests,
    isActive: plan.isActive,
    price: plan.price.toString() ,
    description: plan.description ?? '',
  );
}
