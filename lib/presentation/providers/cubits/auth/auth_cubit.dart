import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/domain/entities/user.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';

import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDatasourceImpl datasourceImpl;
  AuthCubit(this.datasourceImpl) : super(AuthState());

  Future<void> checkAuthStatus() async {
    final token = await TokenService.getToken();
    if (token != null && token.isNotEmpty) {
      emit(state.copyWith(isAuthenticated: true));
    } else {
      emit(const AuthState()); // no autenticado
    }
  }

  void setUser(User client) {
    emit(state.copyWith(isAuthenticated: true));
  }

  void getCurrentClient() async {
    final client = await datasourceImpl.getCurrentClient();
    emit(state.copyWith(client: client));
  }

  void logout() {
    emit(AuthState());
  }
}
