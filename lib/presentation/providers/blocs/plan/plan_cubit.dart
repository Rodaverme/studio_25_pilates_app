import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/plan_respoitory_impl.dart';

part 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  final PlanRespoitoryImpl repository;

  PlanCubit(this.repository) : super(PlanInitial());

  Future<void> getStatusPlan(String id) async {
  emit(PlanLoading());
  try {
    final statusPlan = await repository.statusPlan();
    emit(PlanStatusLoaded(statusPlan: statusPlan));
  } catch (e) {
    emit(PlanError(e.toString()));
  }
}

  Future<void> getAllPlans() async {
    emit(PlanLoading());
    try {
      final plans = await repository.getAllPlans();
      final myPlan = await repository.getMyPlan();
      StatusPlan? statusPlan;
      print( 'Este es el Id de mi plan  ${myPlan.id }');
      statusPlan = await repository.statusPlan(); // aquí usas el id
          emit(AllPlansLoaded(plans: plans,myPlan: myPlan,statusPlan: statusPlan));
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }

  Future<void> cancelMyPlan() async {
    emit(PlanLoading());
    try {
      await repository.cancelMyPlan();
      emit(PlanCanceled());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }
}
