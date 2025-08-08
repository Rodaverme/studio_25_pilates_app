part of 'user_cubit.dart';

class UserState extends Equatable {
  final Client? client;
  final String? token;
  final bool isAuthenticated;
  const UserState({this.client, this.token, this.isAuthenticated = false});

  UserState copyWith({Client? client, String? token, bool? isAuthenticated}) {
    return UserState(
      client: client ?? this.client,
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object> get props => [?client, ?token, isAuthenticated];
}


