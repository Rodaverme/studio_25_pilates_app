
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/plan_respoitory_impl.dart';

part 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  final PlanRespoitoryImpl repository;

  PlanCubit(this.repository) : super(PlanState());

  void reset() {
    emit(PlanState());
  }

  Future<void> loadPlans() async {
    emit(state.copyWith(status: PlanStatus.loading));
    try {
      final plans = await repository.getAllPlans();
      emit(state.copyWith(status: PlanStatus.loaded, plans: plans));
    } catch (e) {
      emit(
        state.copyWith(status: PlanStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> loadMyPlan() async {
    emit(state.copyWith(status: PlanStatus.loading));
    try {
      final myPlan = await repository.getMyPlan();
      emit(state.copyWith(status: PlanStatus.loaded, myPlan: myPlan));
    } catch (e) {
      emit(
        state.copyWith(status: PlanStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> loadStatusPlan() async {
    emit(state.copyWith(status: PlanStatus.loading));
    try {
      final statusPlan = await repository.statusPlan();
      emit(state.copyWith(status: PlanStatus.loaded, statusPlan: statusPlan));
    } catch (e) {
      emit(
        state.copyWith(status: PlanStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> cancelMyPlan() async {
    emit(state.copyWith(status: PlanStatus.loading));
    try {
      await repository.cancelMyPlan();
      emit(
        state.copyWith(
          status: PlanStatus.canceled,
          myPlan: null,
          statusPlan: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PlanStatus.error, errorMessage: e.toString()),
      );
    }
  }
}


  // Future<void> getAllPlans() async {
    
  //   emit(PlanLoading());
  //   try {
  //     final plans = await repository.getAllPlans();
  //     final myPlan = await repository.getMyPlan();
  //     StatusPlan? statusPlan;
  //     print( 'Este es el Id de mi plan  ${myPlan.id }');
  //     statusPlan = await repository.statusPlan(); // aquí usas el id
  //         emit(AllPlansLoaded(plans: plans,myPlan: myPlan,statusPlan: statusPlan));
  //   } catch (e) {
  //     emit(PlanError(e.toString()));
  //   }
  // }


