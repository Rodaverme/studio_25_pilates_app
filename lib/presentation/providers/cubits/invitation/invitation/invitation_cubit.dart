import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:studio_25_pilates_app/infrastructure/models/guest/guest_response.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/guest_datasource_impl.dart';

part 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final GuestDatasourceImpl datasource;

  InvitationCubit(this.datasource) : super(const InvitationState());

  /// Obtener todos los invitados
  Future<void> loadGuests() async {
    emit(state.copyWith(status: InvitationStatus.loading));
    try {
      final guests = await datasource.getAllGuest();
      emit(state.copyWith(status: InvitationStatus.loaded, guests: guests));
    } catch (e) {
      emit(
        state.copyWith(
          status: InvitationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Crear un nuevo invitado
  Future<void> createGuest({
    required String name,
    required String document,
    String? email,
    String? phone,
    required reservationId,
  }) async {
    emit(state.copyWith(status: InvitationStatus.loading));
    try {
      await datasource.createGuest(name, document, email, phone, reservationId);
      emit(state.copyWith(status: InvitationStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: InvitationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
