import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRespositoryImpl authRepository;
  final AuthCubit authCubit;

  LoginCubit({required this.authCubit,required this.authRepository}) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await authRepository.login(email, password);

      authCubit.setUser(user.client);
      emit(LoginSuccess());
        } catch (e) {
      emit(LoginError("Error inesperado: $e"));
    }
  }
}
