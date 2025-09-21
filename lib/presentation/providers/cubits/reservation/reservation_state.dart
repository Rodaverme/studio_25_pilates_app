part of 'reservation_cubit.dart';

enum ReservationStatus { initial, loading, loaded, error }

class ReservationState extends Equatable {
  final ReservationStatus status;
  final List<Reservation> reservations;
  final CheckReservation? checkReservation;
  final String? errorMessage;
  const ReservationState({
    this.status = ReservationStatus.initial,
    this.reservations = const [],
    this.errorMessage,
    this.checkReservation

  });

  ReservationState copyWith({
    ReservationStatus? status,
    String? errorMessage,
    List<Reservation>? reservations,
    CheckReservation? checkReservation
  }) {
    return ReservationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      reservations: reservations ?? this.reservations,
      checkReservation: checkReservation ?? this.checkReservation
    );
  }

  @override
  List<Object> get props => [status, ?errorMessage,reservations,?checkReservation];
}
