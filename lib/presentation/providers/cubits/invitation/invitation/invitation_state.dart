part of 'invitation_cubit.dart';

sealed class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object> get props => [];
}

final class InvitationInitial extends InvitationState {}
