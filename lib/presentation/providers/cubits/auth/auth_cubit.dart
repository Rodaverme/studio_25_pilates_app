import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/domain/entities/user.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDatasourceImpl datasourceImpl;

  AuthCubit(this.datasourceImpl) : super(const AuthState());

  // 🔹 Verifica si hay token y usuario autenticado
  Future<void> checkAuthStatus() async {
    final token = await TokenService.getToken();

    if (token == null || token.isEmpty) {
      emit(const AuthState());
      return;
    }

    try {
      // 🔹 Intenta obtener el cliente actual (usa un endpoint protegido)
      await datasourceImpl.getCurrentClient();

      // Si no lanza excepción, el token es válido
      emit(state.copyWith(isAuthenticated: true));
    } catch (e) {
      // 🔹 Si lanza excepción, asumimos que el token no es válido o expiró
      await TokenService.deleleteToken();
      emit(const AuthState());
    }
  }

  // 🔹 Actualiza el usuario en el estado
  void setUser(User client) {
    emit(state.copyWith(client: client, isAuthenticated: true));
  }

  // 🔹 Obtiene el cliente actual desde el backend
  Future<void> getCurrentClient() async {
    emit(state.copyWith(isLoading: true));
    try {
      final client = await datasourceImpl.getCurrentClient();
      emit(
        state.copyWith(client: client, isLoading: false, isAuthenticated: true),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }



  // 🔹 Cierra sesión
  void logout() {
    emit(const AuthState());
  }

  /// 🔸 Actualiza los datos del usuario
  Future<void> updateUser({
    required String name,
    required String email,
    required String avatarUrl,
    required String language,
    required String birthdate,
    required String gender,
    required String phone,
    required String documentType,
    required String documentNumber,
    required String businessName,
    required String pathology,
    required String personType,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await datasourceImpl.updateUser(
        name,
        email,
        avatarUrl,
        language,
        birthdate,
        gender,
        phone,
        documentType,
        documentNumber,
        businessName,
        pathology,
        personType,
      );

      // Refrescamos el cliente actualizado
      final updatedClient = await datasourceImpl.getCurrentClient();

      emit(state.copyWith(client: updatedClient, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 🔸 Carga tipos de documento desde el backend
  Future<void> loadDocumentTypes() async {
    emit(state.copyWith(isLoading: true));
    try {
      final types = await datasourceImpl.getDocumentTypes();
      emit(state.copyWith(documentTypes: types, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 🔸 Carga tipos de género
  Future<void> loadGenderTypes() async {
    emit(state.copyWith(isLoading: true));
    try {
      final types = await datasourceImpl.getGendertypes();
      emit(state.copyWith(genderTypes: types, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// 🔸 Carga tipos de organización / persona
  Future<void> loadOrganizationTypes() async {
    emit(state.copyWith(isLoading: true));
    try {
      final types = await datasourceImpl.getOrganizationTypes();
      emit(state.copyWith(organizationTypes: types, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
