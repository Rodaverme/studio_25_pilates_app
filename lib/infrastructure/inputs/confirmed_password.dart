import 'package:formz/formz.dart';


enum ConfirmedPasswordError { empty, length, isdiferent }


class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordError> {
  final String password;
const ConfirmedPassword.pure({this.password = ''} ) : super.pure('');
const ConfirmedPassword.dirty({required String value, required this.password }) : super.dirty(value);


  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == ConfirmedPasswordError.empty) return 'El campo es requerido';
    if (displayError == ConfirmedPasswordError.length) return 'Minimo 6 caracteres';
    if (displayError == ConfirmedPasswordError.isdiferent) return 'La contraseña no coincide';
    return null;
  }
  @override
  ConfirmedPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return ConfirmedPasswordError.empty;
    if (value.length < 6) return ConfirmedPasswordError.length;
    if (value != password) return ConfirmedPasswordError.isdiferent;
      
    
    return null;
  }
}
