part of 'plan_cubit.dart';

abstract class PlanState {}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlanLoaded extends PlanState {
  final Plan plan;
  PlanLoaded(this.plan);
}

class PlanCanceled extends PlanState {}

class PlanError extends PlanState {
  final String message;
  PlanError(this.message);
}