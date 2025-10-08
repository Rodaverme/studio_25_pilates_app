import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/email.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/invitationForm/identification_invitation.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/invitationForm/name_invitation.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/invitationForm/phone.dart';

part 'form_invitation_state.dart';

class FormInvitationCubit extends Cubit<FormsInvitationState> {
  FormInvitationCubit() : super(const FormsInvitationState());

  void onSubmit() {
    final username = NameInvitation.dirty(state.username.value);
    final identification = IdentificationInvitation.dirty(
      state.identificationInvitation.value,
    );
    final email = Email.dirty(state.email.value);
    final phone = Phone.dirty(state.phone.value);

    // validación: username e identification son obligatorios
    

    emit(
      state.copyWith(
        formStauts: FormInvitationStauts.validating,
        username: username,
        identificationInvitation: identification,
        email: email,
        phone: phone,
        isValid: Formz.validate([
          username,
          identification,
          if (email.value.isNotEmpty) email,
          if (phone.value.isNotEmpty) phone,
        ]),
      ),
    );

    print('Cubit Submit : $state');
  }

  void usernameChange(String value) {
    final username = NameInvitation.dirty(value);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([
          username,
          state.identificationInvitation,
          if (state.email.value.isNotEmpty) state.email,
          if (state.phone.value.isNotEmpty) state.phone,
        ]),
      ),
    );
  }

  void identificationChange(String value) {
    final identification = IdentificationInvitation.dirty(value);
    emit(
      state.copyWith(
        identificationInvitation: identification,
        isValid: Formz.validate([
          identification,
          state.username,
          if (state.email.value.isNotEmpty) state.email,
          if (state.phone.value.isNotEmpty) state.phone,
        ]),
      ),
    );
  }

  void emailChange(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          state.username,
          state.identificationInvitation,
          if (email.value.isNotEmpty) email,
          if (state.phone.value.isNotEmpty) state.phone,
        ]),
      ),
    );
  }

  void phoneChange(String value) {
    final phone = Phone.dirty(value);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate([
          state.username,
          state.identificationInvitation,
          if (state.email.value.isNotEmpty) state.email,
          if (phone.value.isNotEmpty) phone,
        ]),
      ),
    );
  }
}
