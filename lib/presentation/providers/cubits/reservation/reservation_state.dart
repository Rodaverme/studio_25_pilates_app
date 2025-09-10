part of 'reservation_cubit.dart';

enum ReservationStatus { initial, loading, loaded, error }

class ReservationState extends Equatable {
  final ReservationStatus status;
  final String? errorMessage;
  const ReservationState({
    this.status = ReservationStatus.initial,
    this.errorMessage,
  });

  ReservationState copyWith({ReservationStatus? status, String? errorMessage}) {
    return ReservationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status,?errorMessage];
}


