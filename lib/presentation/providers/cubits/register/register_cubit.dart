import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRespositoryImpl authRespository;
  RegisterCubit({required this.authRespository}) : super(RegisterInitial());

  Future<void> register(String name, String email, String password,String confirmedPassword) async {
    emit(RegisterLoading());
    try {
      await authRespository.register(name, email, password, confirmedPassword);

      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError('Error ineseperado $e'));
    }
  }
}
