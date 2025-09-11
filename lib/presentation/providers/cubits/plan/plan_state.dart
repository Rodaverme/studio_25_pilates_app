part of 'plan_cubit.dart';

enum PlanStatus { initial, loading, loaded, canceled, error }

class PlanState extends Equatable {
  final PlanStatus status;
  final List<Plan> plans;
  final Plan? myPlan;
  final StatusPlan? statusPlan;
  final String? errorMessage;

  const PlanState({
    this.status = PlanStatus.initial,
    this.plans = const [],
    this.myPlan,
    this.statusPlan,
    this.errorMessage,
  });

  PlanState copyWith({
    PlanStatus? status,
    List<Plan>? plans,
    Plan? myPlan,
    StatusPlan? statusPlan,
    String? errorMessage,
  }) {
    return PlanState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      myPlan: myPlan ?? this.myPlan,
      statusPlan: statusPlan ?? this.statusPlan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plans, myPlan, statusPlan, errorMessage];
}
