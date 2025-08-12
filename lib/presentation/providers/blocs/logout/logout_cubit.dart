import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRespositoryImpl authRepository;
  LogoutCubit({required this.authRepository}) : super(LogoutInitial());

  Future<void> logOut() async {
    emit(LogoutLoading());
    try {
      await authRepository.logOut();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError('Error inesperado: $e'));
    }
  }
}
