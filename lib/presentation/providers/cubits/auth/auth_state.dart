part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final User? client;
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> documentTypes;
  final Map<String, String> genderTypes;
  final Map<String, String> organizationTypes;

  const AuthState({
    this.client,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
    this.documentTypes = const {},
    this.genderTypes = const {},
    this.organizationTypes = const {},
  });

  AuthState copyWith({
    User? client,
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? documentTypes,
    Map<String, String>? genderTypes,
    Map<String, String>? organizationTypes,
  }) {
    return AuthState(
      client: client ?? this.client,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      documentTypes: documentTypes ?? this.documentTypes,
      genderTypes: genderTypes ?? this.genderTypes,
      organizationTypes: organizationTypes ?? this.organizationTypes,
    );
  }

  @override
  List<Object?> get props => [
        client,
        isAuthenticated,
        isLoading,
        errorMessage,
        documentTypes,
        genderTypes,
        organizationTypes,
      ];
}
