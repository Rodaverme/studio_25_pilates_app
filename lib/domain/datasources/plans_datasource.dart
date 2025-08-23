import 'package:studio_25_pilates_app/domain/entities/plan.dart';

abstract class PlansDatasource {
  Future<Plan>getMyPlan();
  Future<void>cancelMyPlan();
}