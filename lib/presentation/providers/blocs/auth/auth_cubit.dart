import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void setUser(Client client) {
    emit(state.copyWith(client: client, isAuthenticated: true));
  }

  void logout() {
    emit(AuthState());
  }


}