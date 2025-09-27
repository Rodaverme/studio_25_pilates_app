import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  InvitationCubit() : super(InvitationInitial());
}
