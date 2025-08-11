part of 'register_cubit.dart';

enum FormStauts { invalid, valid, validating, posting }

class RegisterFormState extends Equatable {
  final bool isValid;
  final FormStauts formStauts;
  final Username username;
  final Email email;
  final Password password;

  const RegisterFormState({
    this.formStauts = FormStauts.invalid,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false
  });

  RegisterFormState copyWith({
    FormStauts? formStauts,
    bool? isValid,
    Username? username,
    Email? email,
    Password? password,
  }) => RegisterFormState(
    isValid: isValid ?? this.isValid,
    formStauts: formStauts ?? this.formStauts,
    username: username ?? this.username,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  List<Object?> get props => [formStauts, username, email, password,isValid];
}
