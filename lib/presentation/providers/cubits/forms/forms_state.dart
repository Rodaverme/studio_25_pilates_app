part of 'forms_cubit.dart';

enum FormStauts { invalid, valid, validating, posting }

class FormsFormState extends Equatable {
  final bool isValid;
  final FormStauts formStauts;
  final Username username;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;

  const FormsFormState({
    this.formStauts = FormStauts.invalid,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.isValid = false,
  });

  FormsFormState copyWith({
    FormStauts? formStauts,
    bool? isValid,
    Username? username,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
  }) => FormsFormState(
    isValid: isValid ?? this.isValid,
    formStauts: formStauts ?? this.formStauts,
    username: username ?? this.username,
    email: email ?? this.email,
    password: password ?? this.password,
    confirmedPassword: confirmedPassword ?? this.confirmedPassword,
  );

  @override
  List<Object?> get props => [
    formStauts,
    username,
    email,
    password,
    isValid,
    confirmedPassword,
  ];
}
