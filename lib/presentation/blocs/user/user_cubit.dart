import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());

  void setUser(Client client, String tokem) {
    emit(UserState(client: client, token: tokem, isAuthenticated: true));
  }

  void clearUser() {
    emit(const UserState());
  }
}
