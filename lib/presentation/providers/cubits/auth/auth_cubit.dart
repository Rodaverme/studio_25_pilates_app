import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/domain/entities/user.dart';



part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  void setUser(User client) {
    emit(state.copyWith(client: client, isAuthenticated: true));
  }

  void logout() {
    emit(AuthState());
   
    
  }


  


}