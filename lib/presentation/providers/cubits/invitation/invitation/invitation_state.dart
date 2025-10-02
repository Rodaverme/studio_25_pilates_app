part of 'invitation_cubit.dart';

enum InvitationStatus { initial, loading, loaded, error }

class InvitationState extends Equatable {
  final InvitationStatus status;
  final List<GuestResponse> guests;
  final String? errorMessage;

  const InvitationState({
    this.status = InvitationStatus.initial,
    this.guests = const [],
    this.errorMessage,
  });

  InvitationState copyWith({
    InvitationStatus? status,
    List<GuestResponse>? guests,
    String? errorMessage,
  }) {
    return InvitationState(
      status: status ?? this.status,
      guests: guests ?? this.guests,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, guests, errorMessage];
}
