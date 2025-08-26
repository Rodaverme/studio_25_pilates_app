import 'package:studio_25_pilates_app/domain/entities/plan.dart';

abstract class PlanRepository {
  Future<Plan>getMyPlan();
  Future<void>cancelMyPlan();
  Future<List<Plan>>getAllPlans();
}
