part of 'reservation_cubit.dart';

enum ReservationStatus { initial, loading, loaded, error, reserved }

class ReservationState extends Equatable {
  final ReservationStatus status;
  final List<Reservation> reservations;
  final CheckReservation? checkReservation;
  final int? activePlanID;
  final String? errorMessage;
  const ReservationState({
    this.status = ReservationStatus.initial,
    this.reservations = const [],
    this.errorMessage,
    this.checkReservation,
    this.activePlanID,
  });

  ReservationState copyWith({
    ReservationStatus? status,
    String? errorMessage,
    List<Reservation>? reservations,
    CheckReservation? checkReservation,
    int? activePlanID,
  }) {
    return ReservationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      reservations: reservations ?? this.reservations,
      checkReservation: checkReservation ?? this.checkReservation,
      activePlanID: activePlanID ?? this.activePlanID,
    );
  }

  @override
  List<dynamic> get props => [
    status,
    ?errorMessage,
    reservations,
    ?checkReservation,
    activePlanID
  ];
}
