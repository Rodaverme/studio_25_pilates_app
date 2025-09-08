import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/confirmed_password.dart';
import 'package:studio_25_pilates_app/infrastructure/inputs/inputs.dart';

part 'forms_state.dart';

class FormsCubit extends Cubit<FormsFormState> {
  FormsCubit() : super(FormsFormState());

  void onSubmit() {
    emit(
      state.copyWith(
        formStauts: FormStauts.validating,
        username: Username.dirty(state.username.value),
        password: Password.dirty(state.password.value),
        email: Email.dirty(state.email.value),
        confirmedPassword: ConfirmedPassword.dirty(
          value: state.confirmedPassword.value,
          password: state.password.value
        ),
        isValid: Formz.validate([state.username, state.password,state.email,state.confirmedPassword]),
      ),
    );

    print('Cubit Submit :$state');
  }

  void usernameChange(String value) {
    final username = Username.dirty(value);

    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([
          username,
          state.password,
          state.email,
          state.confirmedPassword,
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
          email,
          state.username,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChange(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          password,
          state.username,
          state.email,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void confirmedPasswordChange(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(value: value,password: state.password.value);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          confirmedPassword,
          state.username,
          state.email,
          state.password,
        ]),
      ),
    );
  }
}
