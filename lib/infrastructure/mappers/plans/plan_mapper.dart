
import 'package:studio_25_pilates_app/domain/entities/plan.dart';


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
      );
}
