part of 'plan_cubit.dart';

abstract class PlanState {}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlanStatusLoaded extends PlanState {
  final StatusPlan statusPlan;

  PlanStatusLoaded({required this.statusPlan});
}

class AllPlansLoaded extends PlanState {
  final List<Plan> plans;
  final Plan? myPlan;
  final StatusPlan? statusPlan;

  AllPlansLoaded({required this.plans, this.myPlan, this.statusPlan});
}

class PlanCanceled extends PlanState {}

class PlanError extends PlanState {
  final String message;
  PlanError(this.message);
}
