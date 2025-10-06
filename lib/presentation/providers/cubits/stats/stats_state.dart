part of 'stats_cubit.dart';

enum StatsStatus { initial, loading, loaded, error }

class StatsState extends Equatable {
  final Stats? stats;
  final StatsStatus status;
  final String? errorMessage;

  const StatsState({
    this.stats,
    this.status = StatsStatus.initial,
    this.errorMessage,
  });

  StatsState copyWith({
    final Stats? stats,
    final StatsStatus? status,
    final String? errorMessage,
  }) {
    return StatsState(
      stats: stats ?? this.stats,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status,?stats,?errorMessage];
}
