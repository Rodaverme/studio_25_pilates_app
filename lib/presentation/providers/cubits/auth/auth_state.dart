part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final User? client;
  final bool isAuthenticated;

  const AuthState({
    this.client,
    this.isAuthenticated = false,
  });

AuthState copyWith({
    User? client,
    bool? isAuthenticated,
  }) {
    return AuthState(
      client: client ?? this.client,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

@override
  List<Object?> get props => [client, isAuthenticated];

}