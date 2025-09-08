import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRespositoryImpl authRepository;
  final AuthCubit authCubit;
  final PlanCubit planCubit;

  LogoutCubit({
    required this.authRepository,
    required this.authCubit,
    required this.planCubit,
  }) : super(LogoutInitial());

  Future<void> logOut() async {
    emit(LogoutLoading());
    try {
      await authRepository.logOut();

      // 👇 limpiar los cubits locales
      authCubit.logout();
      planCubit.reset(); // este método lo agregas en PlanCubit

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutError('Error inesperado: $e'));
    }
  }
}
