import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/domain/repositories/plan_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/plan_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';

class PlanRespoitoryImpl extends PlanRepository {
  final PlanDatasourceImpl datasource;

  PlanRespoitoryImpl(this.datasource);
  @override
  Future<void> cancelMyPlan() {
    return datasource.cancelMyPlan();
  }

  @override
  Future<Plan> getMyPlan() {
    return datasource.getMyPlan();
  }

  @override
  Future<List<Plan>> getAllPlans() {
    return datasource.getAllPlans();
  }

  @override
  Future<StatusPlan> statusPlan() {
    return datasource.statusPlan();
  }

  @override
  Future<Plan> getPlanById(int planId) {
    return datasource.getPlanById(planId);
  }

  @override
  Future<void> planPurchase(int planId,int cardId) {
    return datasource.planPurchase(planId,cardId);
  }
}
