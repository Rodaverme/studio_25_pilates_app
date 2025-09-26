part of 'plan_cubit.dart';

enum PlanStatus {
  initial,
  loading,
  loaded,
  canceled,
  error,
  purchase,
  reserved,
}

class PlanState extends Equatable {
  final PlanStatus status;
  final List<Plan> plans;
  final Plan? myPlan;
  final StatusPlan? statusPlan;
  final String? errorMessage;
  final Plan? planById;

  const PlanState({
    this.status = PlanStatus.initial,
    this.plans = const [],
    this.myPlan,
    this.statusPlan,
    this.errorMessage,
    this.planById,
  });

  PlanState copyWith({
    PlanStatus? status,
    List<Plan>? plans,
    Plan? myPlan,
    StatusPlan? statusPlan,
    String? errorMessage,
    Plan? planById,
  }) {
    return PlanState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      myPlan: myPlan ?? this.myPlan,
      statusPlan: statusPlan ?? this.statusPlan,
      errorMessage: errorMessage ?? this.errorMessage,
      planById: planById ?? this.planById,
    );
  }

  @override
  List<Object?> get props => [
    status,
    plans,
    myPlan,
    statusPlan,
    errorMessage,
    planById,
  ];
}
