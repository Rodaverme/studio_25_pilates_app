part of 'level_cubit.dart';

enum LevelStatus { initial, loading, loaded, error }

class LevelState extends Equatable {
  final LevelStatus status;
  final List<Nivel> levels;
  final String? errorMessage;

  const LevelState({
    this.status = LevelStatus.initial,
    this.levels = const [],
    this.errorMessage,
  });

LevelState copyWith({
    LevelStatus? status,
    List<Nivel>? levels,
    String? errorMessage,
  }) {
    return LevelState(
      status: status ?? this.status,
      levels: levels ?? this.levels,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }




  @override
  List<Object> get props => [status,levels,?errorMessage];
}


