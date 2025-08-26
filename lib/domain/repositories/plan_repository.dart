import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';

abstract class PlanRepository {
  Future<Plan>getMyPlan();
  Future<void>cancelMyPlan();
  Future<List<Plan>>getAllPlans();
  Future<StatusPlan>statusPlan(String id);
}
